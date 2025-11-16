cmake_minimum_required(VERSION 3.16)

project(ProjectMary VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

add_executable(appProjectMary
    main.cpp
)

qt_add_qml_module(appProjectMary
    URI ProjectMary
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/TasksList.qml
        qml/AddTaskDialog.qml
        qml/TaskDetailPanel.qml
    SOURCES
        include/EntryStorage/Entry.hpp
        include/EntryStorage/EntryVector.hpp
        include/TableModels/EntryListModel.hpp
        include/Controllers/Controller.hpp
        src/TableModels/EntryListModel.cpp
        src/Controllers/Controller.cpp
)

target_include_directories(appProjectMary
    PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/include/EntryStorage"
        "${CMAKE_CURRENT_SOURCE_DIR}/include/TableModels"
        "${CMAKE_CURRENT_SOURCE_DIR}/include/Controllers"
)

target_link_libraries(appProjectMary
    PRIVATE Qt6::Quick
)
