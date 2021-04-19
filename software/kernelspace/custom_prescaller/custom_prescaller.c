#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/io.h>
#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <linux/types.h>
#include <linux/uaccess.h>

// Prototypes
static int dev_open(struct inode *, struct file *);
static int dev_release(struct inode *, struct file *);
static int prescaller_probe(struct platform_device *pdev);
static int prescaller_remove(struct platform_device *pdev);
static ssize_t prescaller_read(struct file *file, char *buffer, size_t len, loff_t *offset);
static ssize_t prescaller_write(struct file *file, const char *buffer, size_t len, loff_t *offset);

// An instance of this structure will be created for every custom_led IP in the system
struct custom_prescaller_dev {
    struct miscdevice miscdev;
    void __iomem *regs;
    u8 prescaller_value;
};

// Specify which device tree devices this driver supports
static struct of_device_id custom_prescaller_dt_ids[] = {
    {
        .compatible = "dev,custom-prescaller"
    },
    { /* end of table */ }
};

// Inform the kernel about the devices this driver supports
MODULE_DEVICE_TABLE(of, custom_prescaller_dt_ids);

// Data structure that links the probe and remove functions with our driver
static struct platform_driver prescaller_platform = {
    .probe = prescaller_probe,
    .remove = prescaller_remove,
    .driver = {
        .name = "Custom Prescaller Driver",
        .owner = THIS_MODULE,
        .of_match_table = custom_prescaller_dt_ids
    }
};

// The file operations that can be performed on the custom_prescaller character file
static const struct file_operations custom_prescaller_fops = {
    .open = dev_open,
    .owner = THIS_MODULE,
    .read = prescaller_read,
    .write = prescaller_write,
    .release = dev_release
};

static int dev_open(struct inode *inodep, struct file *filep)
{
   printk(KERN_INFO "OPEN!");
   // numberOpens++;
   // printk(KERN_INFO "Prescaller: Device has been opened %d time(s)\n", numberOpens);
   printk(KERN_INFO "Prescaller: Device has been opened.\n");
   return 0;
}

static int dev_release(struct inode *inodep, struct file *filep)
{
   printk(KERN_INFO "RELEASE!");
   printk(KERN_INFO "Prescaller: Device successfully closed.\n");
   return 0;
}


// Called when the driver is installed
static int prescaller_init(void)
{
    int ret_val = 0;
    pr_info("Initializing the Custom Prescaller module\n");

    // Register our driver with the "Platform Driver" bus
    ret_val = platform_driver_register(&prescaller_platform);
    if(ret_val != 0) {
        pr_err("platform_driver_register returned %d\n", ret_val);
        return ret_val;
    }

    pr_info("Custom Prescaller module successfully initialized!\n");

    return 0;
}

// Called whenever the kernel finds a new device that our driver can handle
// (In our case, this should only get called for the one instantiation of the Custom Prescaller module)
static int prescaller_probe(struct platform_device *pdev)
{
    int ret_val = -EBUSY;
    struct custom_prescaller_dev *dev;
    struct resource *r = 0;

    pr_info("prescaller_probe enter\n");

    // Get the memory resources for this prescaller device
    r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
    if(r == NULL) {
        pr_err("IORESOURCE_MEM (register space) does not exist\n");
        goto bad_exit_return;
    }

    // Create structure to hold device-specific information (like the registers)
    dev = devm_kzalloc(&pdev->dev, sizeof(struct custom_prescaller_dev), GFP_KERNEL);

    // Both request and ioremap a memory region
    // This makes sure nobody else can grab this memory region
    // as well as moving it into our address space so we can actually use it
    dev->regs = devm_ioremap_resource(&pdev->dev, r);
    if(IS_ERR(dev->regs))
        goto bad_ioremap;

    // Turn the Prescaller on (access the 0th register in the custom Prescaller module)
    dev->prescaller_value = 0xA;
    iowrite32(dev->prescaller_value, dev->regs);

    // Initialize the misc device (this is used to create a character file in userspace)
    dev->miscdev.minor = MISC_DYNAMIC_MINOR;    // Dynamically choose a minor number
    dev->miscdev.name = "custom_prescaller";
    dev->miscdev.fops = &custom_prescaller_fops;

    ret_val = misc_register(&dev->miscdev);
    if(ret_val != 0) {
        pr_info("Couldn't register misc device :(");
        goto bad_exit_return;
    }

    // Give a pointer to the instance-specific data to the generic platform_device structure
    // so we can access this data later on (for instance, in the read and write functions)
    platform_set_drvdata(pdev, (void*)dev);

    pr_info("prescaller_probe exit\n");

    return 0;

bad_ioremap:
   ret_val = PTR_ERR(dev->regs); 
bad_exit_return:
    pr_info("prescaller_probe bad exit :(\n");
    return ret_val;
}

// This function gets called whenever a read operation occurs on one of the character files
static ssize_t prescaller_read(struct file *file, char *buffer, size_t len, loff_t *offset)
{
    int success = 0;

    /* 
    * Get the custom_prescaller_dev structure out of the miscdevice structure.
    *
    * Remember, the Misc subsystem has a default "open" function that will set
    * "file"s private data to the appropriate miscdevice structure. We then use the
    * container_of macro to get the structure that miscdevice is stored inside of (which
    * is our custom_prescaller_dev structure that has the current led value).
    * 
    * For more info on how container_of works, check out:
    * http://linuxwell.com/2012/11/10/magical-container_of-macro/
    */
    struct custom_prescaller_dev *dev = container_of(file->private_data, struct custom_prescaller_dev, miscdev);

    // Give the user the current led value
    success = copy_to_user(buffer, &dev->prescaller_value, sizeof(dev->prescaller_value));

    // If we failed to copy the value to userspace, display an error message
    if(success != 0) {
        pr_info("Failed to return current led value to userspace\n");
        return -EFAULT; // Bad address error value. It's likely that "buffer" doesn't point to a good address
    }

    return 0; // "0" indicates End of File, aka, it tells the user process to stop reading
}

// This function gets called whenever a write operation occurs on one of the character files
static ssize_t prescaller_write(struct file *file, const char *buffer, size_t len, loff_t *offset)
{
    int success = 0;

    /* 
    * Get the custom_prescaller_dev structure out of the miscdevice structure.
    *
    * Remember, the Misc subsystem has a default "open" function that will set
    * "file"s private data to the appropriate miscdevice structure. We then use the
    * container_of macro to get the structure that miscdevice is stored inside of (which
    * is our custom_prescaller_dev structure that has the current led value).
    * 
    * For more info on how container_of works, check out:
    * http://linuxwell.com/2012/11/10/magical-container_of-macro/
    */
    struct custom_prescaller_dev *dev = container_of(file->private_data, struct custom_prescaller_dev, miscdev);

    // Get the new led value (this is just the first byte of the given data)
    success = copy_from_user(&dev->prescaller_value, buffer, sizeof(dev->prescaller_value));

    // If we failed to copy the value from userspace, display an error message
    if(success != 0) {
        pr_info("Failed to read led value from userspace\n");
        return -EFAULT; // Bad address error value. It's likely that "buffer" doesn't point to a good address
    } else {
        // We read the data correctly, so update the Prescaller
        iowrite32(dev->prescaller_value, dev->regs);
    }

    // Tell the user process that we wrote every byte they sent 
    // (even if we only wrote the first value, this will ensure they don't try to re-write their data)
    return len;
}

// Gets called whenever a device this driver handles is removed.
// This will also get called for each device being handled when 
// our driver gets removed from the system (using the rmmod command).
static int prescaller_remove(struct platform_device *pdev)
{
    // Grab the instance-specific information out of the platform device
    struct custom_prescaller_dev *dev = (struct custom_prescaller_dev*)platform_get_drvdata(pdev);

    pr_info("prescaller_remove enter\n");

    // Turn the Prescaller off
    iowrite32(0x00, dev->regs);

    // Unregister the character file (remove it from /dev)
    misc_deregister(&dev->miscdev);

    pr_info("prescaller_remove exit\n");

    return 0;
}

// Called when the driver is removed
static void prescaller_exit(void)
{
    pr_info("Custom Prescaller module exit\n");

    // Unregister our driver from the "Platform Driver" bus
    // This will cause "prescaller_remove" to be called for each connected device
    platform_driver_unregister(&prescaller_platform);

    pr_info("Custom Prescaller module successfully unregistered\n");
}

// Tell the kernel which functions are the initialization and exit functions
module_init(prescaller_init);
module_exit(prescaller_exit);

// Define information about this kernel module
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Franz Luepke");
MODULE_DESCRIPTION("Exposes a character device to user space that lets users turn Prescaller on and off");
MODULE_VERSION("1.0");
