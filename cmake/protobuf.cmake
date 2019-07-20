if (EXISTS "${PROJECT_SOURCE_DIR}/deps_prefix/include/google/protobuf/api.proto")
    set(PROTOBUF_INCLUDE_DIR "${PROJECT_SOURCE_DIR}/deps_prefix/include")
elseif (EXISTS "${PROJECT_SOURCE_DIR}/protobuf/src/google/protobuf/api.proto")
    set(PROTOBUF_INCLUDE_DIR "${PROJECT_SOURCE_DIR}/protobuf/src")
else ()
    find_path(PROTOBUF_INCLUDE_DIR google/protobuf/api.proto
              PATH_SUFFIXES include
              PATHS ~/Library/Frameworks
                    /Library/Frameworks
                    /usr
                    /usr/local
                    /opt/local
                    /opt/csw
                    /opt)
endif ()
set(PROTOBUF_INCLUDE_DIRS ${PROTOBUF_INCLUDE_DIR})
if (NOT PROTOBUF_INCLUDE_DIRS)
    message(FATAL_ERROR "Can't find Protobuf header files")
else ()
    message(STATUS "Protobuf include path: " ${PROTOBUF_INCLUDE_DIRS})
endif ()


if (EXISTS "${PROJECT_SOURCE_DIR}/deps_prefix/lib/libprotobuf.so")
    set(PROTOBUF_LIBRARY "${PROJECT_SOURCE_DIR}/deps_prefix/lib/libprotobuf.so")
elseif (EXISTS "${PROJECT_SOURCE_DIR}/protobuf/src/.libs/libprotobuf.so")
    set(PROTOBUF_LIBRARY "${PROJECT_SOURCE_DIR}/protobuf/src/.libs/libprotobuf.so")
else ()
    find_library(PROTOBUF_LIBRARY
                 NAMES libprotobuf.so
                 PATHS ~/Library/Frameworks
                       /Library/Frameworks
                       /usr/lib
                       /usr/local/lib
                       /opt/local/lib
                       /opt/csw
                       /opt)
endif ()
if (NOT PROTOBUF_LIBRARY) # Maybe on Mac?
    if (EXISTS "${PROJECT_SOURCE_DIR}/deps_prefix/lib/libprotobuf.dylib")
        set(PROTOBUF_LIBRARY "${PROJECT_SOURCE_DIR}/deps_prefix/lib/libprotobuf.dylib")
    elseif (EXISTS "${PROJECT_SOURCE_DIR}/protobuf/src/.libs/libprotobuf.dylib")
        set(PROTOBUF_LIBRARY "${PROJECT_SOURCE_DIR}/protobuf/src/.libs/libprotobuf.dylib")
    else ()
        find_library(PROTOBUF_LIBRARY
                     NAMES libprotobuf.dylib
                     PATHS ~/Library/Frameworks
                           /Library/Frameworks
                           /usr/lib
                           /usr/local/lib
                           /opt/local/lib
                           /opt/csw
                           /opt)
    endif()
endif()
if (NOT PROTOBUF_LIBRARY)
    message(FATAL_ERROR "Can't find Protobuf library file")
else ()
    message(STATUS "Protobuf library path: " ${PROTOBUF_LIBRARY})
endif ()

if (EXISTS "${PROJECT_SOURCE_DIR}/deps_prefix/bin/protoc")
    set(PROTOC_DIR "${PROJECT_SOURCE_DIR}/deps_prefix/bin")
elseif (EXISTS "${PROJECT_SOURCE_DIR}/protobuf/src/.libs/protoc")
    set(PROTOC_DIR "${PROJECT_SOURCE_DIR}/protobuf/src/.libs")
else ()
    find_path(PROTOC_DIR protoc
              PATH_SUFFIXES bin
              PATHS ~/Library/Frameworks
                    /Library/Frameworks
                    /usr
                    /usr/local
                    /opt/local
                    /opt/csw
                    /opt)
endif ()
if (NOT PROTOC_DIR)
    message(FATAL_ERROR "Can't find protoc executable file")
else ()
    message(STATUS "protoc path: " ${PROTOC_DIR}/protoc)
    set(PROTOBUF_PROTOC_EXECUTABLE ${PROTOC_DIR}/protoc)
endif ()

find_package(Protobuf REQUIRED)


if (EXISTS "${PROJECT_SOURCE_DIR}/deps_prefix/lib/libprotobuf.a")
    set(PROTOBUF_STATIC_LIBRARIES "${PROJECT_SOURCE_DIR}/deps_prefix/lib/libprotobuf.a")
elseif (EXISTS "${PROJECT_SOURCE_DIR}/protobuf/src/.libs/libprotobuf.a")
    set(PROTOBUF_STATIC_LIBRARIES "${PROJECT_SOURCE_DIR}/protobuf/src/.libs/libprotobuf.a")
else ()
    find_library(PROTOBUF_STATIC_LIBRARIES
                 NAMES libprotobuf.a
                 PATHS ~/Library/Frameworks
                       /Library/Frameworks
                       /usr/lib
                       /usr/local/lib
                       /opt/local/lib
                       /opt/csw
                       /opt)
endif ()
if (NOT PROTOBUF_STATIC_LIBRARIES)
    message(FATAL_ERROR "Can't find Protobuf static library file")
else ()
    message(STATUS "Protobuf static library path: " ${PROTOBUF_STATIC_LIBRARIES})
endif ()

