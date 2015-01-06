import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtBluetooth 5.3

Item {
    visible: true

    Item {
        id: mainView
        width: parent.width
        height: parent.height

        JoyStick {
            id:joystick
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            width: 400
            height: 400
            onDirChanged: {
                socket.sendStringData(direction + " " + power)
            }
            onReleased: {
                socket.sendStringData("S 0")
            }
        }

        Scanner {
            id: scanner
            onSelected: {
                socket.connected = false
                socket.setService(remoteService)
                socket.connected = true

                stackView.pop()
            }
        }

        BluetoothSocket {
            id: socket
            connected: true
            onSocketStateChanged: {
                console.log("Socket state: " + socketState)
            }

            onStringDataChanged: {
                        console.log("Received data: " )
                        var data = socket.stringData;
                        data = data.substring(0, data.indexOf('\n'))
                        console.log(data)
            }
        }
        Rectangle {
            color: "transparent"
            height: 100
            width: parent.width
            anchors.bottom: parent.bottom

            Text {
                text: socket.connected ? socket.service.deviceName : ""
                visible: socket.connected
                font.pointSize: 35
                anchors.leftMargin: 10
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: btScanButton.left
            }

            ImgButton {
                id: btScanButton

                imgSrc: "btScanButton.svg"
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 80
                height: 80

                onClicked: {
                    console.debug("BT scannig menu selected.")
                    stackView.push(scanner)
                }
            }


        }
    }

    StackView {
        id: stackView
        initialItem: mainView
        focus: true
        anchors.fill: parent
        Keys.onReleased: {
            if (event.key === Qt.Key_Back && stackView.depth > 1) {
                stackView.pop()
                event.accepted = true
                console.debug("Back key pressed.")
            }
       }
    }
}
