cmake_minimum_required(VERSION 2.8)


aux_source_directory(./src/ DIRSRCS)

ADD_EXECUTABLE(Server ${DIRSRCS})
target_include_directories(Server PUBLIC
    "include")
TARGET_LINK_LIBRARIES(Server dl ubus ubox blobmsg_json daemon sqlite3 json-c pthread -L"./lib" event)
install(TARGETS Server RUNTIME DESTINATION bin)
