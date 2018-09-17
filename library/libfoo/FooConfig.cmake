# 想要正确传递依赖信息，这样写就对了。另外，自称为工业标准的CMake搞得比C/CPP还复杂。
# To pass the dependency information correctly, write like this. By the way,
# CMake, which claims to be an industry standard build tool for C/CPP, is even 
# more complicated than C/CPP.
include(CMakeFindDependencyMacro)
find_dependency(Bar 2.0)

# 包含替代FooConfig.cmake生成的FooTargets.cmake。
# Include FooTargets.cmake generated as instead of  FooConfig.cmake.
include("${CMAKE_CURRENT_BINARY_DIR}/FooTargets.cmake")