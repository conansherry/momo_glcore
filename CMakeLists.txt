# ----------------------------------------------------------------------------
#  Root CMake file for momo_glcore
#
#    From the off-tree build directory, invoke:
#      $ cmake <PATH_TO_MOMOCV_ROOT>
#
#  author: conansherry
# ----------------------------------------------------------------------------

include(cmake/MomoCVMinDepVersions.cmake)

if(CMAKE_GENERATOR MATCHES Xcode AND XCODE_VERSION VERSION_GREATER 4.3)
  cmake_minimum_required(VERSION 2.8.8 FATAL_ERROR)
else()
  cmake_minimum_required(VERSION "${MIN_VER_CMAKE}" FATAL_ERROR)
endif()

if(NOT CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE PATH "Installation Directory")
else(NOT CMAKE_TOOLCHAIN_FILE)
  #Android: set output folder to ${CMAKE_BINARY_DIR}
  set(LIBRARY_OUTPUT_PATH_ROOT ${CMAKE_BINARY_DIR} CACHE PATH "root for library output, set this to change where android libs are compiled to")
  # any crosscompiling
  set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE PATH "Installation Directory")
endif(NOT CMAKE_TOOLCHAIN_FILE)

include(cmake/MomoCVUtils.cmake)

set(THIRD_PARTY_DEBUG_DEPENDENCIES "")
set(THIRD_PARTY_RELEASE_DEPENDENCIES "")

add_subdirectory(external/zlib)

add_subdirectory(external/libjpeg)

add_subdirectory(external/libpng)

project(momo_glcore CXX C)

# Using cmake scripts and modules
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/Modules)

mmcv_update(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Configs" FORCE)
if(DEFINED CMAKE_BUILD_TYPE)
  set_property( CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${CMAKE_CONFIGURATION_TYPES} )
endif()

if(NOT CMAKE_DEBUG_POSTFIX)
  set(CMAKE_DEBUG_POSTFIX _d)
endif()

if(MSVC)
  set(CMAKE_USE_RELATIVE_PATHS ON CACHE INTERNAL "" FORCE)
endif()

# ----------------------------------------------------------------------------
# Break in case of popular CMake configuration mistakes
# ----------------------------------------------------------------------------
if(NOT CMAKE_SIZEOF_VOID_P GREATER 0)
  message(FATAL_ERROR "CMake fails to deterimine the bitness of target platform.
  Please check your CMake and compiler installation. If you are crosscompiling then ensure that your CMake toolchain file correctly sets the compiler details.")
endif()

MMCV_OPTION(USE_GLEW                "Use GLEW"                  ON)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  unset(CMAKE_INSTALL_PREFIX CACHE)
endif()
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE PATH "Installation Directory")

if(USE_GLEW)
  find_package(GLEW REQUIRED)
  add_definitions(-DUSE_GLEW)
  add_definitions(-DGLEW_NO_GLU)
  include_directories(${GLEW_INCLUDE_DIR})
  list(APPEND THIRD_PARTY_DEBUG_DEPENDENCIES ${GLEW_LIBRARY_DEBUG})
  list(APPEND THIRD_PARTY_RELEASE_DEPENDENCIES ${GLEW_LIBRARY_RELEASE})
endif()

if(WIN32)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
  add_definitions(-D_CRT_NONSTDC_NO_DEPRECATE)
endif()

if(WIN32)
elseif(APPLE)
  set(CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS}")
else()
  set(CMAKE_CXX_FLAGS "-std=c++11 -fPIC ${CMAKE_CXX_FLAGS}")
endif()

include_directories("external")
include_directories("external/libjpeg")
include_directories("external/libpng")
include_directories("external/zlib")

file(GLOB_RECURSE GLCORE_HEADERS "src/*.h")
file(GLOB_RECURSE GLCORE_SOURCES "src/*.cpp")

# group files
mmcv_make_group("${GLCORE_HEADERS}")
mmcv_make_group("${GLCORE_SOURCES}")

add_library(momo_glcore STATIC ${GLCORE_SOURCES} ${GLCORE_HEADERS})

install(FILES ${GLCORE_HEADERS} DESTINATION ${CMAKE_INSTALL_PREFIX}/include/)
install(DIRECTORY "external/glm" DESTINATION ${CMAKE_INSTALL_PREFIX}/include/)

install(TARGETS momo_glcore 
        CONFIGURATIONS
        Debug
        RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin/Debug
        LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/Debug
        ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/Debug)
install(TARGETS momo_glcore 
        CONFIGURATIONS
        Release
        RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin/Release
        LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/Release
        ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/Release)