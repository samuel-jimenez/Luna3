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
import QtQuick.Shapes
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
    property bool showGrid: false
    property bool showTycho: false
    property bool showCopernicus: false
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

        Shape {
            id: lunaCanvas

            opacity: (lunarImage === '') ? 1 : 0
            width: lunaBackground.width
            height: lunaBackground.height
            visible: true
            anchors.centerIn: parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                fillColor: diskColor
                strokeWidth: -1 //no stroke

                PathAngleArc {
                    centerX: radius
                    centerY: radius
                    radiusY: radius
                    radiusX: radius
                    startAngle: 0
                    sweepAngle: 360
                }
            }
        }

        Canvas {
            id: markers

            property bool showShadow: lunaIcon.showShadow
            property bool showGrid: lunaIcon.showGrid
            property bool showTycho: lunaIcon.showTycho
            property bool showCopernicus: lunaIcon.showCopernicus

            function radians(deg) {
                return deg / 180 * Math.PI;
            }

            function marker(radius, latitude, longitude) {
                var dy = radius * Math.sin(radians(latitude));
                var dx = radius * Math.cos(radians(latitude)) * Math.sin(radians(longitude));
                // console.log("dx: " + dx.toString());
                // console.log("dy: " + dy.toString());
                context.beginPath();
                context.strokeStyle = "#FF0000";
                context.arc(dx, -dy, 5, 0, 2 * Math.PI);
                context.moveTo(dx - 5, -dy - 5);
                context.lineTo(dx + 5, -dy + 5);
                context.moveTo(dx - 5, -dy + 5);
                context.lineTo(dx + 5, -dy - 5);
                context.stroke();
            }

            function grid(radius) {
                context.beginPath();
                context.strokeStyle = "#FF4040";
                context.moveTo(0, -radius);
                context.lineTo(0, radius);
                context.moveTo(-radius, 0);
                context.lineTo(radius, 0);
                context.stroke();
                context.beginPath();
                context.strokeStyle = "#40FF40";
                for (var ll = 10; ll < 65; ll += 10) {
                    var dy = radius * Math.sin(radians(ll));
                    context.moveTo(-radius, dy);
                    context.lineTo(radius, dy);
                    context.moveTo(-radius, -dy);
                    context.lineTo(radius, -dy);
                }
                context.stroke();
            }

            width: lunaBackground.width
            height: lunaBackground.height
            visible: true
            anchors.centerIn: parent
            contextType: "2d"
            onShowGridChanged: requestPaint()
            onShowTychoChanged: requestPaint()
            onShowCopernicusChanged: requestPaint()
            onShowShadowChanged: requestPaint()
            onPaint: {
                context.reset();
                if (!showShadow) {
                    var cosTheta = Math.cos(theta / 180 * Math.PI);
                    var counterclockwisep = (theta < 180);
                    context.globalAlpha = 0.9;
                    context.translate(radius, radius);
                    // Calibration markers
                    if (showGrid)
                        grid(radius);

                    // Tycho
                    if (showTycho)
                        marker(radius, -43, -11.5);

                    // Copernicus
                    if (showCopernicus)
                        marker(radius, 9.6, -20);
                }
            }
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
            onWidthChanged: requestPaint()
            onPaint: {
                context.reset();
                if (showShadow) {
                    var cosTheta = Math.cos(theta / 180 * Math.PI);
                    var counterclockwisep = (theta > 180);
                    context.globalAlpha = 1;
                    context.translate(radius, radius);
                    context.beginPath();
                    context.fillStyle = '#ffffff';
                    context.strokeStyle = '#ffffff';
                    context.arc(0, 0, radius, -0.5 * Math.PI, 0.5 * Math.PI, counterclockwisep);
                    if ((theta % 180) != 90) {
                        context.scale(cosTheta, 1);
                        context.arc(0, 0, radius, 0.5 * Math.PI, -0.5 * Math.PI, !counterclockwisep);
                    }
                    context.closePath();
                    context.fill();
                }
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

        sourceItem: Shape {
            opacity: 1
            antialiasing: true
            width: lunaBackground.width
            height: lunaBackground.height
            visible: true
            anchors.centerIn: parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                fillColor: '#000000'
                strokeWidth: -1 //no stroke

                PathAngleArc {
                    centerX: radius
                    centerY: radius
                    radiusY: radius - 1
                    radiusX: radius - 1
                    startAngle: 0
                    sweepAngle: 360
                }
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
