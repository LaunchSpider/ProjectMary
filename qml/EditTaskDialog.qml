import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: root
    modal: true
    title: "Edit Task"
    standardButtons: Dialog.Ok | Dialog.Cancel

    signal taskEdited(int index, string name, string description, date deadline, string status)

    property int index: -1  // index of entry to edit
    property int selectedDay: 1
    property int selectedMonth: 1
    property int selectedYear: 2025
    property int selectedHour: 0
    property int selectedMinute: 0

    function daysInMonth(year, month) {
        return new Date(year, month, 0).getDate();
    }

    onAccepted: {
        const deadline = new Date(selectedYear, selectedMonth - 1, selectedDay, selectedHour, selectedMinute);
        taskEdited(index, nameField.text, descriptionField.text, deadline, statusBox.currentText)
    }

    contentItem: ColumnLayout {
        spacing: 6
        anchors.margins: 10

        TextField { id: nameField; Layout.fillWidth: true }
        TextArea { id: descriptionField; Layout.fillWidth: true; Layout.preferredHeight: 60 }

        // Date Row
        RowLayout {
            spacing: 10
            Label { text: "Date:" }
            ComboBox { id: dayPicker; onCurrentIndexChanged: selectedDay = model[currentIndex] }
            ComboBox { id: monthPicker; onCurrentIndexChanged: selectedMonth = currentIndex + 1 }
            ComboBox { id: yearPicker; onCurrentIndexChanged: selectedYear = model[currentIndex] }
        }

        // Time Row
        RowLayout {
            spacing: 10
            Label { text: "Time:" }
            ComboBox { id: hourPicker; onCurrentIndexChanged: selectedHour = model[currentIndex] }
            ComboBox { id: minutePicker; onCurrentIndexChanged: selectedMinute = model[currentIndex] }
        }

        RowLayout {
            Label { text: "Status:" }
            ComboBox { id: statusBox; model: ["Not started", "In progress", "Completed"] }
        }
    }
}
