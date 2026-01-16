python () {
    bl2_addr = "0x08004000"
    if "RZG3E_CM33_BOOT" in d.getVar("MACHINE_FEATURES", True).split():
        bl2_addr = "0x08020000"
        d.setVar("BL2_ADJUST_VMA", "0x60100000")
        d.setVar("FIP_ADJUST_VMA", "0x60160000")
    d.setVar("BL2_LOAD_ADDR", bl2_addr)
}

do_compile () {
	# Create bl2_bp.bin
	for bl2boot in ${BL2_BOOT_TARGET}; do
		# Create bl2_bp.bin
		bptool ${SYSROOT_TFA}/bl2.bin ${S}/bp.bin ${BL2_LOAD_ADDR} $bl2boot
		cat ${S}/bp.bin ${SYSROOT_TFA}/bl2.bin > ${S}/bl2_bp_$bl2boot.bin

		# Conver BL2 to S-Record
		objcopy -I binary -O srec --adjust-vma=${BL2_ADJUST_VMA} --srec-forceS3 ${S}/bl2_bp_$bl2boot.bin ${S}/bl2_bp_$bl2boot.srec
	done

	# Convert FIP to S-Record
	cp ${SYSROOT_TFA}/fip.bin ${S}/fip-${MACHINE}.bin
	objcopy -I binary -O srec --adjust-vma=${FIP_ADJUST_VMA} --srec-forceS3 ${SYSROOT_TFA}/fip.bin ${S}/fip-${MACHINE}.srec

	if [ "${PMIC_SUPPORT}" = "1" ]; then
		# Create bl2_bp.bin
		for bl2boot in ${BL2_BOOT_TARGET}; do
			# Create bl2_bp.bin
			bptool ${SYSROOT_TFA}/bl2-${TFA_PLATFORM}_pmic.bin ${S}/bp-${TFA_PLATFORM}_pmic.bin ${BL2_LOAD_ADDR} $bl2boot
			cat ${S}/bp-${TFA_PLATFORM}_pmic.bin ${SYSROOT_TFA}/bl2-${TFA_PLATFORM}_pmic.bin > ${S}/bl2_bp_${bl2boot}_pmic.bin

			# Conver BL2 to S-Record
			objcopy -I binary -O srec --adjust-vma=${BL2_ADJUST_VMA} --srec-forceS3 ${S}/bl2_bp_${bl2boot}_pmic.bin ${S}/bl2_bp_${bl2boot}_pmic.srec
		done

		# Convert FIP to S-Record
		cp ${SYSROOT_TFA}/fip-${TFA_PLATFORM}_pmic.bin ${S}/fip-${MACHINE}_pmic.bin
		objcopy -I binary -O srec --adjust-vma=${FIP_ADJUST_VMA} --srec-forceS3 ${SYSROOT_TFA}/fip-${TFA_PLATFORM}_pmic.bin ${S}/fip-${MACHINE}_pmic.srec
	fi
}
