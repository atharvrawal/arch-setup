import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    // ── Config ────────────────────────────────────────────────────────────────
    readonly property var configFolders: [
        {
            name: "hypr",
            icon: "󰣇",
            files: [
                { name: "hyprland.conf",  path: "/home/atharv/.config/hypr/hyprland.conf"  },
                { name: "hyprpaper.conf", path: "/home/atharv/.config/hypr/hyprpaper.conf" },
                { name: "hyprlock.conf",  path: "/home/atharv/.config/hypr/hyprlock.conf"  }
            ]
        },
        {
            name: "waybar",
            icon: "󰈸",
            files: [
                { name: "config.jsonc",      path: "/home/atharv/.config/waybar/config.jsonc"      },
                { name: "style.css",         path: "/home/atharv/.config/waybar/style.css"         },
                { name: "pomodoro.sh",       path: "/home/atharv/.config/waybar/pomodoro.sh"       },
                { name: "toggle-waybar.sh",  path: "/home/atharv/.config/waybar/toggle-waybar.sh"  },
                { name: "ws_icons_event.sh", path: "/home/atharv/.config/waybar/ws_icons_event.sh" }
            ]
        },
        {
            name: "quickshell",
            icon: "",
            files: [
                { name: "shell.qml",  path: "/home/atharv/.config/quickshell/shell.qml"  },
                { name: "Clock.qml",  path: "/home/atharv/.config/quickshell/Clock.qml"  },
                { name: "Dots.qml",   path: "/home/atharv/.config/quickshell/Dots.qml"   },
                { name: "Notes.qml",  path: "/home/atharv/.config/quickshell/Notes.qml"  },
		{ name: "Todo.qml",   path: "/home/atharv/.config/quickshell/Todo.qml"   },
		{ name: "Time.qml",   path: "/home/atharv/.config/quickshell/Time.qml"   }, 
		{ name: "Tracker.qml",   path: "/home/atharv/.config/quickshell/Tracker.qml"   } 
            ]
        },
        {
            name: "fish",
            icon: "󰈺",
            files: [
                { name: "config.fish", path: "/home/atharv/.config/fish/config.fish" }
            ]
        }
    ]
    // ─────────────────────────────────────────────────────────────────────────

    WlrLayershell.layer:         WlrLayer.Background
    WlrLayershell.namespace:     "dots-widget"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    anchors { bottom: true }
    margins { bottom: 20 }

    // Width: one pill per folder + gaps. Height grows when a folder opens.
    readonly property int folderPillW: 90
    readonly property int hgap:        6
    readonly property int padH:        8

    implicitWidth:  configFolders.length * folderPillW
                    + (configFolders.length - 1) * hgap
                    + padH * 2

    // collapsed = just the pill row; expanded = pill row + file list below
    implicitHeight: {
        var base = 38 + padH * 2
        if (root.openFolder < 0) return base
        var f = configFolders[root.openFolder]
        return base + f.files.length * 32 + (f.files.length - 1) * 2 + 10
    }

    Behavior on implicitHeight {
        NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
    }

    color: "transparent"

    // ── Process launcher ──────────────────────────────────────────────────────
    Process {
        id: launcher
        property string pendingPath: ""
        command: ["foot", "-e", "nvim", pendingPath]
    }

    function openFile(path) {
        launcher.pendingPath = path
        launcher.startDetached()
    }

    // ── Accordion state ───────────────────────────────────────────────────────
    property int openFolder: -1

    Item {
        // collapse accordion when window loses focus
        focus: true
        onActiveFocusChanged: if (!activeFocus) root.openFolder = -1
    }



    // ── Card background ───────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        radius:       16
        color:        "#16ffffff"
        border.width: 1
        border.color: "#18ffffff"
    }

    // ── Folder pills (horizontal row) ─────────────────────────────────────────
    Row {
        id: pillRow
        anchors {
            top:              parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin:        root.padH
        }
        spacing: root.hgap

        Repeater {
            model: root.configFolders

            delegate: Rectangle {
                id: pill
                width:  root.folderPillW
                height: 38
                radius: 10

                property bool expanded: root.openFolder === index
                property bool active:   expanded

                color: pillMouse.containsPress ? "#30ffffff"
                     : (active || pillMouse.containsMouse) ? "#22ffffff"
                     : "transparent"

                Behavior on color { ColorAnimation { duration: 120 } }

                // bottom underline when active
                Rectangle {
                    anchors.bottom:           parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:  pill.active ? 24 : 0
                    height: 2
                    radius: 1
                    color:  "#60ffffff"
                    Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                }

                Row {
                    anchors.centerIn: parent
                    spacing: 5

                    Text {
                        text:           modelData.icon
                        color:          "#c8c8c8"
                        font.pixelSize: 13
                        font.family:    "Symbols Nerd Font"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text:           modelData.name
                        color:          pill.active ? "#ffffff" : "#c0c0c0"
                        font.pixelSize: 12
                        font.weight:    Font.Medium
                        font.family:    "JetBrainsMono Nerd Font"
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: 120 } }
                    }
                }

                MouseArea {
                    id: pillMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:    root.openFolder = pill.expanded ? -1 : index
                }
            }
        }
    }

    // ── File list (drops below the pill row) ──────────────────────────────────
    Item {
        anchors {
            top:   pillRow.bottom
            left:  parent.left
            right: parent.right
            topMargin: 4
        }
        height: root.implicitHeight - pillRow.height - root.padH * 2 - 4
        clip:   true

        Column {
            id: fileCol
            anchors {
                top:              parent.top
                horizontalCenter: parent.horizontalCenter
            }
            width:   pillRow.width
            spacing: 2

            Repeater {
                model: root.openFolder >= 0 ? root.configFolders[root.openFolder].files : []

                delegate: Rectangle {
                    width:  fileCol.width
                    height: 32
                    radius: 8
                    color:  fileMouse.containsPress ? "#28ffffff"
                          : fileMouse.containsMouse ? "#18ffffff"
                          : "transparent"

                    Behavior on color { ColorAnimation { duration: 100 } }

                    Row {
                        anchors.centerIn: parent
                        spacing: 7

                        Rectangle {
                            width:  5
                            height: 5
                            radius: 3
                            anchors.verticalCenter: parent.verticalCenter
                            color: {
                                var n = modelData.name
                                if (n.endsWith(".conf"))  return "#89b4fa"
                                if (n.endsWith(".jsonc")) return "#a6e3a1"
                                if (n.endsWith(".css"))   return "#cba6f7"
                                if (n.endsWith(".sh"))    return "#f9e2af"
                                if (n.endsWith(".fish"))  return "#89dceb"
                                if (n.endsWith(".lua"))   return "#f38ba8"
                                return "#585b70"
                            }
                        }

                        Text {
                            text:           modelData.name
                            color:          "#b0b0b0"
                            font.pixelSize: 12
                            font.family:    "JetBrainsMono Nerd Font"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: fileMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked:    root.openFile(modelData.path)
                    }
                }
            }
        }
    }
}
