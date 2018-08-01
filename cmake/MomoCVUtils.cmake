include(CMakeParseArguments)

macro(mmcv_update VAR)
  if(NOT DEFINED ${VAR})
    set(${VAR} ${ARGN})
  else()
    #ocv_debug_message("Preserve old value for ${VAR}: ${${VAR}}")
  endif()
endmacro()

function(mmcv_cmake_eval var_name)
  if(DEFINED ${var_name})
    file(WRITE "${CMAKE_BINARY_DIR}/CMakeCommand-${var_name}.cmake" ${${var_name}})
    include("${CMAKE_BINARY_DIR}/CMakeCommand-${var_name}.cmake")
  endif()
  if(";${ARGN};" MATCHES ";ONCE;")
    unset(${var_name} CACHE)
  endif()
endfunction()

macro(mmcv_clear_vars)
  foreach(_var ${ARGN})
    unset(${_var})
    unset(${_var} CACHE)
  endforeach()
endmacro()

macro(mmcv_libname name_ result_)
  if(WIN32)
    set(${result_} "libmmcv_${name_}")
  else()
    set(${result_} "mmcv_${name_}")
  endif()
endmacro()

macro(mmcv_api_libname name_ result_)
  if(WIN32)
    set(${result_} "libmmcv_api_${name_}")
  else()
    set(${result_} "mmcv_api_${name_}")
  endif()
endmacro()

# Provides an option that the user can optionally select.
# Can accept condition to control when option is available for user.
# Usage:
#   option(<option_variable> "help string describing the option" <initial value or boolean expression> [IF <condition>])
macro(MMCV_OPTION variable description value)
  set(__value ${value})
  set(__condition "")
  set(__varname "__value")
  foreach(arg ${ARGN})
    if(arg STREQUAL "IF" OR arg STREQUAL "if")
      set(__varname "__condition")
    else()
      list(APPEND ${__varname} ${arg})
    endif()
  endforeach()
  unset(__varname)
  if(__condition STREQUAL "")
    set(__condition 2 GREATER 1)
  endif()

  if(${__condition})
    if(__value MATCHES ";")
      if(${__value})
        option(${variable} "${description}" ON)
      else()
        option(${variable} "${description}" OFF)
      endif()
    elseif(DEFINED ${__value})
      if(${__value})
        option(${variable} "${description}" ON)
      else()
        option(${variable} "${description}" OFF)
      endif()
    else()
      option(${variable} "${description}" ${__value})
    endif()
  else()
    unset(${variable} CACHE)
  endif()
  unset(__condition)
  unset(__value)
endmacro()

macro(mmcv_subdirlist result curdir)
  file(GLOB children ${curdir}/*)
  set(dirlist "")
  foreach(child ${children})
    if(IS_DIRECTORY ${child})
      list(APPEND dirlist ${child})
    endif()
  endforeach()
  set(${result} ${dirlist})
endmacro()

macro(mmcv_buildlibrary name type)
  set(sources "")
  set(dependencies "")
  set(mode "unknown")
  foreach(var ${ARGN})
    if(var STREQUAL "SOURCES")
      set(mode "SOURCES")
    elseif(var STREQUAL "DEPENDENCIES")
      set(mode "DEPENDENCIES")
    else()
      if(mode STREQUAL "SOURCES")
        list(APPEND sources ${var})
      elseif(mode STREQUAL "DEPENDENCIES")
        list(APPEND dependencies ${var})
      endif()
    endif()
  endforeach()
  add_library(${name} ${type} ${sources})
  if(APPLE)
    target_compile_options(${name} PUBLIC "-fobjc-arc")
  endif()
  target_link_libraries(${name} ${dependencies})
  
  install(TARGETS ${name} 
          CONFIGURATIONS
          Debug
          RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin/Debug
          LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/Debug
          ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/Debug)
  install(TARGETS ${name} 
          CONFIGURATIONS
          Release
          RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin/Release
          LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/Release
          ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/Release)
endmacro()

macro(mmcv_buildapp name)
  set(sources "")
  set(dependencies "")
  set(mode "unknown")
  foreach(var ${ARGN})
    if(var STREQUAL "SOURCES")
      set(mode "SOURCES")
    elseif(var STREQUAL "DEPENDENCIES")
      set(mode "DEPENDENCIES")
    else()
      if(mode STREQUAL "SOURCES")
        list(APPEND sources ${var})
      elseif(mode STREQUAL "DEPENDENCIES")
        list(APPEND dependencies ${var})
      endif()
    endif()
  endforeach()
  add_executable(${name} ${sources})
  if(APPLE)
    target_compile_options(${name} PUBLIC "-fobjc-arc")
  endif()
  target_link_libraries(${name} ${dependencies})
endmacro()

macro(mmcv_add_framework fwname appname)
  if(NOT (${fwname} STREQUAL "opencv2"))
    set(FRAMEWORK_${fwname} "FRAMEWORK_${fwname}-NOTFOUND")
  endif()
  if(BUILD_IOS_FRAMEWORK)
    set(FRAMEWORK_PATHS "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library")
  else()
    set(FRAMEWORK_PATHS "${CMAKE_OSX_SYSROOT}/System/Library")
  endif()
  find_library(FRAMEWORK_${fwname}
               NAMES ${fwname}
               PATHS ${FRAMEWORK_PATHS}
               PATH_SUFFIXES Frameworks
               NO_DEFAULT_PATH)
  if(${FRAMEWORK_${fwname}} STREQUAL FRAMEWORK_${fwname}-NOTFOUND)
    message(FATAL_ERROR "Framework ${fwname} not found")
  else()
    target_link_libraries(${appname} "${FRAMEWORK_${fwname}}")
    message("Framework ${fwname} found at ${FRAMEWORK_${fwname}}")
  endif()
endmacro()

macro(mmcv_set_framework libname_)
set_target_properties(${libname_} PROPERTIES
                      FRAMEWORK TRUE
                      SOVERSION "1"
                      VERSION "1"
                      XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer"
                      XCODE_ATTRIBUTE_DYLIB_INSTALL_NAME_BASE "@rpath"
                      XCODE_ATTRIBUTE_INSTALL_PATH "/Framework"
                      XCODE_ATTRIBUTE_INFOPLIST_FILE "apple_framework/Info.plist"
                      XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "mmcv2.${libname_}"
                      XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "8.0"
                      XCODE_ATTRIBUTE_FRAMEWORK_VERSION "A"
                      XCODE_ATTRIBUTE_CURRENT_PROJECT_VERSION "1"
                      XCODE_ATTRIBUTE_BITCODE_GENERATION_MODE "bitcode")
endmacro()

macro(mmcv_build_module name_ build_world_ libtype_ headers_ sources_ deps_)
  set(MMCV_ALL_HEADERS ${MMCV_ALL_HEADERS} ${headers_})
  set(MMCV_ALL_SRCS ${MMCV_ALL_SRCS} ${sources_})
  if(NOT ${build_world_})
    mmcv_libname(${name_} libname)
    set(MMCV_ALL_LIBS ${MMCV_ALL_LIBS} ${libname})
    mmcv_buildlibrary(${libname} ${libtype_} SOURCES ${headers_} ${sources_} DEPENDENCIES ${deps_})
    if(USE_ACCELERATE)
      mmcv_add_framework(Accelerate ${libname})
    endif()
    if(BUILD_IOS_FRAMEWORK)
      mmcv_add_framework(opencv2 ${libname})
      mmcv_set_framework(${libname})
    endif()
  endif()
endmacro()

macro(mmcv_build_api name_ build_world_ libtype_ headers_ sources_ deps_)
  set(MMCV_API_ALL_HEADERS ${MMCV_API_ALL_HEADERS} ${headers_})
  set(MMCV_API_ALL_SRCS ${MMCV_API_ALL_SRCS} ${sources_})
  if(NOT ${build_world_})
    mmcv_api_libname(${name_} libname)
    set(MMCV_API_ALL_LIBS ${MMCV_API_ALL_LIBS} ${libname})
    mmcv_buildlibrary(${libname} ${libtype_} SOURCES ${headers_} ${sources_} DEPENDENCIES ${deps_})
	if(BUILD_IOS_FRAMEWORK)
      mmcv_set_framework(${libname})
    endif()
  endif()
endmacro()

macro(mmcv_build_test name_ headers_ sources_ deps_)
  mmcv_buildapp(${name_} SOURCES ${headers_} ${sources_} DEPENDENCIES ${deps_})
endmacro()

macro(mmcv_make_group FILES_LIST)
  foreach(FILE ${FILES_LIST})
    #convert source file to absolute
    get_filename_component(ABSOLUTE_PATH "${FILE}" ABSOLUTE)
    # Get the directory of the absolute source file
    get_filename_component(PARENT_DIR "${ABSOLUTE_PATH}" DIRECTORY)
    # Remove common directory prefix to make the group
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}" "" GROUP "${PARENT_DIR}")
    # Make sure we are using windows slashes
    string(REPLACE "/" "\\" GROUP "${GROUP}")
    # Group into "Source Files" and "Header Files"
    if ("${FILE}" MATCHES ".*\\.c")
      set(GROUP "Source Files${GROUP}")
    elseif("${FILE}" MATCHES ".*\\.m")
      set(GROUP "Source Files${GROUP}")
    elseif("${FILE}" MATCHES ".*\\.h")
      set(GROUP "Header Files${GROUP}")
    endif()
    source_group("${GROUP}" FILES "${FILE}")
  endforeach()
endmacro()
