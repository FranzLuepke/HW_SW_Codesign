#include <linux/module.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

MODULE_INFO(vermagic, VERMAGIC_STRING);
MODULE_INFO(name, KBUILD_MODNAME);

__visible struct module __this_module
__attribute__((section(".gnu.linkonce.this_module"))) = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};

#ifdef CONFIG_RETPOLINE
MODULE_INFO(retpoline, "Y");
#endif

static const struct modversion_info ____versions[]
__used
__attribute__((section("__versions"))) = {
	{ 0x1a4cfd43, __VMLINUX_SYMBOL_STR(module_layout) },
	{ 0xb25f0ef5, __VMLINUX_SYMBOL_STR(platform_driver_unregister) },
	{ 0x40fbab28, __VMLINUX_SYMBOL_STR(__platform_driver_register) },
	{ 0xf9cf1802, __VMLINUX_SYMBOL_STR(misc_register) },
	{ 0x7eb036e5, __VMLINUX_SYMBOL_STR(devm_ioremap_resource) },
	{ 0xa5f38b7f, __VMLINUX_SYMBOL_STR(devm_kmalloc) },
	{ 0xec6cce7b, __VMLINUX_SYMBOL_STR(platform_get_resource) },
	{ 0xf4fa543b, __VMLINUX_SYMBOL_STR(arm_copy_to_user) },
	{ 0xfa2a45e, __VMLINUX_SYMBOL_STR(__memzero) },
	{ 0x28cc25db, __VMLINUX_SYMBOL_STR(arm_copy_from_user) },
	{ 0xefd6cf06, __VMLINUX_SYMBOL_STR(__aeabi_unwind_cpp_pr0) },
	{ 0xbc4702ca, __VMLINUX_SYMBOL_STR(misc_deregister) },
	{ 0x822137e2, __VMLINUX_SYMBOL_STR(arm_heavy_mb) },
	{ 0x2e5810c6, __VMLINUX_SYMBOL_STR(__aeabi_unwind_cpp_pr1) },
	{ 0x27e1a049, __VMLINUX_SYMBOL_STR(printk) },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";

MODULE_ALIAS("of:N*T*Cdev,custom-pwm");
MODULE_ALIAS("of:N*T*Cdev,custom-pwmC*");

MODULE_INFO(srcversion, "827F76585422DE8413CB8E0");
