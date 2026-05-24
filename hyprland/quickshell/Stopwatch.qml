import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "clock-widget"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    focusable: true

    anchors {
        left: true
        bottom: true
    }

    margins {
        left: 20
        bottom: 20
    }

    implicitWidth: 260
    implicitHeight: spinnersVisible ? 215 : 170 

    Behavior on implicitHeight {
        NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
    }

    color: "transparent"

    // ── State ───────────────────────────────────────────────────────────────────
    property int  mode:            0     // 0 = Timer, 1 = Stopwatch
    property int  timerSetSeconds: 0
    property int  timerRemaining:  0
    property bool timerRunning:    false
    property bool timerDone:       false
    property int  swElapsed:       0
    property bool swRunning:       false

    readonly property bool spinnersVisible: mode === 0 && !timerRunning && !timerDone && timerRemaining === 0

    // ── Tick ────────────────────────────────────────────────────────────────────
    Timer {
        id: ticker
        interval: 1000
        repeat: true
        running: root.timerRunning || root.swRunning
        onTriggered: {
            if (root.mode === 0 && root.timerRunning) {
                if (root.timerRemaining > 0) {
                    root.timerRemaining--
                } else {
                    root.timerRunning = false
                    root.timerDone    = true
                    doneFlash.running = true
                    Quickshell.execDetached([
                        "notify-send", "-a", "Clock", "-i", "alarm-timer",
                        "Timer done!", "Your timer has finished."
                    ])
                }
            } else if (root.mode === 1 && root.swRunning) {
                root.swElapsed++
            }
        }
    }

    // ── Helpers ─────────────────────────────────────────────────────────────────
    function pad(n)          { return n < 10 ? "0" + n : "" + n }
    function secondsToHMS(s) {
        return pad(Math.floor(s / 3600)) + ":"
             + pad(Math.floor((s % 3600) / 60)) + ":"
             + pad(s % 60)
    }
    function timerSetTotal() { return spinH.value * 3600 + spinM.value * 60 + spinS.value }

    // ── Flash animation ─────────────────────────────────────────────────────────
    SequentialAnimation {
        id: doneFlash
        loops: 4
        PropertyAnimation { target: card; property: "color"; to: "#40a6e3a1"; duration: 250 }
        PropertyAnimation { target: card; property: "color"; to: "#e0080808"; duration: 250 }
    }

    // ── Card ────────────────────────────────────────────────────────────────────
    Rectangle {
        id: card
        anchors.fill: parent
        radius: 24
        color: "#c0080808"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 12

            // ── Full-width mode toggle ──────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height: 28
                radius: 10
                color: "#0fffffff"
                border.width: 1
                border.color: "#0cffffff"

                Rectangle {
                    x: root.mode === 0 ? 2 : parent.width / 2
                    y: 2
                    width: parent.width / 2 - 2
                    height: parent.height - 4
                    radius: 8
                    color: "#1effffff"
                    Behavior on x { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
                }

                Row {
                    anchors.fill: parent

                    Item {
                        width: parent.width / 2
                        height: parent.height
                        Text {
                            anchors.centerIn: parent
                            text: "Timer"
                            color: root.mode === 0 ? "#f0f0f0" : "#30ffffff"
                            font.pixelSize: 13
                            font.weight: Font.Medium
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: { root.swRunning = false; root.timerRunning = false; root.mode = 0 }
                        }
                    }

                    Item {
                        width: parent.width / 2
                        height: parent.height
                        Text {
                            anchors.centerIn: parent
                            text: "Stopwatch"
                            color: root.mode === 1 ? "#f0f0f0" : "#30ffffff"
                            font.pixelSize: 13
                            font.weight: Font.Medium
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: { root.timerRunning = false; root.swRunning = false; root.mode = 1 }
                        }
                    }
                }
            }

            // ── Progress bar ───────────────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height: 3
                radius: 2
                color: "#0fffffff"

                Rectangle {
                    width: root.mode === 0 && root.timerSetSeconds > 0
                        ? parent.width * (1 - root.timerRemaining / root.timerSetSeconds)
                        : 0
                    height: parent.height
                    radius: parent.radius
                    color: root.timerDone ? "#f38ba8" : "#a6e3a1"
                    Behavior on width { NumberAnimation { duration: 1000; easing.type: Easing.Linear } }
                    Behavior on color { ColorAnimation { duration: 300 } }
                }
            }

            // ── Time display ───────────────────────────────────────────────────
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: root.mode === 0
                    ? root.secondsToHMS(root.timerRemaining)
                    : root.secondsToHMS(root.swElapsed)
                visible: !(root.mode === 0 && root.spinnersVisible)
                color: root.timerDone && root.mode === 0 ? "#f38ba8" : "#f0f0f0"
                font.pixelSize: 26
                font.weight: Font.Bold
                font.letterSpacing: -0.5
                font.family: "monospace"
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            // ── Spinners (Timer mode, not running) ─────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height: 48
                radius: 14
                color: "#12ffffff"
                border.width: 1
                border.color: "#0cffffff"
                visible: root.spinnersVisible

                Row {
                    anchors.centerIn: parent
                    spacing: 0

                    SpinnerField { id: spinH; maxValue: 23 }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: ":"
                        color: "#28ffffff"
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        font.family: "monospace"
                    }

                    SpinnerField { id: spinM; maxValue: 59 }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: ":"
                        color: "#28ffffff"
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        font.family: "monospace"
                    }

                    SpinnerField { id: spinS; maxValue: 59 }
                }
            }

            // ── Buttons ────────────────────────────────────────────────────────
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Rectangle {
                    Layout.fillWidth: true
                    height: 34
                    radius: 12
                    color: playMouse.containsPress ? "#38ffffff" : "#1effffff"
                    border.width: 1
                    border.color: "#0cffffff"
                    Behavior on color { ColorAnimation { duration: 100 } }


                    Text {
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: (root.mode === 0 ? root.timerRunning : root.swRunning) ? 0 : 3
                        anchors.verticalCenterOffset: (root.mode === 0 ? root.timerRunning : root.swRunning) ? 0 : -2
                        text: (root.mode === 0 ? root.timerRunning : root.swRunning) ? "⏸" : "▶"
                        color: "#f0f0f0"
                        font.pixelSize: 16
                    }
                    
                    MouseArea {
                        id: playMouse
                        anchors.fill: parent
                        onClicked: {
                            if (root.mode === 0) {
                                if (root.timerDone) return
                                if (!root.timerRunning) {
                                    if (root.timerRemaining === 0) {
                                        var total = root.timerSetTotal()
                                        if (total === 0) return
                                        root.timerSetSeconds = total
                                        root.timerRemaining  = total
                                    }
                                    root.timerRunning = true
                                } else {
                                    root.timerRunning = false
                                }
                            } else {
                                root.swRunning = !root.swRunning
                            }
                        }
                    }
                }

                Rectangle {
                    width: 34
                    height: 34
                    radius: 12
                    color: resetMouse.containsPress ? "#44221111" : "#14ffffff"
                    border.width: 1
                    border.color: "#0cffffff"
                    Behavior on color { ColorAnimation { duration: 100 } }

                    Text {
                        anchors.centerIn: parent
                        text: "↺"
                        color: "#ff8080"
                        font.pixelSize: 18
                    }

                    MouseArea {
                        id: resetMouse
                        anchors.fill: parent
                        onClicked: {
                            if (root.mode === 0) {
                                root.timerRunning    = false
                                root.timerDone       = false
                                root.timerRemaining  = 0
                                root.timerSetSeconds = 0
                                spinH.value = 0
                                spinM.value = 0
                                spinS.value = 0
                            } else {
                                root.swRunning = false
                                root.swElapsed = 0
                            }
                        }
                    }
                }
            }
        }
    }

    // ── SpinnerField component ───────────────────────────────────────────────────
    component SpinnerField: Item {
        id: sf
        property int value:    0
        property int maxValue: 59

        width: 72
        height: 56

        function increment() { value = value >= maxValue ? 0 : value + 1 }
        function decrement() { value = value <= 0 ? maxValue : value - 1 }

        Column {
            anchors.centerIn: parent

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 44
                height: 26
                radius: 6
                color: inputField.activeFocus ? "#1affffff" : "transparent"
                Behavior on color { ColorAnimation { duration: 120 } }

                TextInput {
                    id: inputField
                    anchors.centerIn: parent
                    width: parent.width - 4
                    text: root.pad(sf.value)
                    color: "#f0f0f0"
                    font.pixelSize: 15
                    font.weight: Font.Bold
                    font.family: "monospace"
                    horizontalAlignment: Text.AlignHCenter
                    selectByMouse: true
                    maximumLength: 2
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator { bottom: 0; top: sf.maxValue }

                    onActiveFocusChanged: {
                        if (!activeFocus) {
                            var n = parseInt(text)
                            if (isNaN(n) || n < 0) n = 0
                            if (n > sf.maxValue)   n = sf.maxValue
                            sf.value = n
                            text     = root.pad(sf.value)
                        }
                    }

                    onAccepted: focus = false

                    onTextChanged: {
                        if (activeFocus) {
                            var n = parseInt(text)
                            if (!isNaN(n) && n >= 0 && n <= sf.maxValue)
                                sf.value = n
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked:  inputField.forceActiveFocus()
                        onPressed:  (e) => { e.accepted = false }
                        onReleased: (e) => { e.accepted = false }
                        propagateComposedEvents: true
                    }
                }

                Connections {
                    target: sf
                    function onValueChanged() {
                        if (!inputField.activeFocus)
                            inputField.text = root.pad(sf.value)
                    }
                }
            }
        }

        WheelHandler {
            target: sf
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            onWheel: (event) => {
                if (event.angleDelta.y > 0) sf.increment()
                else                        sf.decrement()
            }
        }
    }
}
