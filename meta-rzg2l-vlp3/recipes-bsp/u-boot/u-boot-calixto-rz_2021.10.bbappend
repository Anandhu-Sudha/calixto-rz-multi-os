FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://0001-disable-reserved-area-check.patch \
    file://0002-cmd-Add-cm33-command.patch \
    file://u-boot-multi-os.patch \   
"
