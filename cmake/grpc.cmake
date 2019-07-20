if (EXISTS "${PROJECT_SOURCE_DIR}/deps_prefix/bin/grpc_cpp_plugin")
    set(GRPC_CPP_PLUGIN "${PROJECT_SOURCE_DIR}/deps_prefix/bin")
elseif (EXISTS "${PROJECT_SOURCE_DIR}/grpc/bins/opt/grpc_cpp_plugin")
    set(GRPC_CPP_PLUGIN "${PROJECT_SOURCE_DIR}/grpc/bins/opt")
else ()
    find_path(GRPC_CPP_PLUGIN grpc_cpp_plugin
              PATH_SUFFIXES bin
              PATHS ~/Library/Frameworks
                    /Library/Frameworks
                    /usr
                    /usr/local
                    /opt/local
                    /opt/csw
                    /opt)
endif ()
if (NOT GRPC_CPP_PLUGIN)
    message(FATAL_ERROR "Can't find grpc_cpp_plugin file")
else ()
    message(STATUS "grpc_cpp_plugin path: " ${GRPC_CPP_PLUGIN}/grpc_cpp_plugin)
endif ()
#find_program(GRPC_CPP_PLUGIN grpc_cpp_plugin) # Get full path to plugin

if (EXISTS "${PROJECT_SOURCE_DIR}/deps_prefix/include/grpc/grpc.h")
    set(GRPC_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}/deps_prefix/include/grpc")
    set(GRPC_INCLUDE_DIR_ROOT "${PROJECT_SOURCE_DIR}/deps_prefix/include")
elseif (EXISTS "${PROJECT_SOURCE_DIR}/grpc/include/grpc/grpc.h")
    set(GRPC_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}/grpc/include/grpc")
    set(GRPC_INCLUDE_DIR_ROOT "${PROJECT_SOURCE_DIR}/grpc/include")
else ()
    find_path(GRPC_INCLUDE_DIRS grpc.h
              PATH_SUFFIXES include/grpc
              PATHS ~/Library/Frameworks
                    /Library/Frameworks
                    /usr
                    /usr/local
                    /opt/local
                    /opt/csw
                    /opt)
    find_path(GRPC_INCLUDE_DIR_ROOT grpc++/grpc++.h
              PATH_SUFFIXES include
              PATHS ~/Library/Frameworks
                    /Library/Frameworks
                    /usr
                    /usr/local
                    /opt/local
                    /opt/csw
                    /opt)
endif ()
if (NOT GRPC_INCLUDE_DIRS)
    message(FATAL_ERROR "Can't find gRPC header files")
else ()
    message(STATUS "gRPC include path: " ${GRPC_INCLUDE_DIRS})
endif ()
if (NOT GRPC_INCLUDE_DIR_ROOT)
    message(FATAL_ERROR "Can't find gRPC header files")
else ()
    message(STATUS "gRPC include path (parent): " ${GRPC_INCLUDE_DIR_ROOT})
endif ()


if (EXISTS "${PROJECT_SOURCE_DIR}/deps_prefix/lib/libgrpc.a")
    set(GRPC_LIBRARY "${PROJECT_SOURCE_DIR}/deps_prefix/lib/libgrpc.a")
elseif (EXISTS "${PROJECT_SOURCE_DIR}/grpc/libs/opt/libgrpc.a")
    set(GRPC_LIBRARY "${PROJECT_SOURCE_DIR}/grpc/libs/opt/libgrpc.a")
else ()
    find_library(GRPC_LIBRARY
                 NAMES libgrpc.a
                 PATHS ~/Library/Frameworks
                       /Library/Frameworks
                       /usr/lib
                       /usr/local/lib
                       /opt/local/lib
                       /opt/csw
                       /opt)
endif()
if (EXISTS "${PROJECT_SOURCE_DIR}/deps_prefix/lib/libgrpc++.a")
    set(GRPCPP_LIBRARY "${PROJECT_SOURCE_DIR}/deps_prefix/lib/libgrpc++.a")
elseif (EXISTS "${PROJECT_SOURCE_DIR}/grpc/libs/opt/libgrpc++.a")
    set(GRPCPP_LIBRARY "${PROJECT_SOURCE_DIR}/grpc/libs/opt/libgrpc++.a")
else ()
    find_library(GRPCPP_LIBRARY
                 NAMES libgrpc++.a
                 PATHS ~/Library/Frameworks
                       /Library/Frameworks
                       /usr/lib
                       /usr/local/lib
                       /opt/local/lib
                       /opt/csw
                       /opt)
endif ()
if (EXISTS "${PROJECT_SOURCE_DIR}/deps_prefix/lib/libgpr.a")
    set(GPR_LIBRARY "${PROJECT_SOURCE_DIR}/deps_prefix/lib/libgpr.a")
elseif (EXISTS "${PROJECT_SOURCE_DIR}/grpc/libs/opt/libgpr.a")
    set(GPR_LIBRARY "${PROJECT_SOURCE_DIR}/grpc/libs/opt/libgpr.a")
else ()
    find_library(GPR_LIBRARY
                 NAMES libgpr.a
                 PATHS ~/Library/Frameworks
                       /Library/Frameworks
                       /usr/lib
                       /usr/local/lib
                       /opt/local/lib
                       /opt/csw
                       /opt)
endif ()
if (NOT GRPC_LIBRARY)
    message(FATAL_ERROR "Can't find gRPC static library file")
else ()
    message(STATUS "gRPC static library path: " ${GRPC_LIBRARY})
endif ()
if (NOT GRPCPP_LIBRARY)
    message(FATAL_ERROR "Can't find gRPC++ static library file")
else ()
    message(STATUS "gRPC++ static library path: " ${GRPCPP_LIBRARY})
endif ()
if (NOT GPR_LIBRARY)
    message(FATAL_ERROR "Can't find gpr static library file")
else ()
    message(STATUS "gpr static library path: " ${GPR_LIBRARY})
endif ()


set(GRPC_LIBRARIES ${GRPCPP_LIBRARY} ${GRPC_LIBRARY} ${GPR_LIBRARY})

function(protobuf_generate_grpc_cpp SRCS HDRS)
  if(NOT ARGN)
    message(SEND_ERROR "Error: protobuf_generate_grpc_cpp() called without any proto files")
    return()
  endif()

  if(PROTOBUF_GENERATE_CPP_APPEND_PATH) # This variable is common for all types of output.
    # Create an include path for each file specified
    foreach(FIL ${ARGN})
      get_filename_component(ABS_FIL ${FIL} ABSOLUTE)
      get_filename_component(ABS_PATH ${ABS_FIL} PATH)
      list(FIND _protobuf_include_path ${ABS_PATH} _contains_already)
      if(${_contains_already} EQUAL -1)
          list(APPEND _protobuf_include_path -I ${ABS_PATH})
      endif()
    endforeach()
  else()
    set(_protobuf_include_path -I ${CMAKE_CURRENT_SOURCE_DIR})
  endif()

  if(DEFINED PROTOBUF_IMPORT_DIRS)
    foreach(DIR ${Protobuf_IMPORT_DIRS})
      get_filename_component(ABS_PATH ${DIR} ABSOLUTE)
      list(FIND _protobuf_include_path ${ABS_PATH} _contains_already)
      if(${_contains_already} EQUAL -1)
          list(APPEND _protobuf_include_path -I ${ABS_PATH})
      endif()
    endforeach()
  endif()

  set(${SRCS})
  set(${HDRS})
  foreach(FIL ${ARGN})
    get_filename_component(ABS_FIL ${FIL} ABSOLUTE)
    get_filename_component(FIL_WE ${FIL} NAME_WE)

    list(APPEND ${SRCS} "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.grpc.pb.cc")
    list(APPEND ${HDRS} "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.grpc.pb.h")

    add_custom_command(
      OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.grpc.pb.cc"
             "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.grpc.pb.h"
      COMMAND ${PROTOC_DIR}/protoc
      ARGS --grpc_out=${CMAKE_CURRENT_BINARY_DIR}
           --plugin=protoc-gen-grpc=${GRPC_CPP_PLUGIN}/grpc_cpp_plugin
           --proto_path=${PROTOBUF_INCLUDE_DIRS}
           ${_protobuf_include_path} ${ABS_FIL}
      DEPENDS ${ABS_FIL} ${Protobuf_PROTOC_EXECUTABLE}
      COMMENT "Running gRPC C++ protocol buffer compiler on ${FIL}"
      VERBATIM)
  endforeach()

  set_source_files_properties(${${SRCS}} ${${HDRS}} PROPERTIES GENERATED TRUE)
  set(${SRCS} ${${SRCS}} PARENT_SCOPE)
  set(${HDRS} ${${HDRS}} PARENT_SCOPE)
endfunction()
