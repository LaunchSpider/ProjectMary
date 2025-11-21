import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ProjectMary 1.0

ApplicationWindow{
    id: root
    width: 900
    height: 600
    visible: true

    property int slideDuration: 200

    Component.onCompleted: {
            // Load previously saved entries when the app starts
            Controller.loadEntries("entries.csv")
        }

    onClosing: {
            // Call your save method before the app closes
            Controller.saveEntries("entries.csv")
        }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // TOP BAR WITH "ADD TASK"
        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Button {
                text: "Add Task"
                onClicked: addTaskDialog.open()
            }

            Item { Layout.fillWidth: true }
        }

        // LAYOUT WITH TABLE SORTING
        RowLayout {
            Layout.preferredWidth: 0.6 * root.width
            spacing: 6

            Item { Layout.preferredWidth: 0.575 * root.width } // plugger to move the button to the right of the row

            Button {
                id: sortBtn
                text: Controller.entryModel.sortAscending() ? "⇊" : "⇈"
                font.pixelSize: 15
                Layout.preferredWidth: width
                Layout.preferredHeight: height

                onClicked: {
                    Controller.toggleSortOrder()
                    sortBtn.text = Controller.entryModel.sortAscending() ? "⇊" : "⇈"
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // LEFT LIST — now 60% width
            TasksList {
                id: tasksList
                model: Controller.entryModel
                Layout.fillHeight: true

                Layout.preferredWidth: 0.6 * root.width
                Layout.minimumWidth: 250
            }

            // RIGHT SLIDING PANEL — now 40% width
            TaskDetailPanel {
                id: detailPanel
                tasksList: tasksList
                slideDuration: root.slideDuration

                Layout.fillHeight: true
                Layout.preferredWidth: 0.4 * root.width

                onCloseRequested: tasksList.currentIndex = -1
            }
        }
    }

    AddTaskDialog {
        id: addTaskDialog
        onTaskSubmitted: function(name, description, deadline, status) {
            Controller.addEntry(name, description, deadline, status)
        }
    }
}
