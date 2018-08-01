# ----------------------------------------------------------------------------
#  author: conansherry
# ----------------------------------------------------------------------------

project(png CXX C)

include_directories("./")

if(WIN32)
  include_directories("../zlib")
else()
  find_package(ZLIB REQUIRED)
endif()

file(GLOB_RECURSE THIRD_SOURCES "*.c")
add_library(png STATIC ${THIRD_SOURCES})

list(APPEND THIRD_PARTY_DEBUG_DEPENDENCIES "png")
list(APPEND THIRD_PARTY_RELEASE_DEPENDENCIES "png")

install(TARGETS png 
        CONFIGURATIONS
        Debug
        RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin/Debug
        LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/Debug
        ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/Debug)
install(TARGETS png 
        CONFIGURATIONS
        Release
        RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin/Release
        LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/Release
        ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/Release)