# ----------------------------------------------------------------------------
#  author: conansherry
# ----------------------------------------------------------------------------

project(jpeg CXX C)

include_directories("./")

if(WIN32)
elseif(APPLE)
  set(CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS}")
else()
  set(CMAKE_CXX_FLAGS "-std=c++11 -fPIC ${CMAKE_CXX_FLAGS}")
  set(CMAKE_C_FLAGS "-fPIC ${CMAKE_C_FLAGS}")
endif()

file(GLOB_RECURSE THIRD_SOURCES "*.c")
add_library(jpeg STATIC ${THIRD_SOURCES})
list(APPEND THIRD_PARTY_DEBUG_DEPENDENCIES "jpeg")
list(APPEND THIRD_PARTY_RELEASE_DEPENDENCIES "jpeg")

install(TARGETS jpeg 
        CONFIGURATIONS
        Debug
        RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin/Debug
        LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/Debug
        ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/Debug)
install(TARGETS jpeg 
        CONFIGURATIONS
        Release
        RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin/Release
        LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/Release
        ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/Release)