cmake_minimum_required (VERSION 3.0.0)
project (BoostTestProject)

include(${CMAKE_CURRENT_LIST_DIR}/../../APM/APM.cmake)

#include("C:/Developpements/APM/APM/APM.cmake")
set(APM_install_FileInformation ON CACHE BOOL "")

# an APM module repository is a place (folder, GIT repo, etc.) containing CMake modules to "require" projects.
APM_add_module_repository(moduleRepo FOLDER "${CMAKE_CURRENT_SOURCE_DIR}/../")

# an APM package repository contains all the built libraries and sources.
APM_add_package_repository(packageRepo FOLDER "${CMAKE_CURRENT_BINARY_DIR}/packages/")

require_package(FileInformation VERSION 1.2.0)

file(SIZE "${CMAKE_CURRENT_BINARY_DIR}/APM.zip" l_APM_zip_size)

message(STATUS "l_APM_zip_size = ${l_APM_zip_size}")
