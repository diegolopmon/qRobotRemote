import QtQuick 2.0

Rectangle {
    property alias imgSrc: image.source

    signal clicked

    color: "transparent";

    Image {
        id: image
        anchors.fill: parent;
        sourceSize.width: parent.width;
        sourceSize.height: parent.height;
    }

    MouseArea {
        anchors.fill: parent
        onClicked: parent.clicked();
    }
}

