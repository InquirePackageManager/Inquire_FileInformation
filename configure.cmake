get_filename_component(l_IPM_version ${FileInformation_PACKAGE_VERSION_ROOT} NAME)
set(FileInformation_FILES_TO_INCLUDE "${FileInformation_PACKAGE_VERSION_ROOT}/source/FileInformation-${FileInformation_VERSION}/Module/FileInformation.cmake")
inquire_message(DEBUG "FileInformation_FILES_TO_INCLUDE = ${FileInformation_FILES_TO_INCLUDE}")
