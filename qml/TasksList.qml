import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ListView {
    id: root
    currentIndex: -1
    clip: true

    property string selectedEntryId: ""

    delegate: Rectangle {
        id: delegateRoot
        width: ListView.view.width
        height: 40

        property string d_id: id
        property string d_name: name
        property string d_description: description
        property string d_deadline: deadline
        property string d_status: status

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.currentIndex = model.index
                root.selectedEntryId = id
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 4

            Text {
                text: name
                Layout.preferredWidth: parent.width * 0.6
                elide: Text.ElideRight
            }

            Text {
                text: {
                    const now = new Date();
                    const d = new Date(deadline);

                    let diffMs = d.getTime() - now.getTime();
                    if (diffMs <= 1000)
                        return "Expired";

                    const minute = 60000;
                    const hour   = 3600000;
                    const day    = 86400000;

                    if (diffMs < hour) {
                        const mins = Math.ceil(diffMs / minute);
                        return mins + " min";
                    }

                    if (diffMs < day) {
                        const hours = Math.ceil(diffMs / hour);
                        return hours + " hours";
                    }

                    const days = Math.ceil(diffMs / day);
                    return days + " days";
                }
                Layout.preferredWidth: parent.width * 0.2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                text: status
                Layout.preferredWidth: parent.width * 0.2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
