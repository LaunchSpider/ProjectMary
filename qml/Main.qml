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

    property string currentView: "All"

    Component.onCompleted: {
        // Load previously saved entries when the app starts
        Controller.loadEntries("entries.csv")
    }

    onClosing: {
        // Call your save method before the app closes
        Controller.saveEntries("entries.csv")
    }

    // OUTER ROWLAYOUT: LEFT COLUMN + MAIN CONTENT
    RowLayout {
        anchors.fill: parent
        spacing: 0

        // LEFT COLUMN (10%)
        ColumnLayout {
            id: leftPanel
            Layout.preferredWidth: 0.10 * root.width
            Layout.fillHeight: true
            spacing: 10

            Item { Layout.fillWidth: true; Layout.preferredHeight: 15 }

            Text {
                text: "📅"
                font.pointSize: 18
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.fillWidth: true
            }

            Item { Layout.fillWidth: true; Layout.preferredHeight: 20 } // Spacer

            ColumnLayout {
                id: buttonColumn
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                spacing: 12

                Button {
                    id: allButton
                    text: "All"
                    Layout.preferredWidth: 0.6 * leftPanel.width
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: currentView = "All"
                }
                Button {
                    id: weekButton
                    text: "Week"
                    Layout.preferredWidth: 0.6 * leftPanel.width
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: currentView = "Week"
                }
                Button {
                    id: monthButton
                    text: "Month"
                    Layout.preferredWidth: 0.6 * leftPanel.width
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: currentView = "Month"
                }
            }

            Item { Layout.fillHeight: true }
        }


        // MAIN CONTENT (85%) — your previous layout
        ColumnLayout {
            Layout.preferredWidth: 0.90 * root.width
            Layout.fillHeight: true
            spacing: 0

            Item { Layout.fillWidth: true; Layout.preferredHeight: 15 }

            // TOP BAR SECTION NAME"
            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                Text {
                    text: currentView
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.fillWidth: true
                }

                Item { Layout.fillWidth: true }
            }

            // MIDDLE BAR WITH "ADD TASK"
            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                Button {
                    text: "Add Task"
                    onClicked: addTaskDialog.open()
                }

                Item { Layout.fillWidth: true }
            }

            // TWO-PANEL INTERFACE
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                // TASK TABLE
                ColumnLayout {
                    id: tableColumn
                    Layout.fillHeight: true
                    Layout.preferredWidth: 0.7 * root.width
                    Layout.minimumWidth: 250

                    // HEADER ROW
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        ToolButton {
                            text: "Name"
                            Layout.fillWidth: true
                            Layout.preferredWidth: 6
                            onClicked: Controller.sortBy("name")
                        }
                        ToolButton {
                            text: "Deadline"
                            Layout.fillWidth: true
                            Layout.preferredWidth: 2
                            onClicked: Controller.sortBy("deadline")
                        }
                        ToolButton {
                            text: "Status"
                            Layout.fillWidth: true
                            Layout.preferredWidth: 2
                            onClicked: Controller.sortBy("status")
                        }
                    }

                    // TABLE/LIST
                    TasksList {
                        id: tasksList
                        model: Controller.entryModel
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                }

                // TASK DETAILS PANEL
                TaskDetailPanel {
                    id: detailPanel
                    tasksList: tasksList
                    slideDuration: root.slideDuration
                    Layout.fillHeight: true
                    Layout.preferredWidth: 0.3 * root.width
                    onCloseRequested: tasksList.currentIndex = -1
                }
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
