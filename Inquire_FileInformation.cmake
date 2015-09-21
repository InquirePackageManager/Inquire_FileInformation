function(check_package_compatibility a_IPM_result)
  IPM_check_package_compatibility_parse_arguments(l_IPM_check_package_compatibility ${ARGN})

  if(${CMAKE_VERSION} VERSION_LESS 2.8)
    set(${a_IPM_result} FALSE PARENT_SCOPE)
    set(${l_IPM_check_package_compatibility_DETAILS} "The FileInformation CMake module requires CMake 2.8 or greater.")
    return()
  endif()

  set(${a_IPM_result} TRUE PARENT_SCOPE)
endfunction()


function(get_compatible_package_version_root a_IPM_package_root a_IPM_version a_IPM_result)
	IPM_get_compatible_package_version_root_parse_arguments(l_IPM_get_compatible_package_version_root ${ARGN})
	IPM_get_subdirectories(${a_IPM_package_root} l_IPM_version_dirs)

	#try to find a matching version
	foreach(l_IPM_version_dir ${l_IPM_version_dirs})
		set(l_IPM_version_compatible FALSE)
		# first check that the project has been installed. If so, check version compatibility.
		#TODO add path to test file
		if(EXISTS ${a_IPM_package_root}/${l_IPM_version_dir}/install/)
			if(${l_IPM_version_dir} VERSION_EQUAL ${a_IPM_version})
				set(l_IPM_version_compatible TRUE)
				set(${a_IPM_result} ${a_IPM_package_root}/${l_IPM_version_dir} PARENT_SCOPE)
				break()
			else()
				#we assume that greater versions are backward compatible
				if(${l_IPM_version_dir} VERSION_GREATER ${a_IPM_version} AND NOT ${l_IPM_get_compatible_package_version_root_EXACT})
					set(l_IPM_version_compatible TRUE)
					set(${a_IPM_result} ${a_IPM_package_root}/${l_IPM_version_dir} PARENT_SCOPE)
					break()
				endif()
			endif()
		endif()
	endforeach()
endfunction()

function(download_package_version a_IPM_package_root a_IPM_result a_IPM_version)
	inquire_message(INFO "Triggering installation of FileInformation in version ${a_IPM_version}... ")

	#---------------------------------------------------------------------------------------#
	#-										DOWNLOAD									   -#
	#---------------------------------------------------------------------------------------#
  set(l_IPM_archive_name "${a_IPM_version}.tar.gz")
	set(l_IPM_FI_location "https://github.com/sakra/FileInformation/archive/${l_IPM_archive_name}")
	set(l_IPM_FI_local_dir ${a_IPM_package_root}/${a_IPM_version})
	set(l_IPM_FI_local_archive "${l_IPM_FI_local_dir}/download/${l_IPM_archive_name}")

	if(NOT EXISTS "${l_IPM_FI_local_archive}")
		inquire_message(INFO "Downloading FileInformation ${a_IPM_version} from ${l_IPM_FI_location}.")
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
	#-										EXTRACT 									   -#
	#---------------------------------------------------------------------------------------#
	if(EXISTS ${l_IPM_FI_local_dir}/source/FileInformation-${a_IPM_version}/)
		inquire_message(INFO "Folder ${l_IPM_FI_local_dir}/source/FileInformation-${a_IPM_version}/ already exists. ")
	else()
		inquire_message(INFO "Extracting FileInformation ${a_IPM_version}...")
		file(MAKE_DIRECTORY ${l_IPM_FI_local_dir}/source/)
		execute_process(COMMAND ${CMAKE_COMMAND} -E tar xzf ${l_IPM_FI_local_archive} WORKING_DIRECTORY ${l_IPM_FI_local_dir}/source/)
		inquire_message(INFO "Extracting FileInformation ${a_IPM_version}... DONE.")
	endif()

	set(${a_IPM_result} ${l_IPM_FI_local_dir} PARENT_SCOPE)
endfunction()

function(package_version_need_compilation a_IPM_package_version_root a_IPM_result)
	set(${a_IPM_result} FALSE PARENT_SCOPE)
endfunction()

function(configure_package_version a_IPM_package_version_root)
	IPM_configure_package_version_parse_arguments(l_IPM_configure_package_version ${ARGN})

  get_filename_component(l_IPM_version ${a_IPM_package_version_root} NAME)
  set(${l_IPM_configure_package_version_FILES_TO_INCLUDE} "${a_IPM_package_version_root}/source/FileInformation-${l_IPM_version}/Module/FileInformation.cmake" PARENT_SCOPE)
endfunction()
