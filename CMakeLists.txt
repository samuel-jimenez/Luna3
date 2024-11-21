cmake_minimum_required(VERSION 3.10)

project(plasma-luna3)


find_package(Plasma REQUIRED)


add_subdirectory(src)

file(
  GLOB_RECURSE
  ui_files
  package/contents/*.qml
  package/contents/*.js
)


add_custom_target(pofiles ALL
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/package/po/plasma_applet_org.kde.userbase.plasma.luna3.pot
	)

add_custom_command(
	OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/package/po/plasma_applet_org.kde.userbase.plasma.luna3.pot
	COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/package/po/Messages.sh
	DEPENDS ${ui_files}
	)

plasma_install_package(package org.kde.userbase.plasma.luna3)

add_custom_target(plasmoid
	COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/mkzip
	DEPENDS pofiles
	DEPENDS shaders
	)
