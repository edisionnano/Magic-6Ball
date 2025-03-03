cmake_minimum_required(VERSION 3.16)

project(magic6ball VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wpedantic -Wuseless-cast -Wconversion -Wsign-conversion -Wshadow")

find_package(Qt6 REQUIRED COMPONENTS Quick Sql)

file(GLOB_RECURSE SOURCES "src/*.cpp")

file(GLOB_RECURSE QML_FILES "src/qml/*.qml")

qt_add_resources(RESOURCES_RCC src/resources.qrc)

set(RESOURCE_PREFIX "qrc:/")

qt_add_executable(app_magic6ball
    ${SOURCES}
    ${RESOURCES_RCC}
)

qt_add_qml_module(app_magic6ball
    URI magic6ball
    VERSION 1.0
)

target_link_libraries(app_magic6ball
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Sql
)

include(GNUInstallDirs)
install(TARGETS app_magic6ball
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
