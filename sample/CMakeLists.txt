include_directories(BEFORE ${PROJECT_SOURCE_DIR})

SET(CMAKE_VERBOSE_MAKEFILE on)

include_directories(${ROOT_SAMPLE})
include_directories(${ROOT_SAMPLE}/phxecho)
include_directories(${ROOT_PLUGIN}/phxelection)
include_directories(${ROOT_PLUGIN}/phxkv)

AUX_SOURCE_DIRECTORY(${ROOT_SAMPLE}/phxecho PHXECHO_SRC)
message(STATUS "PHXECHO_SRC: ${PHXECHO_SRC}")
message(STATUS "CMAKE_CURRENT_BINARY_DIR: ${CMAKE_CURRENT_BINARY_DIR}")

add_executable(phxecho ${PHXECHO_SRC})
target_link_libraries(phxecho ${SAMPLE_BUILD_DEPS} ${FULL_BUILD_DEPS})
set_target_properties(phxecho PROPERTIES LINK_FLAGS "${LD_FLAGS}")
