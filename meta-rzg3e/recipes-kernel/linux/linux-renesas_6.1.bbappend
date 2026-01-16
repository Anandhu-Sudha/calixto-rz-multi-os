FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

ENABLE_REMOTEPROC = "0"

SRC_URI:append = " \
	file://0001-Add-rzg3e-smarc-multi-os-dtsi-for-supporting-OpenAMP.patch \
	file://0002-Set-GTM-as-critical-clock-to-support-RTOS.patch \
	file://0003-Change-linux-ostm-to-2-and-3.patch \
	file://0006-arm64-dts-renesas-r9a09g047-opp-1800000000.patch \
"

SRC_URI += "${@'file://0003-Add-CM33-clocks.patch \
	file://0004-Add-rproc-node-for-CM33.patch \
	file://0005-Add-bindings.patch \
	file://0006-Add-remoteproc-driver.patch' if '${ENABLE_REMOTEPROC}' == '1' else ''}"

# Kernel confguration update
SRC_URI += "file://uio.cfg"
SRC_URI += "${@'file://remoteproc.cfg' if '${ENABLE_REMOTEPROC}' == '1' else ''}"
