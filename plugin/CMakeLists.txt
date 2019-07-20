include_directories(BEFORE ${PROJECT_SOURCE_DIR})

# link_directories(${DEPS_PREFIX_PATH}/lib)
# link_directories(${DEPS_PREFIX_PATH}/lib64)

AUX_SOURCE_DIRECTORY(${ROOT_PLUGIN}/logger_google LOGGER_GOOGLE_SRC)
message(STATUS "LOGGER_GOOGLE_SRC: ${LOGGER_GOOGLE_SRC}")
add_library(LOGGER_GOOGLE_OBJ OBJECT ${LOGGER_GOOGLE_SRC})

AUX_SOURCE_DIRECTORY(${ROOT_PLUGIN}/monitor MONITOR_SRC)
message(STATUS "MONITOR_SRC: ${MONITOR_SRC}")

set(PHXPAXOS_PLUGIN_SRC ${MONITOR_SRC}
                        $<TARGET_OBJECTS:LOGGER_GOOGLE_OBJ>)
add_library(PHXPAXOS_PLUGIN_OBJ OBJECT ${PHXPAXOS_PLUGIN_SRC})

add_library(phxpaxos_plugin STATIC ${PHXPAXOS_PLUGIN_SRC})
target_link_libraries(phxpaxos_plugin ${FULL_BUILD_DEPS})
set_target_properties(phxpaxos_plugin PROPERTIES COMPILE_FLAGS "-fPIC")
