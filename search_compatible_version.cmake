set(FileInformation_COMPATIBLE_VERSION_FOUND FALSE)

IPM_get_subdirectories(${FileInformation_PACKAGE_ROOT} l_IPM_version_dirs)

#try to find a matching version
foreach(l_IPM_version_dir ${l_IPM_version_dirs})
	set(l_IPM_version_compatible FALSE)
	# first check that the project has been installed. If so, check version compatibility.
	#TODO add path to test file
	if(EXISTS ${FileInformation_PACKAGE_ROOT}/${l_IPM_version_dir}/install/)
		if(${l_IPM_version_dir} VERSION_EQUAL ${FileInformation_VERSION})
			set(FileInformation_COMPATIBLE_VERSION_FOUND TRUE)
			set(Eigen3_VERSION_ROOT  ${FileInformation_PACKAGE_ROOT}/${l_IPM_version_dir})
			break()
		else()
			#we assume that greater versions are backward compatible
			if(${l_IPM_version_dir} VERSION_GREATER ${FileInformation_VERSION} AND NOT ${FileInformation_EXACT})
				set(FileInformation_COMPATIBLE_VERSION_FOUND TRUE)
				set(Eigen3_VERSION_ROOT  ${FileInformation_PACKAGE_ROOT}/${l_IPM_version_dir})
				break()
			endif()
		endif()
	endif()
endforeach()

if(NOT ${FileInformation_COMPATIBLE_VERSION_FOUND})
  inquire_message(INFO "No compatible version of FileInformation found.")
endif()
