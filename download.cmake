inquire_message(INFO "Triggering installation of FileInformation in version ${FileInformation_VERSION}... ")

#---------------------------------------------------------------------------------------#
#-                                      DOWNLOAD                                       -#
#---------------------------------------------------------------------------------------#
set(l_IPM_archive_name "${FileInformation_VERSION}.tar.gz")
set(l_IPM_FI_location "https://github.com/sakra/FileInformation/archive/${l_IPM_archive_name}")
set(l_IPM_FI_local_dir ${FileInformation_PACKAGE_ROOT}/${FileInformation_VERSION})
set(l_IPM_FI_local_archive "${l_IPM_FI_local_dir}/download/${l_IPM_archive_name}")

if(NOT EXISTS "${l_IPM_FI_local_archive}")
	inquire_message(INFO "Downloading FileInformation ${FileInformation_VERSION} from ${l_IPM_FI_location}.")
	file(DOWNLOAD "${l_IPM_FI_location}" "${l_IPM_FI_local_archive}" SHOW_PROGRESS STATUS l_IPM_download_status)
	list(GET l_IPM_download_status 0 l_IPM_download_status_code)
	list(GET l_IPM_download_status 1 l_IPM_download_status_string)
	if(NOT l_IPM_download_status_code EQUAL 0)
		inquire_message(FATAL_ERROR "Error: downloading ${l_IPM_FI_location} failed with error : ${l_IPM_download_status_string}")
	endif()
else()
		inquire_message(INFO "Using already downloaded Boost version from ${l_IPM_FI_local_archive}")
endif()

#---------------------------------------------------------------------------------------#
#-                                       EXTRACT                                       -#
#---------------------------------------------------------------------------------------#
if(EXISTS ${l_IPM_FI_local_dir}/source/FileInformation-${FileInformation_VERSION}/)
	inquire_message(INFO "Folder ${l_IPM_FI_local_dir}/source/FileInformation-${FileInformation_VERSION}/ already exists. ")
else()
	inquire_message(INFO "Extracting FileInformation ${FileInformation_VERSION}...")
	file(MAKE_DIRECTORY ${l_IPM_FI_local_dir}/source/)
	execute_process(COMMAND ${CMAKE_COMMAND} -E tar xzf ${l_IPM_FI_local_archive} WORKING_DIRECTORY ${l_IPM_FI_local_dir}/source/)
	inquire_message(INFO "Extracting FileInformation ${FileInformation_VERSION}... DONE.")
endif()

set(FileInformation_PACKAGE_VERSION_ROOT ${l_IPM_FI_local_dir})
