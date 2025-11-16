import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ProjectMary 1.0

Item {
    id: root
    property ListView tasksList
    property int slideDuration: 200
    signal closeRequested()

    width: root.parent ? root.parent.width * 0.45 : 400
    height: root.parent ? root.parent.height : 600

    property bool editMode: false

    visible: tasksList && tasksList.currentItem !== null

    Behavior on width { NumberAnimation { duration: root.slideDuration; easing.type: Easing.InOutQuad } }

    states: [
        State { name: "visible"; when: tasksList && tasksList.currentItem !== null; PropertyChanges { target: root; width: root.parent.width * 0.45 } },
        State { name: "hidden"; when: !tasksList || tasksList.currentItem === null; PropertyChanges { target: root; width: 0 } }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6

        // Name row
        RowLayout {
            Layout.fillWidth: true

            Label { Layout.fillWidth: true; visible: !editMode; text: tasksList && tasksList.currentItem ? tasksList.currentItem.d_name : "" }
            TextField { id: nameEditor; Layout.fillWidth: true; visible: editMode }

            Button { visible: tasksList && tasksList.currentItem !== null && !editMode; text: "Edit"; onClicked: {
                editMode = true
                if (tasksList.currentItem) {
                    nameEditor.text = tasksList.currentItem.d_name
                    descriptionEditor.text = tasksList.currentItem.d_description
                    statusEditor.currentIndex = ["Not started","In progress","Completed"].indexOf(tasksList.currentItem.d_status)

                    // parse current deadline to JS Date
                    var d = new Date(tasksList.currentItem.d_deadline)
                    editDay.currentIndex = d.getDate() - 1
                    editMonth.currentIndex = d.getMonth()
                    editYear.currentIndex = [2025,2026,2027,2028,2029].indexOf(d.getFullYear())
                    editHour.currentIndex = d.getHours()
                    editMinute.currentIndex = [0,15,30,45].indexOf(Math.floor(d.getMinutes()/15)*15)
                }
            } }

            Button { visible: tasksList && tasksList.currentItem !== null; text: "Close"; onClicked: { editMode = false; closeRequested() } }
        }

        // DATE ROW
        RowLayout {
            spacing: 6
            Label { text: "Date:" }

            ComboBox { id: editDay; model: Array.from({length:31}, (_,i)=>i+1) }
            ComboBox { id: editMonth; model: ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"] }
            ComboBox { id: editYear; model: [2025,2026,2027,2028,2029] }

            visible: editMode
        }

        // TIME ROW
        RowLayout {
            spacing: 6
            Label { text: "Time:" }

            ComboBox { id: editHour; model: Array.from({length:24},(_,i)=>i) }
            ComboBox { id: editMinute; model: [0,15,30,45] }

            visible: editMode
        }

        // Status row
        Label { text: !editMode && tasksList.currentItem ? "Status: " + tasksList.currentItem.d_status : "" }
        ComboBox { id: statusEditor; model: ["Not started","In progress","Completed"]; visible: editMode }

        // Description
        ScrollView { Layout.fillWidth: true; Layout.fillHeight: true
            Text { id: descriptionLabel; text: !editMode && tasksList.currentItem ? tasksList.currentItem.d_description : ""; wrapMode: Text.WordWrap }
            TextArea { id: descriptionEditor; visible: editMode; Layout.fillWidth: true; Layout.fillHeight: true }
        }

        // Save button
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
