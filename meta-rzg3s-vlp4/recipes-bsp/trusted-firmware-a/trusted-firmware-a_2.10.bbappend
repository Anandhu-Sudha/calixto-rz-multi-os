FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

python () {
    features = d.getVar('MACHINE_FEATURES').split()

    if 'RZG3S_CM33_BOOT_IN_BL2' in features:
        d.appendVar('EXTRA_OEMAKE', ' PLAT_M33_BOOT_SUPPORT=1')
    if 'RZG3S_CM33_COLDBOOT' in features:
        d.appendVar('EXTRA_OEMAKE', ' ENABLE_RZG3S_CM33_COLDBOOT=1')
    if 'RZG3S_AWO_SUPPORT' in features:
        d.appendVar('EXTRA_OEMAKE', ' PLAT_SYSTEM_SUSPEND=awo')
}

SRC_URI += " \
    file://0001-cm33coldboot-support.patch \
"
