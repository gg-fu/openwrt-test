cmake_minimum_required(VERSION 2.8)


aux_source_directory(./src/ DIRSRCS)

ADD_EXECUTABLE(TEST ${DIRSRCS})
target_include_directories(TEST PUBLIC
    "include")
TARGET_LINK_LIBRARIES(TEST ubus ubox pthread)

install(TARGETS TEST RUNTIME DESTINATION bin)
