cmake_minimum_required(VERSION 3.0)

project(plasma-luna3)

find_package(ECM 1.4.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

find_package(KF6Plasma REQUIRED)

plasma_install_package(package org.kde.userbase.plasma.luna3)
