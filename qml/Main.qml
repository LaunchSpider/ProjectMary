import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ProjectMary 1.0

Window {
    id: root
    width: 900
    height: 600
    visible: true

    property int slideDuration: 200

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

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // LEFT LIST
            TasksList {
                id: tasksList
                model: Controller.entryModel
                Layout.fillHeight: true
                Layout.preferredWidth: 300
                Layout.minimumWidth: 200
            }

            // RIGHT SLIDING PANEL
            TaskDetailPanel {
                id: detailPanel
                tasksList: tasksList
                slideDuration: root.slideDuration
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
