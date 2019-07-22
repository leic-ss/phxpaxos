include_directories(BEFORE ${PROJECT_SOURCE_DIR})

SET(CMAKE_VERBOSE_MAKEFILE on)

include_directories(${ROOT_SAMPLE})
include_directories(${ROOT_SAMPLE}/phxecho)
include_directories(${ROOT_PLUGIN}/phxelection)
include_directories(${ROOT_PLUGIN}/phxkv)
include_directories(${CMAKE_CURRENT_BINARY_DIR})

AUX_SOURCE_DIRECTORY(${ROOT_SAMPLE}/phxecho PHXECHO_SRC)
message(STATUS "PHXECHO_SRC: ${PHXECHO_SRC}")
message(STATUS "CMAKE_CURRENT_BINARY_DIR: ${CMAKE_CURRENT_BINARY_DIR}")

add_executable(phxecho ${PHXECHO_SRC})
target_link_libraries(phxecho ${SAMPLE_BUILD_DEPS} ${FULL_BUILD_DEPS})
set_target_properties(phxecho PROPERTIES LINK_FLAGS "${LD_FLAGS}")

AUX_SOURCE_DIRECTORY(${ROOT_SAMPLE}/phxelection PHXELECTION_SRC)
message(STATUS "PHXELECTION_SRC: ${PHXELECTION_SRC}")

add_executable(phxelection ${PHXELECTION_SRC})
target_link_libraries(phxelection ${SAMPLE_BUILD_DEPS} ${FULL_BUILD_DEPS})
set_target_properties(phxelection PROPERTIES LINK_FLAGS "${LD_FLAGS}")

set(PROTO_PHXKV_FILES ${ROOT_SAMPLE}/phxkv/phxkv.proto)
set(GRPC_PROTO_PHXKV_FILES ${PROTO_PHXKV_FILES})
protobuf_generate_cpp(PROTO_PHXKV_SRCS PROTO_PHXKV_HDRS ${PROTO_PHXKV_FILES})
protobuf_generate_grpc_cpp(GRPC_PROTO_PHXKV_GRPC_SRCS GRPC_PROTO_PHXKV_GRPC_HDRS ${GRPC_PROTO_PHXKV_FILES})

message(STATUS "${PROTO_PHXKV_SRCS} ${PROTO_PHXKV_HDRS} ${PROTO_PHXKV_FILES}")
message(STATUS "${GRPC_PROTO_PHXKV_GRPC_SRCS} ${GRPC_PROTO_PHXKV_GRPC_HDRS} ${GRPC_PROTO_PHXKV_FILES}")

set(PROTOS_PHXKV_SRC ${PROTO_PHXKV_SRCS}
                     ${PROTO_PHXKV_HDRS}
                     ${GRPC_PROTO_PHXKV_GRPC_SRCS}
                     ${GRPC_PROTO_PHXKV_GRPC_HDRS})
add_library(PROTOS_PHXKV_OBJ OBJECT ${PROTOS_PHXKV_SRC})

set(PHXKV_SERVER_SRC ${ROOT_SAMPLE}/phxkv/kv.cpp
                     ${ROOT_SAMPLE}/phxkv/kv_grpc_server.cpp
                     ${ROOT_SAMPLE}/phxkv/kv_grpc_server_main.cpp
                     ${ROOT_SAMPLE}/phxkv/kv_paxos.cpp
                     ${ROOT_SAMPLE}/phxkv/kvsm.cpp
                     ${ROOT_SAMPLE}/phxkv/log.cpp
                     $<TARGET_OBJECTS:PROTOS_PHXKV_OBJ>)

add_executable(phxkv_server ${PHXKV_SERVER_SRC})
target_link_libraries(phxkv_server ${SAMPLE_BUILD_DEPS} ${FULL_BUILD_DEPS})
set_target_properties(phxkv_server PROPERTIES LINK_FLAGS "${LD_FLAGS}")

set(PHXKV_CLIENT_SRC ${ROOT_SAMPLE}/phxkv/kv_grpc_client.cpp
                     ${ROOT_SAMPLE}/phxkv/kv_grpc_client_main.cpp
                     $<TARGET_OBJECTS:PROTOS_PHXKV_OBJ>)

add_executable(phxkv_client ${PHXKV_CLIENT_SRC})
target_link_libraries(phxkv_client ${SAMPLE_BUILD_DEPS} ${FULL_BUILD_DEPS})
set_target_properties(phxkv_client PROPERTIES LINK_FLAGS "${LD_FLAGS}")
