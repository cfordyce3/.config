import Quickshell // PanelWindow
import Quickshell.Io // Text
import QtQuick // Process

Variants {
    model: Quickshell.screens;

    delegate: Component {
        PanelWindow {

            required property var modelData

            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30

            Text {
                id: clock
                anchors.centerIn: parent

                Process {
                    id: dateProc

                    command: ["date"]
                    running: true

                    stdout: StdioCollector {
                        onStreamFinished: clock.text = this.text
                    }
                }

                // does this need to be inside the same text block to work?
                Timer {
                    interval: 1000 // ms
                    running: true
                    repeat: true

                    onTriggered: dateProc.running = true
                }
            }
        }
    }
}
