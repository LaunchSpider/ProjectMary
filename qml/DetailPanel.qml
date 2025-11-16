import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Colors.qml" as Colors

Item {
    id: detailPanel
    property var selected

    visible: selected !== null
    implicitWidth: 420

    Rectangle {
        anchors.fill: parent
        color: Colors.panel
        radius: 10
        border.color: Colors.border
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 10

            // --- Title and close ---
            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: selected ? selected.d_name : ""
                    color: Colors.text
                    font.pixelSize: 22
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                }
                Button {
                    text: "Close"
                    onClicked: tasksList.currentIndex = -1
                    background: Rectangle { color: Colors.accent }
                }
            }

            // --- Deadline and status ---
            Label {
                text: selected ? "Deadline: " + selected.d_deadline : ""
                color: Colors.lightText
                Layout.fillWidth: true
            }
            Label {
                text: selected ? "Status: " + selected.d_status : ""
                color: selected
                    ? (selected.d_status === "Completed" ? Colors.success
                        : selected.d_status === "In progress" ? Colors.warning
                        : Colors.error)
                    : Colors.text
                Layout.fillWidth: true
            }

            // --- Description ---
            Rectangle {
                color: Colors.highlight
                radius: 6
                border.color: Colors.border
                Layout.fillWidth: true
                Layout.fillHeight: true
                ScrollView {
                    anchors.fill: parent
                    Text {
                        text: selected ? selected.d_description : ""
                        color: Colors.text
                        font.pixelSize: 16
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }
}
