import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ProjectMary 1.0

Item {
    id: root
    property ListView tasksList
    property int slideDuration: 200
    signal closeRequested()

    Layout.fillHeight: true
    Layout.preferredWidth: visible ? Layout.preferredWidth : 0
    Layout.minimumWidth: 0

    opacity: visible ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: root.slideDuration } }

    property bool editMode: false

    visible: tasksList && tasksList.currentIndex >= 0

    property var modelData: tasksList && tasksList.currentIndex >= 0
        ? tasksList.model.get(tasksList.currentIndex)
        : null

    property string currentEntryId: modelData ? modelData.id : ""

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6

        RowLayout {
            Layout.fillWidth: true

            Label {
                Layout.fillWidth: true
                visible: !editMode
                text: modelData ? modelData.name : ""
            }

            TextField {
                id: nameEditor
                Layout.fillWidth: true
                visible: editMode
            }

            Button {
                visible: modelData && !editMode
                text: "Edit"
                onClicked: {
                    editMode = true
                    nameEditor.text = modelData.name
                    descriptionEditor.text = modelData.description

                    statusEditor.currentIndex =
                        ["Not started","In progress","Completed"].indexOf(modelData.status)

                    var d = new Date(modelData.deadline)
                    editDay.currentIndex = d.getDate() - 1
                    editMonth.currentIndex = d.getMonth()
                    editYear.currentIndex = [2025,2026,2027,2028,2029].indexOf(d.getFullYear())
                    editHour.currentIndex = d.getHours()
                    editMinute.currentIndex = [0,15,30,45].indexOf(Math.floor(d.getMinutes()/15)*15)
                }
            }

            Button {
                visible: modelData !== null
                text: "Close"
                onClicked: {
                    editMode = false
                    closeRequested()
                }
            }
        }

        RowLayout {
            visible: editMode
            spacing: 6
            Label { text: "Date:" }
            ComboBox { id: editDay; model: Array.from({length:31}, (_,i)=>i+1) }
            ComboBox { id: editMonth; model: ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"] }
            ComboBox { id: editYear; model: [2025,2026,2027,2028,2029] }
        }

        RowLayout {
            visible: editMode
            spacing: 6
            Label { text: "Time:" }
            ComboBox { id: editHour; model: Array.from({length:24},(_,i)=>i) }
            ComboBox { id: editMinute; model: [0,15,30,45] }
        }

        Label {
            visible: !editMode && modelData
            text: modelData
                  ? "Deadline: " + Qt.formatDateTime(modelData.deadline, "dd MMM yyyy hh:mm")
                  : ""
        }

        Label {
            visible: !editMode && modelData
            text: modelData ? "Status: " + modelData.status : ""
        }

        ComboBox {
            id: statusEditor
            model: ["Not started","In progress","Completed"]
            visible: editMode
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text {
                id: descriptionLabel
                text: !editMode && modelData ? modelData.description : ""
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

        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Item { Layout.fillWidth: true }

            Button {
                visible: !editMode && modelData
                text: "Delete"
                onClicked: {
                    if (currentEntryId) {
                        Controller.removeEntryById(currentEntryId)
                        closeRequested()
                    }
                }
            }
        }

        Button {
            visible: editMode
            text: "Save"
            onClicked: {
                if (!currentEntryId) return;

                var deadline = new Date(
                    editYear.currentText,
                    editMonth.currentIndex,
                    editDay.currentText,
                    editHour.currentText,
                    editMinute.currentText
                )

                Controller.updateEntryById(
                    currentEntryId,
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
