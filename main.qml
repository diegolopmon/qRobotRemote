import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2

ApplicationWindow {
    title: qsTr("qRemote Control")
    width: 800
    height: 600
    visible: true
    color: "black"


    JoyStick{
        id:joystick
        anchors.verticalCenter: parent.verticalCenter;
        anchors.right: parent.right;
        anchors.rightMargin: 35
        width:150;
        height:150;
    }
}
