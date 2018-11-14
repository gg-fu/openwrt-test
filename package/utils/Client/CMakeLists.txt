cmake_minimum_required(VERSION 2.8)


aux_source_directory(./src/ DIRSRCS)

ADD_EXECUTABLE(Client ${DIRSRCS})
target_include_directories(Client PUBLIC
    "include")
TARGET_LINK_LIBRARIES(Client  dl ubus ubox blobmsg_json daemon sqlite3 json-c pthread)

install(TARGETS Client RUNTIME DESTINATION bin)
