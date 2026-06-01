import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.settings

PanelWindow {
    
    id: root

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "Schedule"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    focusable: true

    anchors {
        left: true
        top: true
    }

    margins {
        left: 15
        top: 15
    }

    implicitWidth: 250

    // Grows with content: fixed chrome + 40px per task (36 tile + 4 spacing), capped at 750
    implicitHeight: Math.min(750, 115 + todoModel.count * (36+4) + (todoModel.count === 0 ? 27 : 0))

    Behavior on implicitHeight {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    color: "transparent"

    Settings {
        id: settings
        category: "todo-widget"
        property string todos: "[]"
    }

    ListModel {
        id: todoModel
    }

    function saveTodos() {
        var arr = []
        for (var i = 0; i < todoModel.count; i++) {
            arr.push({
                text: todoModel.get(i).text,
                done: todoModel.get(i).done
            })
        }
        settings.todos = JSON.stringify(arr)
    }

    function loadTodos() {
        todoModel.clear()
        try {
            var arr = JSON.parse(settings.todos)
            for (var i = 0; i < arr.length; i++) {
                todoModel.append({ text: arr[i].text, done: arr[i].done })
            }
        } catch(e) {}
    }

    function addTodo(txt) {
        var trimmed = txt.trim()
        if (trimmed === "") return
        // Insert before the first done item so new tasks stay at top
        var insertAt = 0
        for (var i = 0; i < todoModel.count; i++) {
            if (!todoModel.get(i).done) insertAt = i + 1
            else break
        }
        todoModel.insert(0, { text: trimmed, done: false })
        saveTodos()
    }

    function removeTodo(index) {
        todoModel.remove(index)
        saveTodos()
    }

    function toggleTodo(index) {
        var item = todoModel.get(index)
        var nowDone = !item.done
        var txt = item.text
        todoModel.remove(index)
        if (nowDone) {
            // Sink to the bottom of the list
            todoModel.append({ text: txt, done: true })
        } else {
            // Float back to the top
            todoModel.insert(0, { text: txt, done: false })
        }
        saveTodos()
    }

    Component.onCompleted: loadTodos()

    Rectangle {
        anchors.fill: parent

        radius: 18
        color: "#e0080808"

        border.width: 0

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 15
            anchors.leftMargin: 15
            anchors.rightMargin: 15
            anchors.bottomMargin: 15
            spacing: 6

            // ── Header ───────────────────────────────────────────────────────
            RowLayout {
                Layout.fillWidth: true

                Text {
		    text: "Schedule"
                    color: "#f0f0f0"
                    font.pixelSize: 20
                    font.weight: Font.Bold
                    font.letterSpacing: -0.5
                }

                Item { Layout.fillWidth: true }

                Text {
                    id: counterText

                    property int done: {
                        var n = 0
                        for (var i = 0; i < todoModel.count; i++)
                            if (todoModel.get(i).done) n++
                        return n
                    }

                    text: done + "/" + todoModel.count
                    color: "#38ffffff"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                }
            }

            // Thin progress bar
            Rectangle {
                Layout.fillWidth: true
                height: 3
                radius: 2
                color: "#0fffffff"

                Rectangle {
                    width: todoModel.count > 0
                        ? parent.width * (counterText.done / todoModel.count)
                        : 0
                    height: parent.height
                    radius: parent.radius
                    color: "#a6e3a1"

                    Behavior on width {
                        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                    }
                }
            }

            // ── Todo list ─────────────────────────────────────────────────────
            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true

                contentHeight: todoColumn.height
                clip: true

                Column {
                    id: todoColumn
                    width: parent.width
                    spacing: 4   // matches tracker item list spacing

                    Repeater {
                        model: todoModel

                        delegate: Rectangle {
                            id: todoItem

                            width: todoColumn.width
                            height: 36   // matches tracker item height

                            radius: 10   // matches tracker item radius
                            color: model.done ? "#0cffffff" : "#14ffffff"

                            border.width: 1
                            border.color: model.done ? "#08ffffff" : "#10ffffff"

                            Behavior on color { ColorAnimation { duration: 200 } }

                            opacity: 0
                            Component.onCompleted: opacity = 1
                            Behavior on opacity {
                                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 10   // matches tracker
                                anchors.rightMargin: 8   // matches tracker
                                spacing: 9               // matches tracker

                                Rectangle {
                                    id: checkRect
                                    width: 16    // matches tracker checkbox
                                    height: 16
                                    radius: 5
                                    color: model.done ? "#a6e3a1" : "transparent"
                                    border.width: 1.5
                                    border.color: model.done ? "#a6e3a1" : "#28ffffff"

                                    Behavior on color { ColorAnimation { duration: 150 } }
                                    Behavior on border.color { ColorAnimation { duration: 150 } }

                                    Text {
                                        anchors.centerIn: parent
                                        text: "✓"
                                        visible: model.done
                                        color: "#1a1a1a"
                                        font.pixelSize: 12   // matches tracker checkmark
                                        font.bold: true
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: toggleTodo(index)
                                    }
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: model.text
                                    color: model.done ? "#40ffffff" : "#e8e8e8"
                                    font.pixelSize: 13   // matches tracker label
                                    font.strikeout: model.done
                                    elide: Text.ElideRight

                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }

                                Rectangle {
                                    width: 22    // matches tracker delete button
                                    height: 22
                                    radius: 7
                                    color: delMouse.containsPress ? "#66331111" : "#44221111"
                                    visible: delMouse.containsMouse || todoItemMouse.containsMouse

                                    Behavior on color { ColorAnimation { duration: 100 } }

                                    Text {
                                        anchors.centerIn: parent
                                        text: "×"
                                        color: "#ff8080"
                                        font.pixelSize: 16   // matches tracker
                                    }

                                    MouseArea {
                                        id: delMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: removeTodo(index)
                                    }
                                }
                            }

                            MouseArea {
                                id: todoItemMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                propagateComposedEvents: true
                                onClicked: mouse.accepted = false
                                onPressed: mouse.accepted = false
                            }
                        }
                    }
                }
            }

            // ── Input row ────────────────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height: 36     // matches tracker add-input height

                radius: 10     // matches tracker add-input radius
                color: "#12ffffff"

                border.width: 1
                border.color: inputField.activeFocus ? "#30ffffff" : "#0cffffff"

                Behavior on border.color {
                    ColorAnimation { duration: 150 }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10   // matches tracker
                    anchors.rightMargin: 6   // matches tracker
                    spacing: 6               // matches tracker

                    TextInput {
                        id: inputField

                        Layout.fillWidth: true

                        color: "white"
                        font.pixelSize: 13   // matches tracker add-field font
                        activeFocusOnPress: true
                        selectByMouse: true
                        clip: true

                        Text {
                            anchors.fill: parent
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Add a task…"
                            color: "#30ffffff"
                            font: inputField.font
                            visible: inputField.text.length === 0 && !inputField.activeFocus
                        }

                        onAccepted: {
                            addTodo(text)
                            text = ""
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: inputField.forceActiveFocus()
                            onPressed: (mouse) => { mouse.accepted = false }
                            onReleased: (mouse) => { mouse.accepted = false }
                            propagateComposedEvents: true
                        }
                    }

                    Rectangle {
                        width: 26    // matches tracker add button
                        height: 26
                        radius: 8
                        color: addMouse.containsPress ? "#38ffffff" : "#1effffff"

                        Behavior on color { ColorAnimation { duration: 100 } }

                        Text {
                            anchors.centerIn: parent
                            text: "+"
                            color: "white"
                            font.pixelSize: 22   // matches tracker
                            font.weight: Font.Light
                        }

                        MouseArea {
                            id: addMouse
                            anchors.fill: parent
                            onClicked: {
                                addTodo(inputField.text)
                                inputField.text = ""
                                inputField.forceActiveFocus()
                            }
                        }
                    }
                }
            }

            // ── Empty state ────────────────────────────────────────────────
            Text {
                Layout.alignment: Qt.AlignHCenter
                visible: todoModel.count === 0
                text: "Nothing here. Add a task ↑"
                color: "#18ffffff"
                font.pixelSize: 10
            }
        }
    }
}
