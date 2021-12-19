enable_language(ASM)
set(CMAKE_ASM_COMPILER as86)
set(CMAKE_ASM_LINKER   ld86)

set(CMAKE_ASM_COMPILE_OBJECT
    "<CMAKE_ASM_COMPILER> <DEFINES> <INCLUDES> <FLAGS> -o <OBJECT> <SOURCE>")
set(CMAKE_ASM_LINK_EXECUTABLE
    "${CMAKE_ASM_LINKER} <LINK_FLAGS> -o <TARGET> -d <OBJECTS> <LINK_LIBRARIES>")

add_library(lib   OBJECT lib.asm)
add_library(klib  OBJECT kernel.asm)

#add_custom_command(
#    OUTPUT bootload
#    COMMAND "<CMAKE_ASM_NASM_COMPILER> -o bootload ${CMAKE_CURRENT_SOURCE_DIR}/bootload.asm"
#    MAIN_DEPENDENCY bootload.asm
#    SOURCES bootload.asm
#    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
#    VERBATIM)
#add_custom_target(bootload
#    DEPENDS bootload)
#add_executable(bootload ALIAS bootload)
