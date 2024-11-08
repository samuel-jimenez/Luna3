cmake_minimum_required(VERSION 3.10)

project(plasma-luna3)

find_package(ECM 1.4.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})


add_custom_target(shaders ALL
	DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/shadow.qsb
	)

add_custom_command(
	OUTPUT shadow.qsb
	COMMAND /usr/lib/qt6/bin/qsb ${CMAKE_CURRENT_SOURCE_DIR}/shadow.frag --qt6 -o ${CMAKE_CURRENT_BINARY_DIR}/shadow.qsb
	COMMAND cp ${CMAKE_CURRENT_BINARY_DIR}/shadow.qsb ${CMAKE_CURRENT_SOURCE_DIR}/../package/contents/ui/
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/shadow.frag)
