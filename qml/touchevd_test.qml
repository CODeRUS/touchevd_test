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
            console.log('###', index, JSON.stringify(parameters))
            switch (index) {
                case 0:
                    touchPoint1.visible = !parameters['release']
                    break
                case 1:
                    touchPoint2.visible = !parameters['release']
                    break
                case 2:
                    touchPoint3.visible = !parameters['release']
                    break
                case 3:
                    touchPoint4.visible = !parameters['release']
                    break
                case 4:
                    touchPoint5.visible = !parameters['release']
                    break
            }
            if (parameters.hasOwnProperty('pointX')) {
                switch (index) {
                    case 0:
                        touchPoint1.posx = parameters['pointX']
                        break
                    case 1:
                        touchPoint2.posx = parameters['pointX']
                        break
                    case 2:
                        touchPoint3.posx = parameters['pointX']
                        break
                    case 3:
                        touchPoint4.posx = parameters['pointX']
                        break
                    case 4:
                        touchPoint5.posx = parameters['pointX']
                        break
                }
            }
            if (parameters.hasOwnProperty('pointY')) {
                switch (index) {
                    case 0:
                        touchPoint1.posy = parameters['pointY']
                        break
                    case 1:
                        touchPoint2.posy = parameters['pointY']
                        break
                    case 2:
                        touchPoint3.posy = parameters['pointY']
                        break
                    case 3:
                        touchPoint4.posy = parameters['pointY']
                        break
                    case 4:
                        touchPoint5.posy = parameters['pointY']
                        break
                }
            }
            if (parameters.hasOwnProperty('pointWidth')) {
                switch (index) {
                    case 0:
                        touchPoint1.size = parameters['pointWidth'] / 10
                        break
                    case 1:
                        touchPoint2.size = parameters['pointWidth'] / 10
                        break
                    case 2:
                        touchPoint3.size = parameters['pointWidth'] / 10
                        break
                    case 3:
                        touchPoint4.size = parameters['pointWidth'] / 10
                        break
                    case 4:
                        touchPoint5.size = parameters['pointWidth'] / 10
                        break
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
        color: "green"
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


