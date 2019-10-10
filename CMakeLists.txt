cmake_minimum_required(VERSION 3.5)
project(phxpaxos CXX)

# include(CMakeScripts/flatbuffers.cmake)

# https://blog.csdn.net/wzzfeitian/article/details/40963457

SET(CMAKE_VERBOSE_MAKEFILE on)

message(STATUS "CMAKE_SOURCE_DIR : " ${CMAKE_SOURCE_DIR})
message(STATUS "PROJECT_SOURCE_DIR : " ${PROJECT_SOURCE_DIR})
message(STATUS "PROJECT_BINARY_DIR : " ${PROJECT_BINARY_DIR})

set(ROOT_SRC ${PROJECT_SOURCE_DIR}/src)
set(DEPS_PREFIX_PATH ${PROJECT_SOURCE_DIR}/deps_prefix)
set(ROOT_PLUGIN ${PROJECT_SOURCE_DIR}/plugin)
set(ROOT_SAMPLE ${PROJECT_SOURCE_DIR}/sample)

set(CMAKE_DIR ${PROJECT_SOURCE_DIR}/cmake)
set(CMAKE_MODULE_PATH ${CMAKE_DIR})
set(protobuf_MODULE_COMPATIBLE TRUE)

# Protobuf
include(${CMAKE_DIR}/protobuf.cmake)
# Grpc
include(${CMAKE_DIR}/grpc.cmake)
include_directories(${PROTOBUF_INCLUDE_DIR})
include_directories(${GRPC_INCLUDE_DIRS})
include_directories(${GRPC_INCLUDE_DIR_ROOT})
include_directories(${CMAKE_CURRENT_BINARY_DIR})
message(STATUS "CMAKE_CURRENT_BINARY_DIR : " ${CMAKE_CURRENT_BINARY_DIR})

option(COVERAGE "Enable Coverage" OFF)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Debug" CACHE STRING
      "Choose the type of build, options are: Debug Release."
      FORCE)
endif()

message(STATUS "CMAKE_BUILD_TYPE : " ${CMAKE_BUILD_TYPE})
if (CMAKE_BUILD_TYPE STREQUAL Debug)
    set(CMAKE_C_OPTIMIZATION_FLAGS "-O0")
else()
    set(CMAKE_C_OPTIMIZATION_FLAGS "-O2")
endif()

include_directories(${ROOT_SRC})
include_directories(${ROOT_SRC}/algorithm)
include_directories(${ROOT_SRC}/benchmark)
include_directories(${ROOT_SRC}/checkpoint)
include_directories(${ROOT_SRC}/comm)
include_directories(${ROOT_SRC}/common)
include_directories(${ROOT_SRC}/communicate)
include_directories(${ROOT_SRC}/communicate/tcp)
include_directories(${ROOT_SRC}/config)
include_directories(${ROOT_SRC}/logstorage)
include_directories(${ROOT_SRC}/master)
include_directories(${ROOT_SRC}/node)
include_directories(${ROOT_SRC}/sm-base)
include_directories(${ROOT_SRC}/test)
include_directories(${ROOT_SRC}/tools)
include_directories(${ROOT_SRC}/ut)
include_directories(${ROOT_SRC}/utils)
include_directories(${ROOT_PLUGIN})
include_directories(${ROOT_PLUGIN}/include)
include_directories(${ROOT_PLUGIN}/logger_google)
include_directories(${ROOT_PLUGIN}/monitor)
include_directories(${PROJECT_SOURCE_DIR}/include)

set(LIBPTHREAD pthread)
set(LIBRT rt)

set(FULL_BUILD_DEPS
    ${PROTOBUF_STATIC_LIBRARIES}
    ${GRPC_LIBRARIES}
    ${LIBPTHREAD}
   	${LIBRT}
    ${DEPS_PREFIX_PATH}/lib/libglog.a
    ${DEPS_PREFIX_PATH}/lib/libgflags.a
    ${DEPS_PREFIX_PATH}/lib/libleveldb.a
)

set(SAMPLE_BUILD_DEPS
    ${CMAKE_CURRENT_BINARY_DIR}/src/libphxpaxos.a
    ${CMAKE_CURRENT_BINARY_DIR}/plugin/libphxpaxos_plugin.a)

EXECUTE_PROCESS(COMMAND git describe --abbrev=0 --always OUTPUT_STRIP_TRAILING_WHITESPACE OUTPUT_VARIABLE GIT_VERSION)
message(STATUS "GIT_VERSION: " ${GIT_VERSION})

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D__GIT_VERSION=\"${GIT_VERSION}\"")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D__GIT_VERSION=\"${GIT_VERSION}\"")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-pessimizing-move")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_GLIBCXX_USE_NANOSLEEP")

add_definitions(-D__STDC_FORMAT_MACROS)
set(LD_FLAGS "${LD_FLAGS} -static-libgcc -static-libstdc++")

set(PROTO_FILES ${ROOT_SRC}/comm/paxos_msg.proto
                ${ROOT_SRC}/master/master_sm.proto)
protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS ${PROTO_FILES})
# protobuf_generate_grpc_cpp(GRPC_PROTO_GRPC_SRCS GRPC_PROTO_GRPC_HDRS ${GRPC_PROTO_FILES})

message(STATUS "${PROTO_SRCS} ${PROTO_HDRS} ${PROTO_FILES}")
# message(STATUS "${GRPC_PROTO_GRPC_SRCS} ${GRPC_PROTO_GRPC_HDRS} ${GRPC_PROTO_FILES}")

set(PROTOS_SRC ${PROTO_SRCS} ${PROTO_HDRS})
add_library(PROTOS_OBJ OBJECT ${PROTOS_SRC})

add_subdirectory(${PROJECT_SOURCE_DIR}/src src)
add_subdirectory(${PROJECT_SOURCE_DIR}/plugin plugin)
add_subdirectory(${PROJECT_SOURCE_DIR}/sample sample)
