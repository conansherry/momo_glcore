# ----------------------------------------------------------------------------
#  author: conansherry
# ----------------------------------------------------------------------------

project(zlib CXX C)

include_directories("./")
file(GLOB_RECURSE THIRD_SOURCES "*.c")
add_library(zlib STATIC ${THIRD_SOURCES})
list(APPEND THIRD_PARTY_DEBUG_DEPENDENCIES "zlib")
list(APPEND THIRD_PARTY_RELEASE_DEPENDENCIES "zlib")