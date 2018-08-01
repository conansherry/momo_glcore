# ----------------------------------------------------------------------------
#  author: conansherry
# ----------------------------------------------------------------------------

project(jpeg CXX C)

include_directories("./")
file(GLOB_RECURSE THIRD_SOURCES "*.c")
add_library(jpeg STATIC ${THIRD_SOURCES})
list(APPEND THIRD_PARTY_DEBUG_DEPENDENCIES "jpeg")
list(APPEND THIRD_PARTY_RELEASE_DEPENDENCIES "jpeg")