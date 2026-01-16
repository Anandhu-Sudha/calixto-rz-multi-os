# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
#
# The following license files were not able to be identified and are
# represented as "Unknown" below, you will need to check them yourself:
#   LICENSE.md
# LICENSE = "GPLv2"
# LIC_FILES_CHKSUM = "file://LICENSE.md;md5=d04e5728481313a12d0dd566e1d51e35"

LICENSE = "CLOSED"

SUMMARY = "awo-notifier"
SECTION = "awo-notifier"
DEPENDS = "linux-renesas"
inherit module

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"
INHIBIT_SYSROOT_STRIP = "1"

SRC_URI = " \ 
    file://awo-notifier.c \
    file://LICENSE.md \
    file://Makefile"

S = "${WORKDIR}"

FILES:${PN} = "/home/root/awo-notifier.ko"

do_compile() {
    echo "awo-notifier compile"
    oe_runmake V=1
}

do_install() {
    install -d ${D}/home/root
    install -m 0755 awo-notifier.ko ${D}/home/root
}
