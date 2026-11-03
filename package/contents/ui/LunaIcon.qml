/**

    Copyright (C) 2024 Samuel Jimenez <therealsamueljimenez@gmail.com>
          Ported the Luna Plasmoid to Plasma 6.

    Copyright 2016,2017 Bill Binder <dxtwjb@gmail.com>
    Copyright (C) 2011, 2012, 2013 Glad Deschrijver <glad.deschrijver@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, see <http://www.gnu.org/licenses/>.

*/

import QtQuick
import org.kde.ksvg as KSvg
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

Item {
    id: lunaIcon

    property int latitude: 90 //Degrees: 0=Equator, 90=North Pole, -90=South Pole
    property bool showShadow: true
    property bool transparentShadow: true
    property real shadowOpacity: 0.9
    property string lunarImage: ''
    property color diskColor: '#ffffff'
    property int lunarImageTweak: 0
    property int theta: 45 // Degrees: 0= new moon, 90= first quarter, 180= full moon, 270= third quarter
    property alias radius: lunaBackground.radius

    Item {
        id: lunaBackground

        property int radius: Math.floor(height / 2)

        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height)
        height: Math.min(parent.width, parent.height)
        visible: false
    }

    Item {
        id: lunaTexture

        anchors.centerIn: parent
        width: lunaBackground.width
        height: lunaBackground.height
        visible: false
        layer.enabled: true
        layer.smooth: true

        KSvg.SvgItem {
            id: lunaSvgItem

            imagePath: lunarImage === '' ? '' : Qt.resolvedUrl("data/" + lunarImage)
            visible: true
            anchors.centerIn: parent
            width: lunaBackground.width
            height: lunaBackground.height
            // Rotation to compensate the moon's image basic position to a north pole view
            transformOrigin: Item.Center
            rotation: -lunarImageTweak
        }

        // A round Rectangle rather than a Shape: Shape's CurveRenderer leaves its
        // node empty after the scene graph is rebuilt (e.g. GPU device loss on VT switch).
        Rectangle {
            id: lunaCanvas

            opacity: (lunarImage === '') ? 1 : 0
            width: 2 * lunaIcon.radius
            height: 2 * lunaIcon.radius
            radius: lunaIcon.radius
            visible: true
            anchors.centerIn: parent
            color: diskColor
            antialiasing: true
        }
    }

    ShaderEffectSource {
        id: lunaLight

        anchors.centerIn: parent
        width: lunaBackground.width
        height: lunaBackground.height
        visible: false
        antialiasing: false

        sourceItem: Canvas {
            property int theta: lunaIcon.theta
            property bool showShadow: lunaIcon.showShadow

            antialiasing: true
            width: lunaBackground.width
            height: lunaBackground.height
            visible: true
            anchors.centerIn: parent
            contextType: "2d"
            onThetaChanged: requestPaint()
            onShowShadowChanged: requestPaint()
            onAvailableChanged: if (available) requestPaint()
            onWidthChanged: requestPaint()
            onPaint: {
                // The context is dropped when the scene graph is invalidated (e.g. GPU
                // device loss on VT switch); getContext() recreates it, `context` doesn't.
                var ctx = getContext("2d");
                if (!ctx)
                    return;
                ctx.reset();
                var cosTheta = Math.cos(theta / 180 * Math.PI);
                var counterclockwisep = (theta > 180);
                if (!showShadow) {
                    cosTheta = -1;
                    counterclockwisep = false;
                }
                ctx.globalAlpha = 1;
                ctx.translate(radius, radius);
                ctx.beginPath();
                ctx.fillStyle = '#ffffff';
                ctx.strokeStyle = '#ffffff';
                ctx.arc(0, 0, radius, -0.5 * Math.PI, 0.5 * Math.PI, counterclockwisep);
                if ((theta % 180) != 90) {
                    ctx.scale(cosTheta, 1);
                    ctx.arc(0, 0, radius, 0.5 * Math.PI, -0.5 * Math.PI, !counterclockwisep);
                }
                ctx.closePath();
                ctx.fill();
            }
        }
    }

    ShaderEffectSource {
        id: lunaMask

        //mask out a nice antialiased circle shape
        anchors.centerIn: parent
        width: lunaBackground.width
        height: lunaBackground.height
        visible: false
        antialiasing: true

        // Not a Shape, for the same reason as lunaCanvas above.
        sourceItem: Item {
            width: lunaBackground.width
            height: lunaBackground.height

            Rectangle {
                opacity: 1
                antialiasing: true
                width: 2 * (lunaIcon.radius - 1)
                height: 2 * (lunaIcon.radius - 1)
                radius: lunaIcon.radius - 1
                visible: true
                anchors.centerIn: parent
                color: '#000000'
            }
        }
    }

    ShaderEffect {
        property variant source: lunaTexture
        property variant light: lunaLight
        property variant mask: lunaMask
        property int transparent: transparentShadow
        property real shadow_Opacity: shadowOpacity

        opacity: 1
        rotation: latitude - 90
        visible: true
        antialiasing: true
        anchors.fill: lunaBackground
        fragmentShader: "shadow.qsb"
    }
}
