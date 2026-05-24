import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.settings

PanelWindow {

    id: root

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "notes-widget"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    focusable: true

    anchors {
        right: true
        bottom: true
    }

    margins {
        right: 20
        bottom: 20
    }

    implicitWidth: 340

    implicitHeight: inEditor
        ? 420
        : Math.min(700, notesModel.count * (44 + 8) - 8 + (notesModel.count === 0 ? 44 : 0))

    Behavior on implicitHeight {
        NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
    }

    color: "transparent"

    // ── Persistence ───────────────────────────────────────────────────────────
    Settings {
        id: settings
        category: "notes-widget"
        property string notes: "[]"
    }

    ListModel { id: notesModel }

    // ── State ─────────────────────────────────────────────────────────────────
    property bool   inEditor:   false
    property int    editIndex:  -1
    property string editBuffer: ""

    // ── Helpers ───────────────────────────────────────────────────────────────
    function saveNotes() {
        var arr = []
        for (var i = 0; i < notesModel.count; i++)
            arr.push({ body: notesModel.get(i).body })
        settings.notes = JSON.stringify(arr)
    }

    function loadNotes() {
        notesModel.clear()
        try {
            var arr = JSON.parse(settings.notes)
            for (var i = 0; i < arr.length; i++)
                notesModel.append({ body: arr[i].body })
        } catch(e) {}
    }

    function noteTitle(body) {
        var lines = body.split("\n")
        for (var i = 0; i < lines.length; i++) {
            var l = lines[i].trim()
            if (l !== "") return l
        }
        return "Empty note"
    }

    function notePreview(body) {
        var lines = body.split("\n")
        var seen = 0
        for (var i = 0; i < lines.length; i++) {
            var l = lines[i].trim()
            if (l !== "") {
                seen++
                if (seen === 2) return l
            }
        }
        return ""
    }

    // ── Navigation ────────────────────────────────────────────────────────────
    function openNote(idx) {
        editIndex  = idx
        editBuffer = notesModel.get(idx).body
        inEditor   = true
        Qt.callLater(function() { noteEditor.forceActiveFocus() })
    }

    function openNewNote() {
        editIndex  = -1
        editBuffer = ""
        inEditor   = true
        Qt.callLater(function() { noteEditor.forceActiveFocus() })
    }

    function autosave(txt) {
        editBuffer = txt
        if (editIndex === -1) {
            if (txt.trim() !== "") {
                notesModel.insert(0, { body: txt })
                editIndex = 0
                saveNotes()
            }
        } else {
            notesModel.setProperty(editIndex, "body", txt)
            saveNotes()
        }
    }

    function goBack() {
        if (editIndex !== -1 && notesModel.get(editIndex).body.trim() === "") {
            notesModel.remove(editIndex)
            saveNotes()
        }
        noteEditor.focus = false
        inEditor   = false
        editIndex  = -1
        editBuffer = ""
    }

    function removeNote(idx) {
        if (inEditor && editIndex === idx) {
            noteEditor.focus = false
            inEditor  = false
            editIndex = -1
        }
        notesModel.remove(idx)
        saveNotes()
    }

    Component.onCompleted: loadNotes()

    // ── Floating action button — outside the card, left side ─────────────────
    Rectangle {
        id: fab
        anchors.left:      parent.left
        anchors.top:       parent.top
        anchors.topMargin: 4
        width:  32
        height: 32
        radius: 10
        z: 20

        color: fabMouse.containsPress ? "#55ffffff"
             : fabMouse.containsMouse ? "#38ffffff"
             : "#1affffff"

        Behavior on color { ColorAnimation { duration: 100 } }

        Text {
            anchors.centerIn: parent
            text:  inEditor ? "←" : "+"
            color: "white"
            font.pixelSize: inEditor ? 18 : 22
            font.weight:    inEditor ? Font.Normal : Font.Light
        }

        MouseArea {
            id: fabMouse
            anchors.fill: parent
            hoverEnabled: true
            z: 30
            onClicked: {
                mouse.accepted = true
                if (inEditor) root.goBack()
                else          root.openNewNote()
            }
        }
    }

    // ── Card — no background, no outer radius ─────────────────────────────────
    Item {
        id: card
        anchors.right:  parent.right
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        width: 300

        // ── List view ─────────────────────────────────────────────────────────
        Flickable {
            anchors.fill:  parent
            visible:       !inEditor
            opacity:        inEditor ? 0 : 1
            contentHeight:  noteColumn.height
            clip:           true

            Behavior on opacity { NumberAnimation { duration: 150 } }

            Column {
                id: noteColumn
                width: parent.width
                spacing: 8

                Repeater {
                    model: notesModel

                    delegate: Rectangle {
                        width:  noteColumn.width
                        height: 44
                        radius: 14
                        color:  rowMouse.containsMouse ? "#22ffffff" : "#15ffffff"
                        border.width: 1
                        border.color: "#10ffffff"

                        Behavior on color { ColorAnimation { duration: 150 } }

                        opacity: 0
                        Component.onCompleted: opacity = 1
                        Behavior on opacity {
                            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }

                        MouseArea {
                            id: rowMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.openNote(index)
                        }

                        RowLayout {
                            anchors.fill:        parent
                            anchors.leftMargin:  14
                            anchors.rightMargin: 10
                            spacing: 10

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    Layout.fillWidth: true
                                    text:  noteTitle(model.body)
                                    color: "#e8e8e8"
                                    font.pixelSize: 14
                                    font.weight: Font.Medium
                                    elide: Text.ElideRight
                                }
                            }

                            Rectangle {
                                width:   26
                                height:  26
                                radius:  8
                                color:   delMouse.containsPress ? "#66331111" : "#44221111"
                                visible: delMouse.containsMouse || rowMouse.containsMouse

                                Behavior on color { ColorAnimation { duration: 100 } }

                                Text {
                                    anchors.centerIn: parent
                                    text:  "×"
                                    color: "#ff8080"
                                    font.pixelSize: 16
                                }

                                MouseArea {
                                    id: delMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: root.removeNote(index)
                                }
                            }
                        }
                    }
                }

                // Empty state
                Item {
                    width:   noteColumn.width
                    height:  56
                    visible: notesModel.count === 0

                    Text {
                        anchors.centerIn: parent
                        text:  "No notes yet."
                        color: "#30ffffff"
                        font.pixelSize: 13
                    }
                }
            }
        }

        // ── Editor ────────────────────────────────────────────────────────────
        Rectangle {
            anchors.fill: parent
            visible:      inEditor
            opacity:      inEditor ? 1 : 0
            radius:       14
            color:        "#80101010"
            border.width: 0

            Behavior on opacity { NumberAnimation { duration: 180 } }

            Flickable {
                id: editorFlick
                anchors.fill:    parent
                anchors.margins: 14
                contentHeight:   noteEditor.contentHeight
                clip:            true

                function ensureCursorVisible() {
                    var cy = noteEditor.cursorRectangle.y
                    var ch = noteEditor.cursorRectangle.height
                    if (contentY > cy)
                        contentY = cy
                    else if (contentY + height < cy + ch)
                        contentY = cy + ch - height
                }

                TextEdit {
                    id: noteEditor
                    width:  editorFlick.width
                    height: Math.max(editorFlick.height, contentHeight)

                    color:             "white"
                    selectionColor:    "#4089dceb"
                    selectedTextColor: "white"
                    font.pixelSize:    14
                    wrapMode:          TextEdit.Wrap
                    selectByMouse:     true

                    onVisibleChanged: {
                        if (visible) {
                            text           = root.editBuffer
                            cursorPosition = text.length
                        }
                    }

                    Text {
                        anchors.fill: parent
                        text:  "Start writing…"
                        color: "#40ffffff"
                        font:  noteEditor.font
                        visible: noteEditor.text.length === 0 && !noteEditor.activeFocus
                    }

                    onTextChanged:           { root.autosave(text); editorFlick.ensureCursorVisible() }
                    onCursorRectangleChanged:  editorFlick.ensureCursorVisible()
                }
            }
        }
    }
}
