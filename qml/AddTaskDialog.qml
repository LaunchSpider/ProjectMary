import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: root
    modal: true
    title: "Add Task"
    standardButtons: Dialog.Ok | Dialog.Cancel

    signal taskSubmitted(string name, string description, date deadline, string status)

    property int selectedDay: new Date().getDate()
    property int selectedMonth: new Date().getMonth() + 1 // 1-based
    property int selectedYear: new Date().getFullYear()
    property int selectedHour: new Date().getHours()
    property int selectedMinute: Math.floor(new Date().getMinutes() / 15) * 15

    function daysInMonth(year, month) {
        return new Date(year, month, 0).getDate();
    }

    onAccepted: {
        const deadline = new Date(selectedYear, selectedMonth - 1, selectedDay, selectedHour, selectedMinute);
        taskSubmitted(
            nameField.text,
            descriptionField.text,
            deadline,
            statusBox.currentText
        )

        // Reset fields
        nameField.text = ""
        descriptionField.text = ""
        selectedDay = new Date().getDate()
        selectedMonth = new Date().getMonth() + 1
        selectedYear = new Date().getFullYear()
        selectedHour = new Date().getHours()
        selectedMinute = Math.floor(new Date().getMinutes() / 15) * 15
        statusBox.currentIndex = 0
    }

    contentItem: ColumnLayout {
        spacing: 6
        anchors.margins: 10

        TextField {
            id: nameField
            placeholderText: "Task name"
            Layout.fillWidth: true
        }

        TextArea {
            id: descriptionField
            placeholderText: "Description"
            Layout.fillWidth: true
            Layout.preferredHeight: 60
        }

        // Date Row
        RowLayout {
            spacing: 10
            Label { text: "Date:" }

            ComboBox {
                id: dayPicker
                model: Array.from({length: daysInMonth(selectedYear, selectedMonth)}, (_, i) => i + 1)
                currentIndex: selectedDay - 1
                onCurrentIndexChanged: selectedDay = model[currentIndex]
            }

            ComboBox {
                id: monthPicker
                model: ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
                currentIndex: selectedMonth - 1
                onCurrentIndexChanged: selectedMonth = currentIndex + 1
            }

            ComboBox {
                id: yearPicker
                model: [2025,2026,2027,2028,2029]
                currentIndex: 0
                onCurrentIndexChanged: selectedYear = model[currentIndex]
            }
        }

        // Time Row
        RowLayout {
            spacing: 10
            Label { text: "Time:" }

            ComboBox {
                id: hourPicker
                model: Array.from({length: 24}, (_, i) => i)
                currentIndex: selectedHour
                onCurrentIndexChanged: selectedHour = model[currentIndex]
            }

            ComboBox {
                id: minutePicker
                model: [0,15,30,45]
                currentIndex: [0,15,30,45].indexOf(selectedMinute)
                onCurrentIndexChanged: selectedMinute = model[currentIndex]
            }
        }

        // Status Row
        RowLayout {
            Label { text: "Status:" }

            ComboBox {
                id: statusBox
                model: ["Not started", "In progress", "Completed"]
            }
        }
    }

    // Update day picker when month or year changes
    onSelectedMonthChanged: dayPicker.model = Array.from({length: daysInMonth(selectedYear, selectedMonth)}, (_, i) => i + 1)
    onSelectedYearChanged: dayPicker.model = Array.from({length: daysInMonth(selectedYear, selectedMonth)}, (_, i) => i + 1)
}
