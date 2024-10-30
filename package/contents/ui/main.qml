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

import "../code/lunacalc.js" as LunaCalc
import "../code/phases.js" as Phases
import QtQuick 2.7
import QtQuick.Controls as QtControls
import QtQuick.Layouts as QtLayouts
import org.kde.ksvg as KSvg
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: main

    property int minimumWidth
    property int minimumHeight
    property int maximumWidth
    property int maximumHeight
    property int preferredWidth
    property int preferredHeight
    property var currentPhase
    property bool showBackground: plasmoid.configuration.showBackground
    property bool transparentShadow: plasmoid.configuration.transparentShadow
    property int latitude: plasmoid.configuration.latitude
    property int dateFormat: plasmoid.configuration.dateFormat
    property string dateFormatString: plasmoid.configuration.dateFormatString
    property int lunarIndex: plasmoid.configuration.lunarIndex
    property string diskColor: plasmoid.configuration.diskColor
    property string lunarImage: ''
    property int lunarImageTweak: 0

    Plasmoid.backgroundHints: showBackground ? "DefaultBackground" : "NoBackground"
    preferredRepresentation: compactRepresentation
    Plasmoid.icon: ""
    toolTipMainText: currentPhase.text
    toolTipSubText: currentPhase.subText

    compactRepresentation: Item {
        id: compact

        property int latitude: main.latitude
        property bool showBackground: main.showBackground
        property int lunarIndex: main.lunarIndex

        function updateDetails() {
            // set the correct image for the moon
            currentPhase = LunaCalc.getCurrentPhase(true);
            lunaIcon.phaseNumber = 13; //currentPhase.number;
            lunaIcon.theta = currentPhase.terminator;
            lunaIcon.latitude = latitude;
            main.lunarImage = imageChoices.get(main.lunarIndex).filename;
            main.lunarImageTweak = imageChoices.get(main.lunarIndex).tweak;
        }

        Component.onCompleted: updateDetails()
        onLatitudeChanged: updateDetails()
        onLunarIndexChanged: updateDetails()

        ImageChoices {
            id: imageChoices
        }

        Timer {
            id: hourlyTimer

            interval: 60 * 60 * 1000 // 60 minutes
            repeat: true
            running: true
            onTriggered: updateDetails()
        }

        LunaIcon {
            id: lunaIcon

            latitude: main.latitude
            lunarImage: main.lunarImage
            lunarImageTweak: main.lunarImageTweak
            transparentShadow: main.transparentShadow
            diskColor: main.diskColor
            anchors.fill: parent

            MouseArea {
                anchors.fill: parent
                onClicked: plasmoid.expanded = !plasmoid.expanded
            }

        }

    }

    fullRepresentation: Item {
        id: full

        property int dateFormat: main.dateFormat
        property string dateFormatString: main.dateFormatString

        QtLayouts.Layout.preferredWidth: lunaWidget.QtLayouts.Layout.minimumWidth
        QtLayouts.Layout.preferredHeight: lunaWidget.QtLayouts.Layout.minimumHeight
        onDateFormatChanged: {
            lunaWidget.dateFormat = dateFormat;
        }
        onDateFormatStringChanged: {
            lunaWidget.dateFormatString = dateFormatString;
        }

        LunaWidget {
            id: lunaWidget

            dateFormat: dateFormat
            dateFormatString: dateFormatString
        }

    }

}
