
px4_add_board(
	BOARD nuttx_cannode-v1_default
	OS nuttx
	ARCH cortex-m3
	)

add_definitions(
	-DPARAM_NO_ORB
	-DPARAM_NO_AUTOSAVE
	)

# UAVCAN boot loadable Module ID
set(uavcanblid_sw_version_major 0)
set(uavcanblid_sw_version_minor 1)
add_definitions(
	-DAPP_VERSION_MAJOR=${uavcanblid_sw_version_major}
	-DAPP_VERSION_MINOR=${uavcanblid_sw_version_minor}
	)

# Bring in common uavcan hardware identity definitions
include(common/px4_git)
px4_add_git_submodule(TARGET git_uavcan_board_ident PATH "cmake/configs/uavcan_board_ident")
include(configs/uavcan_board_ident/px4cannode-v1)

add_definitions(
	-DHW_UAVCAN_NAME=${uavcanblid_name}
	-DHW_VERSION_MAJOR=${uavcanblid_hw_version_major}
	-DHW_VERSION_MINOR=${uavcanblid_hw_version_minor}
)

include(px4_make_uavcan_bootloader)
px4_make_uavcan_bootloadable(BOARD ${BOARD}
	BIN ${PX4_BINARY_DIR}/platforms/nuttx/px4cannode-v1.bin
	HWNAME ${uavcanblid_name}
	HW_MAJOR ${uavcanblid_hw_version_major}
	HW_MINOR ${uavcanblid_hw_version_minor}
	SW_MAJOR ${uavcanblid_sw_version_major}
	SW_MINOR ${uavcanblid_sw_version_minor}
)

set(config_module_list
	#
	# Board support modules
	#
	drivers/boards
	drivers/bootloaders
	drivers/device
	drivers/led
	drivers/stm32

	#
	# System commands
	#
	systemcmds/config
	systemcmds/reboot
	systemcmds/top
	systemcmds/ver

	#
	# General system control
	#
	modules/uavcannode

	#
	# Library modules
	#
	lib/version
	modules/systemlib
	modules/systemlib/param
	modules/uORB
)