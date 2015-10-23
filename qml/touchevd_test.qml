import QtQuick 2.1
import Sailfish.Silica 1.0

Item {
    id: root

    width: Screen.width
    height: Screen.height

    Connections {
        target: evdevInput
        onTouchPressed: {
            processPoints(points)
        }
        onTouchMoved: {
            processPoints(points)
        }
        onTouchReleased: {
            touchPoint1.visible = false
            touchPoint2.visible = false
            touchPoint3.visible = false
            touchPoint4.visible = false
            touchPoint5.visible = false
        }
    }

    function processPoints(points) {
        var idx = [0,1,2,3,4]
        for (var i = 0; i < points.length; i++) {
            idx.splice(idx.indexOf(points[i]["i"]), 1)
            if (points[i]["i"] == 0) {
                touchPoint1.posx = points[i]["x"]
                touchPoint1.posy = points[i]["y"]
                touchPoint1.size = points[i]["w"] / 10
                touchPoint1.visible = true
            }
            else if (points[i]["i"] == 1) {
                touchPoint2.posx = points[i]["x"]
                touchPoint2.posy = points[i]["y"]
                touchPoint2.size = points[i]["w"] / 10
                touchPoint2.visible = true
            }
            else if (points[i]["i"] == 2) {
                touchPoint3.posx = points[i]["x"]
                touchPoint3.posy = points[i]["y"]
                touchPoint3.size = points[i]["w"] / 10
                touchPoint3.visible = true
            }
            else if (points[i]["i"] == 3) {
                touchPoint4.posx = points[i]["x"]
                touchPoint4.posy = points[i]["y"]
                touchPoint4.size = points[i]["w"] / 10
                touchPoint4.visible = true
            }
            else if (points[i]["i"] == 4) {
                touchPoint5.posx = points[i]["x"]
                touchPoint5.posy = points[i]["y"]
                touchPoint5.size = points[i]["w"] / 10
                touchPoint5.visible = true
            }
        }
        for (var j = 0; i < idx.length; i++) {
            if (idx[i] == 0) {
                touchPoint1.visible = false
            }
            else if (idx[i] == 1) {
                touchPoint2.visible = false
            }
            else if (idx[i] == 2) {
                touchPoint3.visible = false
            }
            else if (idx[i] == 3) {
                touchPoint4.visible = false
            }
            else if (idx[i] == 4) {
                touchPoint5.visible = false
            }
        }
    }

    GlassItem {
        id: touchPoint1
        property int size: 4
        property int posx: 0
        property int posy: 0
        x: posx - width / 2
        y: posy - width / 2
        width: Theme.iconSizeLauncher * size
        height: Theme.iconSizeLauncher * size
        visible: false
    }

    GlassItem {
        id: touchPoint2
        property int size: 4
        property int posx: 0
        property int posy: 0
        x: posx - width / 2
        y: posy - width / 2
        width: Theme.iconSizeLauncher * size
        height: Theme.iconSizeLauncher * size
        visible: false
    }

    GlassItem {
        id: touchPoint3
        property int size: 4
        property int posx: 0
        property int posy: 0
        x: posx - width / 2
        y: posy - width / 2
        width: Theme.iconSizeLauncher * size
        height: Theme.iconSizeLauncher * size
        visible: false
    }

    GlassItem {
        id: touchPoint4
        property int size: 4
        property int posx: 0
        property int posy: 0
        x: posx - width / 2
        y: posy - width / 2
        width: Theme.iconSizeLauncher * size
        height: Theme.iconSizeLauncher * size
        visible: false
    }

    GlassItem {
        id: touchPoint5
        property int size: 4
        property int posx: 0
        property int posy: 0
        x: posx - width / 2
        y: posy - width / 2
        width: Theme.iconSizeLauncher * size
        height: Theme.iconSizeLauncher * size
        visible: false
    }
}


