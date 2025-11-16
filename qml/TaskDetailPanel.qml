import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    property ListView tasksList
    property int slideDuration: 200

    signal closeRequested()

    width: root.parent ? root.parent.width * 0.45 : 400
    height: root.parent ? root.parent.height : 600

    visible: tasksList && tasksList.currentItem !== null

    Behavior on width {
        NumberAnimation {
            duration: root.slideDuration
            easing.type: Easing.InOutQuad
        }
    }

    states: [
        State {
            name: "visible"
            when: tasksList && tasksList.currentItem !== null
            PropertyChanges { target: root; width: root.parent.width * 0.45 }
        },
        State {
            name: "hidden"
            when: !tasksList || tasksList.currentItem === null
            PropertyChanges { target: root; width: 0 }
        }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6

        RowLayout {
            Layout.fillWidth: true

            Label {
                Layout.fillWidth: true
                text: tasksList && tasksList.currentItem ? tasksList.currentItem.d_name : ""
            }

            Button {
                visible: tasksList && tasksList.currentItem !== null
                text: "Close"
                onClicked: closeRequested()
            }
        }

        Label {
            text: tasksList && tasksList.currentItem ? "Deadline: " + tasksList.currentItem.d_deadline : ""
        }

        Label {
            text: tasksList && tasksList.currentItem ? "Status: " + tasksList.currentItem.d_status : ""
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text {
                text: tasksList && tasksList.currentItem ? tasksList.currentItem.d_description : ""
                wrapMode: Text.WordWrap
            }
        }
    }
}
