enable_language(C)
set(CMAKE_C_COMPILER bcc)
set(CMAKE_C_LINKER ld86)

set(CMAKE_C_COMPILE_OBJECT
    "<CMAKE_C_COMPILER> <DEFINES> <INCLUDES> -ansi -o <OBJECT> -c <SOURCE>")
set(CMAKE_C_LINK_EXECUTABLE
    "${CMAKE_C_LINKER} <LINK_FLAGS> -o <TARGET> -d <OBJECTS> <LINK_LIBRARIES>")

#add_compile_options(-ansi -c)

include_directories(BEFORE ${CMAKE_SOURCE_DIR}/include)

add_library(userlib OBJECT userlib.c)
add_library(proc    OBJECT proc.c)

add_executable(uprog1 uprog1.c)
target_link_libraries(uprog1 userlib lib)

add_executable(uprog2 uprog2.c)
target_link_libraries(uprog2 userlib lib)

add_executable(shell shell.c)
target_link_libraries(shell userlib lib)

add_link_options(-M)
add_executable(kernel kernel.c)
target_link_libraries(kernel klib proc)

add_custom_command(TARGET kernel
    POST_BUILD
    COMMAND bcc -I${CMAKE_SOURCE_DIR}/include -ansi -S -o kernelc.asm -C-t ${CMAKE_CURRENT_SOURCE_DIR}/kernel.c
    COMMAND ${CMAKE_SOURCE_DIR}/scripts/check_size.sh $<TARGET_FILE:kernel> 10
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR})

macro(mark-executable target)
    add_custom_command(TARGET ${ARGV0}
        POST_BUILD
        COMMAND ${CMAKE_SOURCE_DIR}/scripts/insert_bytes.sh $<TARGET_FILE:${ARGV0}>
        COMMENT "Marking ${ARGV0} as executable"
        )
endmacro()

cmake_language(CALL mark-executable shell)
cmake_language(CALL mark-executable uprog1)
cmake_language(CALL mark-executable uprog2)
