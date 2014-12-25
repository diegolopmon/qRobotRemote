import QtQuick 2.0
import QtBluetooth 5.3

Item {
    id: scanner;
    property BluetoothService currentService

    BluetoothDiscoveryModel {
        id: btModel
        running: true
        discoveryMode: BluetoothDiscoveryModel.DeviceDiscovery
        onDiscoveryModeChanged: console.log("Discovery mode: " + discoveryMode)
        onServiceDiscovered: console.log("Found new service " + service.deviceAddress + " " + service.deviceName + " " + service.serviceName);
        onDeviceDiscovered: console.log("New device: " + device)
        onErrorChanged: {
                switch (btModel.error) {
                case BluetoothDiscoveryModel.PoweredOffError:
                    console.log("Error: Bluetooth device not turned on"); break;
                case BluetoothDiscoveryModel.InputOutputError:
                    console.log("Error: Bluetooth I/O Error"); break;
                case BluetoothDiscoveryModel.InvalidBluetoothAdapterError:
                    console.log("Error: Invalid Bluetooth Adapter Error"); break;
                case BluetoothDiscoveryModel.NoError:
                    break;
                default:
                    console.log("Error: Unknown Error"); break;
                }
        }
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
                btModel.discoveryMode = BluetoothDiscoveryModel.DeviceDiscovery
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
        }
    }
}

