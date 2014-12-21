import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2

ApplicationWindow {
    title: qsTr("qRemote Control");
    width: 800;
    height: 600;
    visible: true;
    color: "white";


    JoyStick{
        id:joystick;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.horizontalCenter: parent.horizontalCenter;

        width: 400;
        height: 400;
    }

    ImgButton {
        id: btScanButton;

        imgSrc: "btScanButton.svg";


        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 35;
        width: 100;
        height: 100;

        onClicked: {
            console.debug("BT scannig menu selected.");
        }
    }
}
