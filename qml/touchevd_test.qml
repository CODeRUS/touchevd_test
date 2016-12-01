import QtQuick 2.1
import Sailfish.Silica 1.0

Item {
    id: root

    width: Screen.width
    height: Screen.height

    Connections {
        target: evdevInput
        onTouchPressed: {
            console.log('###', points)
            processPoints(points)
        }
        onTouchMoved: {
            console.log('###', points)
            processPoints(points)
        }
        onTouchReleased: {
            touchPoint1.visible = false
            touchPoint2.visible = false
            touchPoint3.visible = false
            touchPoint4.visible = false
            touchPoint5.visible = false
        }
        onTouchUpdate: {
            //console.log('###', JSON.stringify(points))
            if (points[0].active) {
                touchPoint1.visible = !points[0].released
                if (!!points[0].pointX) {
                    touchPoint1.posx = points[0].pointX
                }
                if (!!points[0].pointY) {
                    touchPoint1.posy = points[0].pointY
                }
                if (!!points[0].pointWidth) {
                    touchPoint1.size = points[0].pointWidth / 10
                }
            }
            if (points[1].active) {
                touchPoint2.visible = !points[1].released
                if (!!points[1].pointX) {
                    touchPoint2.posx = points[1].pointX
                }
                if (!!points[1].pointY) {
                    touchPoint2.posy = points[1].pointY
                }
                if (!!points[1].pointWidth) {
                    touchPoint2.size = points[1].pointWidth / 10
                }
            }
            if (points[2].active) {
                touchPoint3.visible = !points[2].released
                if (!!points[2].pointX) {
                    touchPoint3.posx = points[2].pointX
                }
                if (!!points[2].pointY) {
                    touchPoint3.posy = points[2].pointY
                }
                if (!!points[2].pointWidth) {
                    touchPoint3.size = points[2].pointWidth / 10
                }
            }
            if (points[3].active) {
                touchPoint4.visible = !points[3].released
                if (!!points[3].pointX) {
                    touchPoint4.posx = points[3].pointX
                }
                if (!!points[3].pointY) {
                    touchPoint4.posy = points[3].pointY
                }
                if (!!points[3].pointWidth) {
                    touchPoint4.size = points[3].pointWidth / 10
                }
            }
            if (points[4].active) {
                touchPoint5.visible = !points[4].released
                if (!!points[4].pointX) {
                    touchPoint5.posx = points[4].pointX
                }
                if (!!points[4].pointY) {
                    touchPoint5.posy = points[4].pointY
                }
                if (!!points[4].pointWidth) {
                    touchPoint5.size = points[4].pointWidth / 10
                }
            }
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
        color: "white"
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
        color: "green"
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
        color: "red"
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
        color: "yellow"
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
        color: "blue"
    }
}


