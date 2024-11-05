cmake_minimum_required(VERSION 3.5)

project(plasma-luna3)

find_package(ECM 1.4.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

find_package(KF6Plasma REQUIRED)

add_custom_command(OUTPUT shadow.gsb COMMAND "/usr/lib/qt6/bin/qsb package/contents/ui/shadow.frag --qt6 -o shadow.gsb")

plasma_install_package(package org.kde.userbase.plasma.luna3)
