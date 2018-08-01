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