cmake_minimum_required(VERSION 2.8)


aux_source_directory(./src/ DIRSRCS)

ADD_EXECUTABLE(TCP ${DIRSRCS})
target_include_directories(TCP PUBLIC
    "include")
TARGET_LINK_LIBRARIES(TCP pthread)

install(TARGETS TCP RUNTIME DESTINATION bin)
