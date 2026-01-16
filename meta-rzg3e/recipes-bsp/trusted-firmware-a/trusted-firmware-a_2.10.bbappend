FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

python () {
    if 'RZG3E_CM33_BOOT' in d.getVar('MACHINE_FEATURES').split():
        d.appendVar('EXTRA_OEMAKE', ' ENABLE_RZG3E_CM33_BOOT=1')
        d.appendVar('EXTRA_OEMAKE', ' PLAT_SYSTEM_SUSPEND=0')
        
    if 'CM33_FIRMWARE_LOAD' in d.getVar('MACHINE_FEATURES').split():
        d.appendVar('EXTRA_OEMAKE', ' ENABLE_CM33_FIRMWARE_LOAD=1')
        
    if 'CM55_CPU_CLOCKUP' in d.getVar('MACHINE_FEATURES').split():
        d.appendVar('EXTRA_OEMAKE', ' ENABLE_CA55_CLOCKUP=1')
}

SRC_URI:append = " \
        file://0001-cm33coldboot-support.patch \
        file://0002-cm33-firmware-load.patch \
        file://0003-ca55-cpu-clockup.patch \
"
