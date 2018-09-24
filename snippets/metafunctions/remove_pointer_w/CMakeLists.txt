cmake_minimum_required(VERSION 3.0.0)
project(Proj)

set_target_properties(Proj
    PROPERTIES
        CXX_STANDARD 17
)

add_executable(Proj main.cpp)
