import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ProjectMary 1.0

Item {
    id: root
    property ListView tasksList
    property int slideDuration: 200
    signal closeRequested()

    // Height always matches parent
    Layout.fillHeight: true

    // Width is now controlled by Main.qml (40%)
    Layout.preferredWidth: visible ? Layout.preferredWidth : 0
    Layout.minimumWidth: 0

    // Fade animation instead of resizing width ourselves
    opacity: visible ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: root.slideDuration } }

    property bool editMode: false

    visible: tasksList && tasksList.currentItem !== null

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6

        // NAME ROW
        RowLayout {
            Layout.fillWidth: true

            Label { Layout.fillWidth: true; visible: !editMode;
                text: tasksList && tasksList.currentItem ? tasksList.currentItem.d_name : "" }

            TextField { id: nameEditor; Layout.fillWidth: true; visible: editMode }

            Button {
                visible: tasksList && tasksList.currentItem !== null && !editMode
                text: "Edit"
                onClicked: {
                    editMode = true
                    if (tasksList.currentItem) {
                        nameEditor.text = tasksList.currentItem.d_name
                        descriptionEditor.text = tasksList.currentItem.d_description
                        statusEditor.currentIndex =
                            ["Not started","In progress","Completed"]
                                .indexOf(tasksList.currentItem.d_status)

                        var d = new Date(tasksList.currentItem.d_deadline)
                        editDay.currentIndex = d.getDate() - 1
                        editMonth.currentIndex = d.getMonth()
                        editYear.currentIndex = [2025,2026,2027,2028,2029].indexOf(d.getFullYear())
                        editHour.currentIndex = d.getHours()
                        editMinute.currentIndex = [0,15,30,45].indexOf(Math.floor(d.getMinutes()/15)*15)
                    }
                }
            }

            Button {
                visible: tasksList && tasksList.currentItem !== null
                text: "Close"
                onClicked: { editMode = false; closeRequested() }
            }
        }

        // DATE ROW
        RowLayout {
            visible: editMode
            spacing: 6
            Label { text: "Date:" }

            ComboBox { id: editDay; model: Array.from({length:31}, (_,i)=>i+1) }
            ComboBox { id: editMonth; model: ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"] }
            ComboBox { id: editYear; model: [2025,2026,2027,2028,2029] }
        }

        // TIME ROW
        RowLayout {
            visible: editMode
            spacing: 6
            Label { text: "Time:" }

            ComboBox { id: editHour; model: Array.from({length:24},(_,i)=>i) }
            ComboBox { id: editMinute; model: [0,15,30,45] }
        }

        // DEADLINE (view mode)
        Label {
            visible: !editMode && tasksList.currentItem
            text: tasksList.currentItem
                ? "Deadline: " + Qt.formatDateTime(tasksList.currentItem.d_deadline, "dd MMM yyyy hh:mm")
                : ""
        }

        // STATUS
        Label {
            text: !editMode && tasksList.currentItem
                  ? "Status: " + tasksList.currentItem.d_status
                  : ""
        }

        ComboBox { id: statusEditor; model: ["Not started","In progress","Completed"]; visible: editMode }

        // DESCRIPTION
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text {
                id: descriptionLabel
                text: !editMode && tasksList.currentItem ? tasksList.currentItem.d_description : ""
                wrapMode: Text.WordWrap
                visible: !editMode
            }

            TextArea {
                id: descriptionEditor
                visible: editMode
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

        // SAVE BUTTON
        Button {
            visible: editMode
            text: "Save"
            onClicked: {
                if (!tasksList.currentItem) return;

                var deadline = new Date(
                    editYear.currentText,
                    editMonth.currentIndex,
                    editDay.currentText,
                    editHour.currentText,
                    editMinute.currentText
                )

                Controller.updateEntry(
                    tasksList.currentIndex,
                    nameEditor.text,
                    descriptionEditor.text,
                    deadline,
                    statusEditor.currentText
                )

                editMode = false
            }
        }
    }
}
