enable_language(CXX)
set(CMAKE_CXX_COMPILER g++)
set(CMAKE_CXX_STANDARD 17)

include_directories(BEFORE ${CMAKE_SOURCE_DIR}/include)

add_executable(loadFile loadFile.cpp)
