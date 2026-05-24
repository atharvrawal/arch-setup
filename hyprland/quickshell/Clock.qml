import QtQuick 2.15
import Quickshell
import Quickshell.Wayland

ShellRoot {
    id: root

    PanelWindow {
	id: win

        // ── Change these to resize the whole widget ──────────────
        width:  300
        height: 300
	// ─────────────────────────────────────────────────────────
	
	anchors{
	     bottom: true
        }
	
	margins {
		bottom: 30
	}

        color: "transparent"
        WlrLayershell.layer: WlrLayer.Background
	WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
	WlrLayershell.exclusiveZone: 0
        mask: Region { }

        Canvas {
            id: clock
            anchors.fill: parent
            renderTarget: Canvas.FramebufferObject
            enabled: false

            // ── Tune these to your taste ─────────────────────────

            // Size: hands scale relative to the canvas size (0.0–1.0)
            readonly property real hourLength:    0.19   // how far tip reaches from center
            readonly property real hourTail:      0.044  // counterweight below center
            readonly property real hourThickness: 0.016  // line width

            readonly property real minuteLength:    0.31
            readonly property real minuteTail:      0.056
            readonly property real minuteThickness: 0.012

            // Color & opacity — rgba(r, g, b, alpha)
            readonly property string hourColor:   "rgba(100, 100, 100, 0.4)"
            readonly property string minuteColor: "rgba(100, 100, 100, 0.4)"

            // Cap style: "square", "round", or "butt"
            readonly property string capStyle: "square"

            // ─────────────────────────────────────────────────────

            property real hourAngle: 0
            property real minuteAngle: 0

            function updateHands() {
                var now = new Date()
                var h  = now.getHours() % 12
                var m  = now.getMinutes()
                var s  = now.getSeconds()
                var ms = now.getMilliseconds()
                clock.minuteAngle = ((m * 60 + s + ms / 1000.0) / 3600.0) * 2 * Math.PI
                clock.hourAngle   = ((h * 60 + m + s / 60.0)   / 720.0)  * 2 * Math.PI
                clock.requestPaint()
            }

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)

                var cx   = width  / 2
                var cy   = height / 2
                var unit = Math.min(width, height)   // base unit for all scaling

                ctx.lineCap  = clock.capStyle
                ctx.lineJoin = "miter"

                // Hour hand
                ctx.save()
                ctx.translate(cx, cy)
                ctx.rotate(clock.hourAngle)
                ctx.beginPath()
                ctx.moveTo(0,  unit * clock.hourTail)
                ctx.lineTo(0, -unit * clock.hourLength)
                ctx.strokeStyle = clock.hourColor
                ctx.lineWidth   = unit * clock.hourThickness
                ctx.stroke()
                ctx.restore()

                // Minute hand
                ctx.save()
                ctx.translate(cx, cy)
                ctx.rotate(clock.minuteAngle)
                ctx.beginPath()
                ctx.moveTo(0,  unit * clock.minuteTail)
                ctx.lineTo(0, -unit * clock.minuteLength)
                ctx.strokeStyle = clock.minuteColor
                ctx.lineWidth   = unit * clock.minuteThickness
                ctx.stroke()
                ctx.restore()
            }

            Component.onCompleted: updateHands()

            Timer {
                interval: 33
                running: true
                repeat: true
                onTriggered: clock.updateHands()
            }
        }
    }
}
