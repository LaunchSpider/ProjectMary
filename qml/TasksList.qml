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

            // Name column
            Text {
                text: name
                Layout.preferredWidth: parent.width * 0.6   // wide column
                elide: Text.ElideRight
            }

            // Deadline centered
            Text {
                text: {
                    const nowMs = Date.now();
                    const deadlineMs = deadline.getTime();
                    const diffMs = deadlineMs - nowMs;

                    if (diffMs <= 0) {
                        return "Expired";
                    }

                    const msPerDay = 1000 * 60 * 60 * 24;
                    const msPerHour = 1000 * 60 * 60;

                    const diffDays = diffMs / msPerDay;

                    // Show hours if less than 1 day
                    if (diffDays < 1) {
                        const hours = Math.ceil(diffMs / msPerHour);
                        return hours + " hours";
                    }

                    // Otherwise show days
                    return Math.ceil(diffDays) + " days";
                }

                Layout.preferredWidth: parent.width * 0.2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }

            // Status centered
            Text {
                text: status
                Layout.preferredWidth: parent.width * 0.2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }
    }
}


            //Text { text: description; Layout.fillWidth: true; elide: Text.ElideRight }
