function(check_package_compatibility a_APM_result)
  APM_check_package_compatibility_parse_arguments(l_APM_check_package_compatibility ${ARGN})

  if(${CMAKE_VERSION} VERSION_LESS 2.8)
    set(${a_APM_result} FALSE PARENT_SCOPE)
    set(${l_APM_check_package_compatibility_DETAILS} "The FileInformation CMake module requires CMake 2.8 or greater.")
    return()
  endif()

  set(${a_APM_result} TRUE PARENT_SCOPE)
endfunction()


function(get_compatible_package_version_root a_APM_package_root a_APM_version a_APM_result)
	APM_get_compatible_package_version_root_parse_arguments(l_APM_get_compatible_package_version_root ${ARGN})
	APM_get_subdirectories(${a_APM_package_root} l_APM_version_dirs)

	#try to find a matching version
	foreach(l_APM_version_dir ${l_APM_version_dirs})
		set(l_APM_version_compatible FALSE)
		# first check that the project has been installed. If so, check version compatibility.
		#TODO add path to test file
		if(EXISTS ${a_APM_package_root}/${l_APM_version_dir}/install/)
			if(${l_APM_version_dir} VERSION_EQUAL ${a_APM_version})
				set(l_APM_version_compatible TRUE)
				set(${a_APM_result} ${a_APM_package_root}/${l_APM_version_dir} PARENT_SCOPE)
				break()
			else()
				#we assume that greater versions are backward compatible
				if(${l_APM_version_dir} VERSION_GREATER ${a_APM_version} AND NOT ${l_APM_get_compatible_package_version_root_EXACT})
					set(l_APM_version_compatible TRUE)
					set(${a_APM_result} ${a_APM_package_root}/${l_APM_version_dir} PARENT_SCOPE)
					break()
				endif()
			endif()
		endif()
	endforeach()
endfunction()

function(download_package_version a_APM_package_root a_APM_result a_APM_version)
	APM_message(INFO "Triggering installation of FileInformation in version ${a_APM_version}... ")

	#---------------------------------------------------------------------------------------#
	#-										DOWNLOAD									   -#
	#---------------------------------------------------------------------------------------#
  set(l_APM_archive_name "${a_APM_version}.tar.gz")
	set(l_APM_FI_location "https://github.com/sakra/FileInformation/archive/${l_APM_archive_name}")
	set(l_APM_FI_local_dir ${a_APM_package_root}/${a_APM_version})
	set(l_APM_FI_local_archive "${l_APM_FI_local_dir}/download/${l_APM_archive_name}")

	if(NOT EXISTS "${l_APM_FI_local_archive}")
		APM_message(INFO "Downloading FileInformation ${a_APM_version} from ${l_APM_FI_location}.")
		file(DOWNLOAD "${l_APM_FI_location}" "${l_APM_FI_local_archive}" SHOW_PROGRESS STATUS l_APM_download_status)
		list(GET l_APM_download_status 0 l_APM_download_status_code)
		list(GET l_APM_download_status 1 l_APM_download_status_string)
		if(NOT l_APM_download_status_code EQUAL 0)
			APM_message(FATAL_ERROR "Error: downloading ${l_APM_FI_location} failed with error : ${l_APM_download_status_string}")
		endif()
	else()
			APM_message(INFO "Using already downloaded Boost version from ${l_APM_FI_local_archive}")
	endif()

	#---------------------------------------------------------------------------------------#
	#-										EXTRACT 									   -#
	#---------------------------------------------------------------------------------------#
	if(EXISTS ${l_APM_FI_local_dir}/source/FileInformation-${a_APM_version}/)
		APM_message(INFO "Folder ${l_APM_FI_local_dir}/source/FileInformation-${a_APM_version}/ already exists. ")
	else()
		APM_message(INFO "Extracting FileInformation ${a_APM_version}...")
		file(MAKE_DIRECTORY ${l_APM_FI_local_dir}/source/)
		execute_process(COMMAND ${CMAKE_COMMAND} -E tar xzf ${l_APM_FI_local_archive} WORKING_DIRECTORY ${l_APM_FI_local_dir}/source/)
		APM_message(INFO "Extracting FileInformation ${a_APM_version}... DONE.")
	endif()

	set(${a_APM_result} ${l_APM_FI_local_dir} PARENT_SCOPE)
endfunction()

function(package_version_need_compilation a_APM_package_version_root a_APM_result)
	set(${a_APM_result} FALSE PARENT_SCOPE)
endfunction()

function(configure_package_version a_APM_package_version_root)
	APM_configure_package_version_parse_arguments(l_APM_configure_package_version ${ARGN})

  get_filename_component(l_APM_version ${a_APM_package_version_root} NAME)
  set(${l_APM_configure_package_version_FILES_TO_INCLUDE} "${a_APM_package_version_root}/source/FileInformation-${l_APM_version}/Module/FileInformation.cmake" PARENT_SCOPE)
endfunction()
