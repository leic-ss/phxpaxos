include_directories(BEFORE ${PROJECT_SOURCE_DIR})

# link_directories(${DEPS_PREFIX_PATH}/lib)
# link_directories(${DEPS_PREFIX_PATH}/lib64)

AUX_SOURCE_DIRECTORY(${ROOT_SRC}/algorithm ALGORITHM_SRC)
message(STATUS "ALGORITHM_SRC: ${ALGORITHM_SRC}")
add_library(ALGORITHM_OBJ OBJECT ${ALGORITHM_SRC})

AUX_SOURCE_DIRECTORY(${ROOT_SRC}/checkpoint CHECKPOINT_SRC)
message(STATUS "CHECKPOINT_SRC: ${CHECKPOINT_SRC}")

AUX_SOURCE_DIRECTORY(${ROOT_SRC}/comm COMM_SRC)
message(STATUS "COMM_SRC: ${COMM_SRC}")

AUX_SOURCE_DIRECTORY(${ROOT_SRC}/common COMMON_SRC)
message(STATUS "COMMON_SRC: ${COMMON_SRC}")

AUX_SOURCE_DIRECTORY(${ROOT_SRC}/communicate COMMUNICATE_SRC)
message(STATUS "COMMUNICATE_SRC: ${COMMUNICATE_SRC}")

AUX_SOURCE_DIRECTORY(${ROOT_SRC}/communicate/tcp COMMUNICATE_TCP_SRC)
message(STATUS "COMMUNICATE_TCP_SRC: ${COMMUNICATE_TCP_SRC}")

AUX_SOURCE_DIRECTORY(${ROOT_SRC}/config CONFIG_SRC)
message(STATUS "CONFIG_SRC: ${CONFIG_SRC}")

AUX_SOURCE_DIRECTORY(${ROOT_SRC}/logstorage LOGSTORAGE_SRC)
message(STATUS "LOGSTORAGE_SRC: ${LOGSTORAGE_SRC}")

AUX_SOURCE_DIRECTORY(${ROOT_SRC}/master MASTER_SRC)
message(STATUS "MASTER_SRC: ${MASTER_SRC}")

set(NODE_SRC ${ROOT_SRC}/node/group.cpp
             ${ROOT_SRC}/node/node.cpp
             ${ROOT_SRC}/node/pnode.cpp
             ${ROOT_SRC}/node/propose_batch.cpp)
message(STATUS "NODE_SRC: ${NODE_SRC}")

AUX_SOURCE_DIRECTORY(${ROOT_SRC}/sm-base SM_BASE_SRC)
message(STATUS "SM_BASE_SRC: ${SM_BASE_SRC}")

AUX_SOURCE_DIRECTORY(${ROOT_SRC}/utils UTILS_SRC)
message(STATUS "UTILS_SRC: ${UTILS_SRC}")

set(PHXPAXOS_SRC ${CHECKPOINT_SRC}
                 ${COMM_SRC}
                 ${COMMON_SRC}
                 ${COMMUNICATE_SRC}
                 ${COMMUNICATE_TCP_SRC}
                 ${CONFIG_SRC}
                 ${LOGSTORAGE_SRC}
                 ${MASTER_SRC}
                 ${NODE_SRC}
                 ${SM_BASE_SRC}
                 ${UTILS_SRC}
                 $<TARGET_OBJECTS:ALGORITHM_OBJ>
                 $<TARGET_OBJECTS:PROTOS_OBJ>)
add_library(PHXPAXOS_OBJ OBJECT ${PHXPAXOS_SRC})

add_library(phxpaxos STATIC ${PHXPAXOS_SRC})
target_link_libraries(phxpaxos ${FULL_BUILD_DEPS})
set_target_properties(phxpaxos PROPERTIES COMPILE_FLAGS "-fPIC")
