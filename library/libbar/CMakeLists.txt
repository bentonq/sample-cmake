cmake_minimum_required(VERSION 3.4)

# 添加只有头文件的Bar库，使用INTERFACE以表示没有源文件。这种类型的库没有编译输出，但依然可以
# 添加库属性。INTERFACE的库也只能拥有INTERFACE的属性。
# Add a Bar library with only header files, use INTERFACE to indicate that 
# there are no source files. This type of library does not have compiled output, 
# but you can still add library properties. The INTERFACE library can only have 
# INTERFACE properties.
add_library(Bar INTERFACE)

# 指定Bar库的include目录。使用$<>的表达式是为了分开指定BUILD和INSTALL两个过程的include目录。
# 因为Bar库的被依赖的方式即可能是作为内部工程被直接应用：例如被根工程直接add_subdirectory(xxx)；
# 也可能作为外部工程通过install后被引用，例如在根工程中find_package(xxx)。
# Specify the include directory of the Bar library. Expression: $<> is used to 
# specify BUILD and INSTALL processes's include directories separately, because 
# there are two ways to using the Bar library. It may be applied directly as an 
# internal project: for example, add_subdirectory(xxx) directly by the root 
# project; or it may be referenced as an external project after install, 
# for example, find_package(xxx) in the root project.
target_include_directories(Bar INTERFACE 
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
    $<INSTALL_INTERFACE:include/Bar>
    )

# 指定工程install不同target时的规则，EXPORT选项指定install的导出清单名为BarTargets，这个
# 名字后面会用到。需要注意的是：INCLUDES DESTINATION并不会install任何文件，其用途是添加目
# 录到INTERFACE_INCLUDE_DIRECTORIES，其用途与上面的$<INSTALL_INTERFACE>一样。
# Specify the rules when the project installing different targets. The EXPORT 
# option specifies that this export is named BarTargets, which will be used later. 
# Note that INCLUDES DESTINATION does not install any files. Its purpose is to 
# add a directory to INTERFACE_INCLUDE_DIRECTORIES for the same purpose as 
# $<INSTALL_INTERFACE> above.
install(TARGETS Bar EXPORT BarTargets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include/Bar
    )

# 手动指定src下的头文件install到指定的目录。
# Manually specify the header file install under src to the specified 
# directory.
install(DIRECTORY src/ DESTINATION include/Bar)

# 指定导出清单BarTargets的install信息，包括：名字，命名空间，地址。
# Specify the install information of the export list as BarTargets, including: 
# name, namespace, address. 
install(EXPORT BarTargets
    FILE BarConfig.cmake
    NAMESPACE Bar::
    DESTINATION lib/cmake/Bar
    )

# 生成版本号信息，并指定install过程。
# Generate version number file and config the installation of this file
include(CMakePackageConfigHelpers)
write_basic_package_version_file("BarConfigVersion.cmake"
    VERSION 2.0
    COMPATIBILITY SameMajorVersion
    )
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/BarConfigVersion.cmake
    DESTINATION lib/cmake/Bar)