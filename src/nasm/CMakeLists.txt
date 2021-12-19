enable_language(ASM)
set(CMAKE_ASM_COMPILER nasm)

set(CMAKE_ASM_COMPILE_OBJECT
    "<CMAKE_ASM_COMPILER> <DEFINES> <INCLUDES> <FLAGS> -o <OBJECT> <SOURCE>")

add_library(bootload OBJECT bootload.asm)
#set_property(TARGET bootload PROPERTY LANGUAGE ASM_NASM)
