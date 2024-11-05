cmake_minimum_required(VERSION 3.5)

project(plasma-luna3)

find_package(ECM 1.4.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

find_package(Plasma REQUIRED)
find_package(KF6I18n REQUIRED)

add_subdirectory(src)


add_definitions(-DTRANSLATION_DOMAIN=\"plasma_applet_org.kde.userbase.plasma.luna3.pot\")

ki18n_install(po)

plasma_install_package(package org.kde.userbase.plasma.luna3)

