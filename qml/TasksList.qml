import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ListView {
    id: root
    currentIndex: -1
    clip: true

    delegate: Rectangle {
        id: delegateRoot
        width: ListView.view.width
        height: 40

        property string d_name: name
        property string d_description: description
        property string d_deadline: deadline
        property string d_status: status

        MouseArea {
            anchors.fill: parent
            onClicked: root.currentIndex = index
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 4

            Text { text: name; Layout.preferredWidth: 120; elide: Text.ElideRight }
            Text { text: deadline; Layout.preferredWidth: 100; elide: Text.ElideRight }
            Text { text: description; Layout.fillWidth: true; elide: Text.ElideRight }
            Text { text: status; Layout.preferredWidth: 90; elide: Text.ElideRight }
        }
    }
}
