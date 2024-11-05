cmake_minimum_required(VERSION 3.5)

project(plasma-luna3)

find_package(ECM 1.4.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

add_custom_target(shadow.gsb ALL
	COMMAND /usr/lib/qt6/bin/qsb ${CMAKE_CURRENT_SOURCE_DIR}/shadow.frag --qt6 -o ${CMAKE_CURRENT_BINARY_DIR}/shadow.gsb
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/shadow.frag)

add_custom_command(
	TARGET shadow.gsb
	POST_BUILD
	COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/shadow.gsb ../package/contents/ui/)
