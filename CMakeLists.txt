cmake_minimum_required(VERSION 3.16)

project(magic6ball VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Sql)

file(GLOB_RECURSE SOURCES "src/*.cpp")

file(GLOB_RECURSE QML_FILES "src/qml/*.qml")

set(RELATIVE_QML_FILES)
foreach(QML_FILE IN LISTS QML_FILES)
    string(REPLACE "${CMAKE_SOURCE_DIR}/" "" RELATIVE_PATH "${QML_FILE}")
    list(APPEND RELATIVE_QML_FILES "${RELATIVE_PATH}")
endforeach()

qt_policy(SET QTP0004 NEW)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_resources(RESOURCES_RCC src/resources.qrc)

qt_add_executable(app_magic6ball
    ${SOURCES}
    ${RESOURCES_RCC}
)

set_source_files_properties(src/main.cpp PROPERTIES
    AUTOMOC ON
)

qt_add_qml_module(app_magic6ball
    URI magic6ball
    VERSION 1.0
    QML_FILES
        ${RELATIVE_QML_FILES}
)

set_target_properties(app_magic6ball PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
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
