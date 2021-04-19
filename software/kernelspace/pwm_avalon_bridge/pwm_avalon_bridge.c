// Linux imports
#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/io.h>
#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <linux/types.h>
#include <linux/uaccess.h>
// Variables
static short procfs_buffer_size = 0;
// Prototypes
static int dev_open(struct inode *, struct file *);
static int dev_release(struct inode *, struct file *);
static int pwm_probe(struct platform_device *pdev);
static int pwm_remove(struct platform_device *pdev);
static ssize_t pwm_read(struct file *file, char *buffer, size_t len, loff_t *offset);
static ssize_t pwm_write(struct file *file, const char *buffer, size_t len, loff_t *offset);
// An instance of this structure will be created for every pwm IP in the system
struct pwm_dev
{
    struct miscdevice miscdev;
    void __iomem *regs;
    u8 pwm_value;
};
// Specify which device tree devices this driver supports
static struct of_device_id pwm_dt_ids[] = {
    { .compatible = "dev,pwm-avalon-bridge"},
    { /* end of table */ }
};
// Inform the kernel about the devices this driver supports
MODULE_DEVICE_TABLE(of, pwm_dt_ids);
// Data structure that links the probe and remove functions with our driver
static struct platform_driver pwm_platform = {
    .probe = pwm_probe,
    .remove = pwm_remove,
    .driver = {
        .name = "PWM Avalon Bridge Driver",
        .owner = THIS_MODULE,
        .of_match_table = pwm_dt_ids
    }
};
// The file operations that can be performed on the pwm character file
static const struct file_operations pwm_fops =
{
    .open = dev_open,
    .owner = THIS_MODULE,
    .read = pwm_read,
    .write = pwm_write,
    .release = dev_release
};

static int dev_open(struct inode *inodep, struct file *filep)
{
   // numberOpens++;
   // printk(KERN_INFO "EBBChar: Device has been opened %d time(s)\n", numberOpens);
   printk(KERN_INFO " PWM_open: Device has been opened.\n");
   return 0;
}

static int dev_release(struct inode *inodep, struct file *filep)
{
   printk(KERN_INFO " PWM_release: Device successfully closed.\n");
   return 0;
}
// Called when the driver is installed
static int pwm_init(void)
{
    int ret_val = 0;
    pr_info("------------------- PWM MODULE -------------------\n");
    pr_info(" PWM_init: Initializing the Custom PWM module\n");
    // Register our driver with the "Platform Driver" bus
    ret_val = platform_driver_register(&pwm_platform);
    if(ret_val != 0)
    {
        pr_err(" PWM_init: platform_driver_register returned %d\n", ret_val);
        return ret_val;
    }
    pr_info(" PWM_init: Custom PWM module successfully initialized!\n");
    return 0;
}
// Called whenever the kernel finds a new device that our driver can handle
// (In our case, this should only get called for the one instantiation of the Custom PWM module)
static int pwm_probe(struct platform_device *pdev)
{
    int ret_val = -EBUSY;
    struct pwm_dev *dev;
    struct resource *r = 0;

    pr_info(" PWM_probe: Started...\n");

    // Get the memory resources for this PWM device
    r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
    if(r == NULL)
    {
        pr_err(" PWM_probe: IORESOURCE_MEM (register space) does not exist\n");
        goto bad_exit_return;
    }
    // Create structure to hold device-specific information (like the registers)
    dev = devm_kzalloc(&pdev->dev, sizeof(struct pwm_dev), GFP_KERNEL);
    // Both request and ioremap a memory region
    // This makes sure nobody else can grab this memory region
    // as well as moving it into our address space so we can actually use it
    dev->regs = devm_ioremap_resource(&pdev->dev, r);
    if(IS_ERR(dev->regs))
        goto bad_ioremap;

    // Turn the PWM on (access the 0th register in the PWM module)
    dev->pwm_value = 0x00;
    iowrite32(dev->pwm_value, dev->regs);

    pr_info(" PWM_probe: Registering robocol_pwm device.\n");
    // Initialize the misc device (this is used to create a character file in userspace)
    dev->miscdev.minor = MISC_DYNAMIC_MINOR;    // Dynamically choose a minor number
    dev->miscdev.name = "robocol_pwm";
    dev->miscdev.fops = &pwm_fops;

    ret_val = misc_register(&dev->miscdev);
    if(ret_val != 0)
    {
        pr_info(" PWM_probe: Couldn't register misc device :(");
        goto bad_exit_return;
    }
    // Give a pointer to the instance-specific data to the generic platform_device structure
    // so we can access this data later on (for instance, in the read and write functions)
    platform_set_drvdata(pdev, (void*)dev);
    pr_info(" PWM_probe: Finished\n");
    return 0;

    bad_ioremap:
       ret_val = PTR_ERR(dev->regs); 
    bad_exit_return:
        pr_info(" PWM_probe: bad exit :(\n");
        return ret_val;
}

// This function gets called whenever a read operation occurs on one of the character files
static ssize_t pwm_read(struct file *file, char *buffer, size_t len, loff_t *offset)
{
    struct pwm_dev *dev = container_of(file->private_data, struct pwm_dev, miscdev);
    int success = 0;

    /* 
    * Get the pwm_dev structure out of the miscdevice structure.
    *
    * Remember, the Misc subsystem has a default "open" function that will set
    * "file"s private data to the appropriate miscdevice structure. We then use the
    * container_of macro to get the structure that miscdevice is stored inside of (which
    * is our pwm_dev structure that has the current pwm value).
    * 
    * For more info on how container_of works, check out:
    * http://linuxwell.com/2012/11/10/magical-container_of-macro/
    */

    // Give the user the current pwm value
    success = copy_to_user(buffer, &dev->pwm_value, sizeof(dev->pwm_value));

    // If we failed to copy the value to userspace, display an error message
    if(success != 0)
    {
        pr_info(" PWM_read: Failed to return current pwm value to userspace\n");
        return -EFAULT; // Bad address error value. It's likely that "buffer" doesn't point to a good address
    }

    return 0; // "0" indicates End of File, aka, it tells the user process to stop reading
}
// This function gets called whenever a write operation occurs on one of the character files
static ssize_t pwm_write(struct file *file, const char *buffer, size_t len, loff_t *offset)
{
    /* 
    * Get the pwm_dev structure out of the miscdevice structure.
    *
    * Remember, the Misc subsystem has a default "open" function that will set
    * "file"s private data to the appropriate miscdevice structure. We then use the
    * container_of macro to get the structure that miscdevice is stored inside of (which
    * is our pwm_dev structure that has the current pwm value).
    * 
    * For more info on how container_of works, check out:
    * http://linuxwell.com/2012/11/10/magical-container_of-macro/
    */
    int success = 0;
    struct pwm_dev *dev = container_of(file->private_data, struct pwm_dev, miscdev);
    printk(KERN_INFO " PWM_write: Begin.\n");

    procfs_buffer_size = len;
    printk(KERN_INFO " PWM_write: Buffer size is %d\n", len);
    // Get the new pwm value (this is just the first byte of the given data)
    printk(KERN_INFO " PWM_write: Getting value from user...\n");
    success = copy_from_user(&dev->pwm_value, buffer, sizeof(dev->pwm_value));
    printk(KERN_INFO " PWM_write: success: %d\n",success);
    printk(KERN_INFO " PWM_write: success: %u\n", (unsigned int)&dev->pwm_value);
    // If we failed to copy the value from userspace, display an error message
    if(success != 0)
    {
        pr_info("PWM_write: Failed to read pwm value from userspace\n");
        return -EFAULT; // Bad address error value. It's likely that "buffer" doesn't point to a good address
    }
    else
    {
        // We read the data correctly, so update the PWM
        // printk(KERN_INFO "Good");
        iowrite32(dev->pwm_value, dev->regs);
    }
    // Tell the user process that we wrote every byte they sent 
    // (even if we only wrote the first value, this will ensure they don't try to re-write their data)
    return len;
}
// Gets called whenever a device this driver handles is removed.
// This will also get called for each device being handled when 
// our driver gets removed from the system (using the rmmod command).
static int pwm_remove(struct platform_device *pdev)
{
    // Grab the instance-specific information out of the platform device
    struct pwm_dev *dev = (struct pwm_dev*)platform_get_drvdata(pdev);
    pr_info(" PWM_remove: pwm_remove enter\n");
    // Turn the PWM off
    iowrite32(0x00, dev->regs);
    // Unregister the character file (remove it from /dev)
    misc_deregister(&dev->miscdev);
    pr_info(" PWM_remove: pwm_remove exit\n");
    return 0;
}
// Called when the driver is removed
static void pwm_exit(void)
{
    pr_info(" PWM_exit: Custom PWM module exit\n");
    // Unregister our driver from the "Platform Driver" bus
    // This will cause "pwm_remove" to be called for each connected device
    platform_driver_unregister(&pwm_platform);
    pr_info(" PWM_exit: Custom PWM module successfully unregistered\n");
}
// Tell the kernel which functions are the initialization and exit functions
module_init(pwm_init);
module_exit(pwm_exit);
// Define information about this kernel module
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Franz Luepke");
MODULE_DESCRIPTION("Exposes a PWM device to user space that lets users change PWM.");
MODULE_VERSION("1.0");
