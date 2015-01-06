import QtQuick 2.4


Item {

    id:joystick

    signal dirChanged(string direction, int power)
    signal pressed()
    signal released()

    Rectangle {
        id: totalArea

        color: "gray"
        opacity: 0.5

        radius: parent.width/2
        width: parent.width
        height: parent.height
    }

    Rectangle {
        id: stick

        color: "black"

        width: totalArea.width/2
        height: width
        radius: width/2

        x: totalArea.width/2 - radius
        y: totalArea.height/2 - radius
    }

    MouseArea{
        id: mouseArea

        anchors.fill: parent

        onPressed: {
            parent.pressed()
        }

        onReleased: {
            //snap to center
            stick.x = totalArea.width /2 - stick.radius
            stick.y = totalArea.height/2 - stick.radius

            parent.released()
        }

        onPositionChanged: {

            function angle_degrees(x, y) {
                if (x === 0 && y === 0){
                    return null
                }
                var tanx = Math.abs(y) / Math.abs(x)
                var angle = Math.atan(tanx) * 180 / Math.PI


                if (y < 0) {
                    angle = angle * -1
                }

                if (x <= 0 && y <= 0) {
                    angle = 270 + Math.abs(angle)
                } else if (x <= 0 && y >= 0) {
                    angle = 270 - Math.abs(angle)
                } else if (x >= 0 && y >= 0) {
                    angle = 90 + Math.abs(angle)
                } else {
                    angle = 90 - Math.abs(angle)
                }

                return angle
            }

            function direction(angle) {
                if (angle >= 45 && angle < 135) {
                    return "R"
                } else if (angle >= 135 && angle < 225) {
                    return "D"
                } else if (angle >= 225 && angle < 315) {
                    return "L"
                } else {
                    return "U"
                }
            }

            var xDist = mouseX - (totalArea.x + totalArea.radius)
            var yDist = mouseY - (totalArea.y + totalArea.radius)
            var dist = Math.sqrt(Math.pow(xDist,2) + Math.pow(yDist,2))
            var power = 0

            //Calculate angle
            var angle = angle_degrees(xDist,yDist)

            //if distance is less than radius inner circle is inside larger circle
            if(totalArea.radius < dist) {                
                //move the stick
                stick.x = totalArea.radius * Math.cos((angle - 90) * Math.PI / 180) + stick.radius
                stick.y = totalArea.radius * Math.sin((angle - 90) * Math.PI / 180) + stick.radius
                power = 100
            }
            else
            {
                //move the stick
                stick.x = mouseX - stick.radius
                stick.y = mouseY - stick.radius

                //Calculate power (Range 0-100)
                power = dist * 100 / (totalArea.width/2)
            }

            //L R U D for describe direction
            var dir = direction(angle)

            console.debug("Power: ", power, " Direction: ", dir)

            parent.dirChanged(dir, power)
        }
    }
}
