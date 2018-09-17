cmake_minimum_required(VERSION 3.4)

# 包装find_package命令，统一了内部项目和外部项目对依赖库的检查。因为内部项目不需要依赖性检查,
# 所以对内部项目直接跳过。
# Wrapping the find_package command, unifying internal project and external 
# project checking for dependent libraries. This macro skips the internal project
# directly, for internal projects do not require dependency checking.
macro(find_package)
    if(NOT ${ARGV0} IN_LIST as_subproject)
        _find_package(${ARGV})
    endif() 
endmacro()

# 添加内部项目，并指定Foo，Bar为内部项目。
# Add the internal projects and specify Foo, Bar both as an internal project.
set(as_subproject Foo Bar)
add_subdirectory(library/libbar)
add_subdirectory(library/libfoo)

# 检查依赖库Foo，如果是Foo是内部项目则不做任何操作。具体请查看 'find_package' 宏。
# Check the dependency library Foo, if Foo is an internal project, do nothing. 
# See the 'find_package' macro for details.
find_package(Foo 1.0 REQUIRED)

# 这些选项不是编译一个项目的必要条件，全局性的放在这里。
# These options are not the requirements to compile a project, globally placed 
# here.
if(MSVC)
    add_compile_options(/W4)
else()
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# 添加一个可执行程序hello-world，并指定源文件。
# Add an executable program hello-world and specify the source file.
add_executable(hello-world main.cpp)

# 指定hello-world的编译features。
# Specify the compiled features of hello-world.
target_compile_features(hello-world PRIVATE cxx_std_14)

# 指定依赖库Foo。
# Specify the dependency library Foo.
target_link_libraries(hello-world Foo)
