import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtBluetooth 5.3

ApplicationWindow {
    title: qsTr("qRemote Control")
    width: 800
    height: 800
    visible: true
    color: "white"


    Item {
        id: mainView
        width: parent.width
        height: parent.height

        JoyStick {
            id:joystick
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            width: 600
            height: 600
            onDirChanged: {
                socket.sendStringData(direction + " " + power)
            }
        }

        Scanner {
            id: scanner
            onSelected: {
                socket.setService(remoteService)
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

        ImgButton {
            id: btScanButton

            imgSrc: "btScanButton.svg"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 35
            width: 100
            height: 100

            onClicked: {
                console.debug("BT scannig menu selected.")
                stackView.push(scanner)
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
