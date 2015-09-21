cmake_minimum_required (VERSION 3.0.0)
project (BoostTestProject)

include(${CMAKE_CURRENT_LIST_DIR}/../../Inquire/Inquire.cmake)

set(IPM_install_FileInformation ON CACHE BOOL "")

# an IPM module repository is a place (folder, GIT repo, etc.) containing CMake modules to "require" projects.
inquire_add_module_repository(moduleRepo FOLDER "${CMAKE_CURRENT_SOURCE_DIR}/../")

# an IPM package repository contains all the built libraries and sources.
inquire_add_package_repository(packageRepo FOLDER "${CMAKE_CURRENT_BINARY_DIR}/packages/")

require_package(FileInformation VERSION 1.2.0)

file(SIZE "${CMAKE_CURRENT_LIST_DIR}/../../Inquire/Inquire.cmake" l_IPM_zip_size)

message(STATUS "l_IPM_zip_size = ${l_IPM_zip_size}")
