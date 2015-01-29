import QtQuick 2.3
import QtBluetooth 5.3
import QtQuick.Dialogs 1.2

Item {
    id: scanner;
    property BluetoothService service

    signal selected(BluetoothService remoteService)

    MessageDialog {
        id: errorDialog
        title: qsTr("Error")
        icon: StandardIcon.Critical
        standardButtons: StandardButton.Ok

    }

    MessageDialog {
        id: connectDialog
        title: qsTr("Connect with...")
        icon: StandardIcon.Question
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        onAccepted: {
            console.debug("Device selected: UUID:",scanner.service.serviceUuid + "Name: " +scanner.service.serviceName)
            scanner.selected(scanner.service)
        }
        onRejected: {
            console.debug("Device no selected")
        }

    }

    BluetoothDiscoveryModel {
        id: btModel
        running: true
        discoveryMode: BluetoothDiscoveryModel.FullServiceDiscovery
        onDiscoveryModeChanged: console.log("Discovery mode: " + discoveryMode)
        onServiceDiscovered: console.log("Found new service " + service.deviceAddress + " " + service.deviceName + " " + service.serviceName)
        onDeviceDiscovered: console.log("New device: " + device)
        onErrorChanged: {
                switch (btModel.error) {
                case BluetoothDiscoveryModel.PoweredOffError:
                    console.log("Error: Bluetooth device not turned on")
                    errorDialog.text = "Bluetooth device not turned on"
                    errorDialog.open()
                    break
                case BluetoothDiscoveryModel.InputOutputError:
                    console.log("Error: Bluetooth I/O Error")
                    errorDialog.text = "Bluetooth I/O Error"
                    errorDialog.open()
                    break
                case BluetoothDiscoveryModel.InvalidBluetoothAdapterError:
                    console.log("Error: Invalid Bluetooth Adapter Error")
                    errorDialog.text = "Invalid Bluetooth Adapter Error"
                    errorDialog.open()
                    break
                case BluetoothDiscoveryModel.NoError:
                    break;
                default:
                    console.log("Error: Unknown Error")
                    errorDialog.text = "Unknown Error"
                    errorDialog.open()
                    break
                }
        }
        uuidFilter: "00001101-0000-1000-8000-00805f9b34fb"
    }

    Rectangle {
        id: busy
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        height: 100

        ImgButton {
            id: searchButton

            imgSrc: btModel.running ? "searchButton.svg" : "doneButton.svg"
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            width: height
        }

        ImgButton {
            id: reloadButton

            imgSrc: "reloadButton.svg"
            anchors.right: searchButton.left
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.top: parent.top
            width: height

            onClicked: {
                console.debug("Reload BT scannig.")
                btModel.discoveryMode = BluetoothDiscoveryModel.FullServiceDiscovery
                btModel.running = true
            }
        }
    }

    ListView {
        id: scanList
        anchors.top: busy.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        model: btModel
        focus: true

        delegate: Item{
            width: parent.width
            height: 100

            ImgButton {
                id: btDevButton

                imgSrc: "btDevButton.svg"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 10
                width: height
            }

            Text {
                text: name
                font.pointSize: 24
                anchors.left: btDevButton.right
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    connectDialog.text = model.name
                    scanner.service = model.service
                    connectDialog.open()
                }
            }
        }
    }
}

