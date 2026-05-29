import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Qt.labs.settings

// ══════════════════════════════════════════════════════════════════════════════
//  Tracker — daily columnar checklist widget
//
//  ── Column config ────────────────────────────────────────────────────────────
//  Edit `trackerColumns` to define your columns and their seed items.
//  { name: "Label", items: ["task 1", "task 2", ...] }
//  Only used on first launch — Settings takes over after that.
// ══════════════════════════════════════════════════════════════════════════════

PanelWindow {
    id: root

    // ── CONFIG ─────────────────────────────────────────────────────────────────
    readonly property int colCardWidth: 200   // width of each column card
    readonly property int colGap:        15   // gap between columns
    readonly property int numColumns:     5   // ← change this to add/remove columns
    // ──────────────────────────────────────────────────────────────────────────

    WlrLayershell.layer:         WlrLayer.Background
    WlrLayershell.namespace:     "tracker-widget"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    focusable: true

    anchors { top: true }
    margins { top: 34 }

    implicitWidth:  colsRow.implicitWidth + 28
    implicitHeight: colsRow.implicitHeight + 28

    color: "transparent"

    // ── Persistence ────────────────────────────────────────────────────────────
    Settings {
        id: settings
        category: "tracker-widget"
        property string columnData: "[]"
        property string lastDate:   ""
    }

    // ── Runtime state — single source of truth ─────────────────────────────────
    // Array of { name: string, items: [{ text: string, done: bool }] }
    property var columnsData: []

    // ── Date helpers ───────────────────────────────────────────────────────────
    function todayString() {
        var d = new Date()
        return d.getFullYear() + "-"
             + String(d.getMonth() + 1).padStart(2, "0") + "-"
             + String(d.getDate()).padStart(2, "0")
    }

    function msUntilMidnight() {
        var now  = new Date()
        var next = new Date(now)
        next.setHours(24, 0, 0, 0)
        return next - now
    }

    // ── Midnight reset timer ───────────────────────────────────────────────────
    Timer {
        id: midnightTimer
        repeat: false
        onTriggered: {
            root.resetChecks()
            midnightTimer.interval = root.msUntilMidnight()
            midnightTimer.start()
        }
    }

    // ── Helpers ────────────────────────────────────────────────────────────────
    function deepCopy(obj) { return JSON.parse(JSON.stringify(obj)) }

    function saveData() {
        settings.columnData = JSON.stringify(columnsData)
        settings.lastDate   = todayString()
    }

    

    function loadData() {
        var today = todayString()
        try {
            var stored = JSON.parse(settings.columnData)
            if (stored && stored.length > 0) {
                if (settings.lastDate !== today) {
                    for (var i = 0; i < stored.length; i++)
                        for (var j = 0; j < stored[i].items.length; j++)
                            stored[i].items[j].done = false
                }
                // Pad with blank columns if numColumns increased
                while (stored.length < numColumns)
                    stored.push({ name: "New Column", items: [] })
                // Trim if numColumns decreased
                if (stored.length > numColumns)
                    stored = stored.slice(0, numColumns)
                columnsData = stored
                settings.lastDate = today
                saveData()
                return
            }
        } catch(e) {}
        seedFromConfig()
    }

    function seedFromConfig() {
        var data = []
        for (var i = 0; i < trackerColumns.length; i++) {
            var col = trackerColumns[i]
            var items = []
            for (var j = 0; j < col.items.length; j++)
                items.push({ text: col.items[j], done: false })
            data.push({ name: col.name, items: items })
        }
        columnsData = data
        saveData()
    }

    function resetChecks() {
        var data = deepCopy(columnsData)
        for (var i = 0; i < data.length; i++)
            for (var j = 0; j < data[i].items.length; j++)
                data[i].items[j].done = false
        columnsData = data
        settings.lastDate = todayString()
        saveData()
    }

    function addItem(colIdx, text) {
        var trimmed = text.trim()
        if (trimmed === "") return
        var data = deepCopy(columnsData)
        data[colIdx].items.push({ text: trimmed, done: false })
        columnsData = data
        saveData()
    }

    function removeItem(colIdx, itemIdx) {
        var data = deepCopy(columnsData)
        data[colIdx].items.splice(itemIdx, 1)
        columnsData = data
        saveData()
    }

    function toggleItem(colIdx, itemIdx) {
        var data = deepCopy(columnsData)
        data[colIdx].items[itemIdx].done = !data[colIdx].items[itemIdx].done
        columnsData = data
        saveData()
    }

    function renameColumn(colIdx, newName) {
        var trimmed = newName.trim()
        if (trimmed === "") return
        var data = deepCopy(columnsData)
        data[colIdx].name = trimmed
        columnsData = data
        saveData()
    }

    function editItemText(colIdx, itemIdx, newText) {
        var trimmed = newText.trim()
        if (trimmed === "") return
        var data = deepCopy(columnsData)
        data[colIdx].items[itemIdx].text = trimmed
        columnsData = data
        saveData()
    }

    Component.onCompleted: {
        loadData()
        midnightTimer.interval = msUntilMidnight()
        midnightTimer.start()
    }

    // ── Outer card ─────────────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        radius:       24
        color:        "#e0080808"
        border.width: 0
    }

    // ── Column row ─────────────────────────────────────────────────────────────
    Row {
        id: colsRow
        anchors.centerIn: parent
        spacing: root.colGap

        Repeater {
            id: columnsRepeater
            // Drive the repeater directly off columnsData.length so it
            // rebuilds whenever the array is replaced.
            model: root.columnsData.length

            delegate: Item {
                id: cardRoot
                // Capture the index at creation time into a stable local var.
                // This is the fix for the "all columns show Morning" bug —
                // delegate properties are re-evaluated lazily and `index` can
                // drift; a local property bound at construction is stable.
                readonly property int ci: index

                width:  root.colCardWidth
                // Height tracks the column layout's implicit height
                height: cardCol.implicitHeight

                // Local model for this column's items
                ListModel { id: itemModel }

                // Sync itemModel whenever columnsData changes
                function syncModel() {
                    if (ci >= root.columnsData.length) return
                    var items = root.columnsData[ci].items
                    // Avoid a full clear+repopulate if only done flags changed —
                    // just patch in place when counts match.
                    if (itemModel.count === items.length) {
                        for (var k = 0; k < items.length; k++) {
                            if (itemModel.get(k).text !== items[k].text)
                                itemModel.setProperty(k, "text", items[k].text)
                            if (itemModel.get(k).done !== items[k].done)
                                itemModel.setProperty(k, "done", items[k].done)
                        }
                    } else {
                        itemModel.clear()
                        for (var j = 0; j < items.length; j++)
                            itemModel.append({ text: items[j].text, done: items[j].done })
                    }
                }

                Connections {
                    target: root
                    function onColumnsDataChanged() { cardRoot.syncModel() }
                }

                Component.onCompleted: syncModel()

                // Count done for the progress line
                property int doneCount: {
                    var n = 0
                    for (var i = 0; i < itemModel.count; i++)
                        if (itemModel.get(i).done) n++
                    return n
                }

                ColumnLayout {
                    id: cardCol
                    width:   root.colCardWidth
                    spacing: 6

                    // ── Column header ──────────────────────────────────────────
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        Item {
                            Layout.fillWidth: true
                            height: 24

                            Text {
                                id: colTitleText
                                anchors.fill:          parent
                                anchors.leftMargin:    2
                                // Read name directly from the stable ci index
                                text: root.columnsData.length > cardRoot.ci
                                      ? root.columnsData[cardRoot.ci].name
                                      : ""
                                color:             "#f0f0f0"
                                font.pixelSize:    15
                                font.weight:       Font.Bold
                                font.letterSpacing: -0.3
                                font.family:       "JetBrainsMono Nerd Font"
                                verticalAlignment: Text.AlignVCenter
                                visible:           !titleEdit.visible
                            }

                            TextInput {
                                id: titleEdit
                                anchors.fill:      parent
                                anchors.leftMargin: 2
                                color:             "white"
                                font:              colTitleText.font
                                text:              colTitleText.text
                                visible:           false
                                selectByMouse:     true
                                verticalAlignment: Text.AlignVCenter

                                onAccepted: commitTitle()
                                onActiveFocusChanged: { if (!activeFocus) commitTitle() }

                                function commitTitle() {
                                    root.renameColumn(cardRoot.ci, text)
                                    visible = false
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onDoubleClicked: {
                                    titleEdit.text    = colTitleText.text
                                    titleEdit.visible = true
                                    titleEdit.forceActiveFocus()
                                    titleEdit.selectAll()
                                }
                            }
                        }

                        Text {
                            text:           cardRoot.doneCount + "/" + itemModel.count
                            color:          "#38ffffff"
                            font.pixelSize: 12
                            font.family:    "JetBrainsMono Nerd Font"
                        }
                    }

                    // Thin progress bar
                    Rectangle {
                        Layout.fillWidth: true
                        height: 3
                        radius: 2
                        color:  "#0fffffff"

                        Rectangle {
                            width: itemModel.count > 0
                                   ? parent.width * (cardRoot.doneCount / itemModel.count)
                                   : 0
                            height: parent.height
                            radius: parent.radius
                            color:  "#a6e3a1"
                            Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
                        }
                    }

                    // ── Item list ──────────────────────────────────────────────
                    Column {
                        Layout.fillWidth: true
                        spacing: 4

                        Repeater {
                            model: itemModel

                            delegate: Rectangle {
                                id: itemRow
                                // Capture item index the same way
                                readonly property int ii: index

                                width:        root.colCardWidth
                                height:       36
                                radius:       10
                                color:        model.done ? "#0cffffff" : "#14ffffff"
                                border.width: 1
                                border.color: model.done ? "#08ffffff" : "#10ffffff"

                                Behavior on color { ColorAnimation { duration: 200 } }

                                opacity: 0
                                Component.onCompleted: opacity = 1
                                Behavior on opacity {
                                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                                }

                                RowLayout {
                                    anchors.fill:        parent
                                    anchors.leftMargin:  10
                                    anchors.rightMargin: 8
                                    spacing: 9

                                    // Checkbox
                                    Rectangle {
                                        width:        16
                                        height:       16
                                        radius:       5
                                        color:        model.done ? "#a6e3a1" : "transparent"
                                        border.width: 1.5
                                        border.color: model.done ? "#a6e3a1" : "#28ffffff"

                                        Behavior on color        { ColorAnimation { duration: 150 } }
                                        Behavior on border.color { ColorAnimation { duration: 150 } }

                                        Text {
                                            anchors.centerIn: parent
                                            text:    "✓"
                                            visible: model.done
                                            color:   "#1a1a1a"
                                            font.pixelSize: 12
                                            font.bold: true
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: root.toggleItem(cardRoot.ci, itemRow.ii)
                                        }
                                    }

                                    // Label / inline editor
                                    Item {
                                        Layout.fillWidth: true
                                        height: itemRow.height

                                        Text {
                                            id: itemLbl
                                            anchors.fill:          parent
                                            text:                  model.text
                                            color:                 model.done ? "#40ffffff" : "#e8e8e8"
                                            font.pixelSize:        13
                                            font.strikeout:        model.done
                                            verticalAlignment:     Text.AlignVCenter
                                            elide:                 Text.ElideRight
                                            visible:               !itemEdit.visible

                                            Behavior on color { ColorAnimation { duration: 200 } }
                                        }

                                        TextInput {
                                            id: itemEdit
                                            anchors.fill:      parent
                                            color:             "white"
                                            font:              itemLbl.font
                                            text:              model.text
                                            visible:           false
                                            selectByMouse:     true
                                            verticalAlignment: Text.AlignVCenter
                                            clip:              true

                                            onAccepted: commitItem()
                                            onActiveFocusChanged: { if (!activeFocus) commitItem() }

                                            function commitItem() {
                                                var t = text.trim()
                                                if (t !== "" && t !== model.text)
                                                    root.editItemText(cardRoot.ci, itemRow.ii, t)
                                                visible = false
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill:            parent
                                            propagateComposedEvents: true
                                            onDoubleClicked: {
                                                itemEdit.text    = model.text
                                                itemEdit.visible = true
                                                itemEdit.forceActiveFocus()
                                                itemEdit.selectAll()
                                            }
                                            onClicked: mouse.accepted = false
                                            onPressed: mouse.accepted = false
                                        }
                                    }

                                    // Delete button
                                    Rectangle {
                                        width:   22
                                        height:  22
                                        radius:  7
                                        color:   delMouse.containsPress ? "#66331111" : "#44221111"
                                        visible: delMouse.containsMouse || rowHover.containsMouse

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
                                            onClicked: root.removeItem(cardRoot.ci, itemRow.ii)
                                        }
                                    }
                                }

                                MouseArea {
                                    id: rowHover
                                    anchors.fill:            parent
                                    hoverEnabled:            true
                                    propagateComposedEvents: true
                                    onClicked: mouse.accepted = false
                                    onPressed: mouse.accepted = false
                                }
                            }
                        }
                    }

                    // ── Add-item input ─────────────────────────────────────────
                    Rectangle {
                        Layout.fillWidth: true
                        height:       36
                        radius:       10
                        color:        "#12ffffff"
                        border.width: 1
                        border.color: addField.activeFocus ? "#30ffffff" : "#0cffffff"

                        Behavior on border.color { ColorAnimation { duration: 150 } }

                        RowLayout {
                            anchors.fill:        parent
                            anchors.leftMargin:  10
                            anchors.rightMargin: 6
                            spacing: 6

                            TextInput {
                                id: addField
                                Layout.fillWidth:   true
                                color:              "white"
                                font.pixelSize:     13
                                activeFocusOnPress: true
                                selectByMouse:      true
                                clip:               true

                                Text {
                                    anchors.fill:          parent
                                    anchors.verticalCenter: parent.verticalCenter
                                    text:    "Add item…"
                                    color:   "#30ffffff"
                                    font:    addField.font
                                    visible: addField.text.length === 0 && !addField.activeFocus
                                }

                                onAccepted: {
                                    root.addItem(cardRoot.ci, text)
                                    text = ""
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked:    addField.forceActiveFocus()
                                    onPressed:  (mouse) => { mouse.accepted = false }
                                    onReleased: (mouse) => { mouse.accepted = false }
                                    propagateComposedEvents: true
                                }
                            }

                            Rectangle {
                                width:  26
                                height: 26
                                radius: 8
                                color:  addBtn.containsPress ? "#38ffffff" : "#1effffff"
                                Behavior on color { ColorAnimation { duration: 100 } }

                                Text {
                                    anchors.centerIn: parent
                                    text:  "+"
                                    color: "white"
                                    font.pixelSize: 22
                                    font.weight:    Font.Light
                                }

                                MouseArea {
                                    id: addBtn
                                    anchors.fill: parent
                                    onClicked: {
                                        root.addItem(cardRoot.ci, addField.text)
                                        addField.text = ""
                                        addField.forceActiveFocus()
                                    }
                                }
                            }
                        }
                    }

                } // ColumnLayout
            }   // delegate Item
        }       // Repeater
    }           // Row
}
