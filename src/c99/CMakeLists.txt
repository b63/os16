enable_language(C)
set(CMAKE_C_COMPILER gcc)
set(CMAKE_C_STANDARD 99)

include_directories(BEFORE ${CMAKE_SOURCE_DIR}/include)

add_executable(testproc testproc.c ${CMAKE_SOURCE_DIR}/src/c/proc.c)
add_custom_command(TARGET testproc
    POST_BUILD
    COMMAND testproc
    WORKING_DIRECTORY ${CMAKE_RUNTIME_DIRECTORY})
