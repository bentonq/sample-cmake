cmake_minimum_required(VERSION 3.4)

# 检查依赖库Bar，如果是Bar是内部项目则不做任何操作。具体请查看根项目中的 'find_package' 宏。
# Check the dependent library Bar, if Bar is an internal project, do nothing. 
# See the 'find_package' macro in the root project for details.
find_package(Bar 2.0 REQUIRED)

# 添加一个普通的Foo库，并指定源文件。
# Add a normal Foo library and specify the source file.
add_library(Foo src/foo.cpp)

# 指定Foo库的include目录。使用$<>的表达式是为了分开指定BUILD和INSTALL两个过程的include目录。
# 因为Foo库的被依赖的方式即可能是作为内部项目被直接应用：例如被根项目直接add_subdirectory(xxx)；
# 也可能作为外部项目通过install后被引用，例如在根项目中find_package(xxx)。
# Specify the include directory of the Foo library. Expression: $<> is used to 
# specify BUILD and INSTALL processes's include directories separately, because 
# there are two ways to using the Foo library. It may be applied directly as an 
# internal project: for example, add_subdirectory(xxx) directly by the root 
# project; or it may be referenced as an external project after install, 
# for example, find_package(xxx) in the root project.
target_include_directories(Foo PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>  
    $<INSTALL_INTERFACE:include/Foo> 
    )

# 指定依赖库Bar。
# Specify the dependent library Bar. 
target_link_libraries(Foo PUBLIC Bar)

# 指定项目install不同target时的规则，EXPORT选项指定install的导出清单名为FooTargets，这个
# 名字后面会用到。需要注意的是：INCLUDES DESTINATION并不会install任何文件，其用途是添加目
# 录到INTERFACE_INCLUDE_DIRECTORIES，其用途与上面的$<INSTALL_INTERFACE>一样。
# Specify the rules when the project installing different targets. The EXPORT 
# option specifies that this export is named FooTargets, which will be used later. 
# Note that INCLUDES DESTINATION does not install any files. Its purpose is to 
# add a directory to INTERFACE_INCLUDE_DIRECTORIES for the same purpose as 
# $<INSTALL_INTERFACE> above.
install(TARGETS Foo EXPORT FooTargets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include/Foo
    )

# 手动指定include下的头文件install到指定的目录。
# Manually specify the header file install under include to the specified 
# directory.
install(DIRECTORY include/ DESTINATION include/Foo)

# 指定导出清单BarTargets的install信息，包括：名字，命名空间，地址。这里的名字并不是
# FooConfig.cmake。FooConfig.cmake是手动编写的，里面包含了这个FooTargets.cmake。
# 这种方式可以为不同的Config指定不同的依赖。
# Specify the install information of the export list as BarTargets, including: 
# name, namespace, address. The name here is not FooConfig.cmake. The final 
# FooConfig.cmake is written manually and contains the FooTargets.cmake. 
# This way you can specify different dependencies for different Configs.
install(EXPORT FooTargets
    FILE FooTargets.cmake
    NAMESPACE Foo::
    DESTINATION lib/cmake/Foo
    )

# 生成版本号文件。
# Generate version number file.
include(CMakePackageConfigHelpers)
write_basic_package_version_file("FooConfigVersion.cmake"
    VERSION 1.0
    COMPATIBILITY SameMajorVersion
)
# 配置安装版本信息文件与FooConfig.cmake文件，因为上面install(EXPORT)指定的是
# FooTargets.cmake文件。
# Configure the installation of version number file and the FooConfig.cmake file, 
# because the above install(EXPORT) specifies the FooTargets.cmake file.
install(FILES "FooConfig.cmake" ${CMAKE_CURRENT_BINARY_DIR}/FooConfigVersion.cmake
    DESTINATION lib/cmake/Foo
)
