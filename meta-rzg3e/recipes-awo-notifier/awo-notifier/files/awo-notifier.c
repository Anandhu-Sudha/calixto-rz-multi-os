// SPDX-License-Identifier: GPL-2.0
/*
* Renesas AWO notifier driver
*
* Copyright (C) 2024 Renesas Electronics Corporation
*/
/**
* @file awo-notifier.c
* @brief AWO notifier driver
*/

#include <linux/module.h>
#include <linux/pm.h>
#include <linux/io.h>

#include <asm/sysreg.h>
#include <asm/barrier.h>

/* definitions */
/** ICU Base address */
#define ICU_BASE_ADDRESS	0x10400000
/** ICU_SWINT offset */
#define ICU_SWINT			0x0130
/** Software interrupt number to use */
#define INT_NUM_TO_USE		0
/** bit shift for CM33 SE_INT */
#define SHIFT_FOR_IM33		16
/** CPG Base address */
#define CPG_BASE_ADDRESS    0x10420000
/** CPG_LP_CTL1 offset */
#define CPG_LP_CTL1         0x0c00
/** Mask for CA55SLEEP_REQ */
#define CA55SLEEP_REQ_MASK  0xfffff0ff
/** Bit shift for CA55SLEEP_REQ */
#define SHIFT_FOR_CA55SLEEP_REQ 8
/** GIC-600 Base address */
#define GIC_BASE_ADDRESS    0x14900000
/** GICD_CTLR offset */
#define GICD_CTLR           0x0000
/** GICD_CTLR.EnableGrp* write mask */
#define GICD_CTLR_EGPR_MASK 0xfffffff8
/** GICD_CTLR.RWP read mask */
#define GICD_CTLR_RWP_MASK  0x80000000

MODULE_LICENSE("GPL v2");

static void pm_power_off_func(void);
static void awo_notify(void);
static int awo_notifier_init(void);
static void awo_notifier_exit(void);

/* variables */
/** function pointer that already exist */
void (*pm_power_off_already)(void) = 0;

/**
* @brief Execute power-off sequence
* 
*/
void pm_power_off_func(void)
{
    awo_notify();

    printk("awo_notify: CA55 is sleep.\n");

    /* GIC-600 disabling */

	void __iomem *regaddr = ioremap(GIC_BASE_ADDRESS + GICD_CTLR, sizeof(u32));
    u32 reg32 = readl(regaddr);
    writel(reg32 & GICD_CTLR_EGPR_MASK, regaddr);

    do {
        reg32 = readl(regaddr);
    }while (reg32 & GICD_CTLR_RWP_MASK);

    /* CA55 all core sleep(Processing equivalent to PSCI_CPU_OFF in TF-A) */
    regaddr = ioremap(CPG_BASE_ADDRESS + CPG_LP_CTL1, sizeof(u32));
    writel(0xf << SHIFT_FOR_CA55SLEEP_REQ, regaddr);
    reg32 = readl(regaddr);
    writel(reg32 | 0x01, regaddr);
    iounmap(regaddr);

    isb();
    dsb(ish);
    wfi();

    /* halt and waiting for next sequence(power-down by CM33) */
    /* unreachable */
    while (1);
}

/**
* @brief Raise interrupt for AWO request
*/
void awo_notify(void)
{
    void __iomem *regaddr = ioremap(ICU_BASE_ADDRESS + ICU_SWINT, sizeof(u32));

    printk("awo_not.ify: Notify CM33 of request for AWO.\n");
    writel(1 << (INT_NUM_TO_USE + SHIFT_FOR_IM33), regaddr);
    iounmap(regaddr);
}

/**
* Override pm_power_off with AWO notifier
* @return =0: OK, other: Error
*/
int awo_notifier_init(void)
{
    pm_power_off_already = pm_power_off;
    pm_power_off = pm_power_off_func;
    printk("awo_notifier init\n");
    return 0;
}

/**
* Restore pm_power_off and driver unloads
*/
void awo_notifier_exit(void)
{
    pm_power_off = pm_power_off_already;
    printk("awo_notifier exit\n");
}

module_init(awo_notifier_init);
module_exit(awo_notifier_exit);
