cmake_minimum_required(VERSION 3.8)
project ("os16" NONE)


set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_BINARY_DIR "${CMAKE_SOURCE_DIR}/build")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin")

set(IMAGE_DIRECTORY ${CMAKE_SOURCE_DIR}/images)


add_subdirectory(${CMAKE_SOURCE_DIR}/src/c99)
add_subdirectory(${CMAKE_SOURCE_DIR}/src/cpp)
add_subdirectory(${CMAKE_SOURCE_DIR}/src/nasm)
add_subdirectory(${CMAKE_SOURCE_DIR}/src/asm)
add_subdirectory(${CMAKE_SOURCE_DIR}/src/c)

add_custom_command(
    OUTPUT ${IMAGE_DIRECTORY}/floppy.img
    COMMAND dd if=/dev/zero of=floppy.img bs=512 count=2880 status=none >/dev/null
    WORKING_DIRECTORY ${IMAGE_DIRECTORY})


macro(append-floppy-tgt target seek obj)
    if("${ARGV2}" STREQUAL "1")
        add_custom_target(floppy-${ARGV0}
            COMMAND dd if=$<TARGET_OBJECTS:${ARGV0}> of=${IMAGE_DIRECTORY}/floppy.img status=none bs=512 conv=notrunc seek=${ARGV1} 1> /dev/null
            COMMENT "Appending ${ARGV0} to disk at sector ${ARGV1}"
            DEPENDS ${IMAGE_DIRECTORY}/floppy.img
            )
    else()
        add_custom_target(floppy-${ARGV0}
            COMMAND dd if=$<TARGET_FILE:${ARGV0}> of=${IMAGE_DIRECTORY}/floppy.img status=none bs=512 conv=notrunc seek=${ARGV1} 1> /dev/null
            COMMENT "Appending ${ARGV0} to disk at sector ${ARGV1}"
            DEPENDS ${IMAGE_DIRECTORY}/floppy.img
            )
    endif()
    add_dependencies(floppy-${ARGV0} ${ARGV0})
    add_dependencies(floppy floppy-${ARGV0} ${ARGV0})
endmacro()

macro(append-floppy name file seek count)
    add_custom_target(floppy-${ARGV0}
        COMMAND dd if=${ARGV1} of=${IMAGE_DIRECTORY}/floppy.img bs=512 status=none count=${ARGV3} conv=notrunc seek=${ARGV2} 1> /dev/null
        DEPENDS ${IMAGE_DIRECTORY}/floppy.img
        COMMENT "Appending ${ARGV1} to disk at sector ${ARGV2}"
        )
    add_dependencies(floppy floppy-${ARGV0})
endmacro()

add_custom_target(floppy ALL)
cmake_language(CALL append-floppy-tgt bootload 0 1)
cmake_language(CALL append-floppy-tgt kernel   1 0)
cmake_language(CALL append-floppy map "${IMAGE_DIRECTORY}/map.img" 1 1)
cmake_language(CALL append-floppy dir "${IMAGE_DIRECTORY}/dir.img" 2 1)

macro(load-file file name)
    add_custom_target(loadFile-${ARGV1}
        COMMAND loadFile ${ARGV0} ${IMAGE_DIRECTORY}/floppy.img
        COMMENT "Writing ${ARGV1} to disk"
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
        )
    add_dependencies(loadFiles loadFile-${ARGV1})
endmacro()

add_custom_target(loadFiles ALL)
cmake_language(CALL load-file $<TARGET_FILE:uprog1> uprog1)
cmake_language(CALL load-file $<TARGET_FILE:uprog2> uprog2)
cmake_language(CALL load-file $<TARGET_FILE:shell>  shell)
cmake_language(CALL load-file ${CMAKE_SOURCE_DIR}/message.txt msg)
add_dependencies(loadFiles floppy loadFile uprog1 uprog2 shell)
