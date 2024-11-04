/**
    Copyright (C) 2024 Samuel Jimenez <therealsamueljimenez@gmail.com>
          Ported the Luna Plasmoid to Plasma 6.

    Copyright 2016 Bill Binder <dxtwjb@gmail.com>

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

import QtQuick 2.7
import QtQuick.Controls as QtControls
import QtQuick.Dialogs as QtDialogs
import QtQuick.Layouts as QtLayouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
    id: generalPage

    property alias cfg_latitude: latitude.value // 0=Equator, +90=North Pole, -90=South Pole
    property alias cfg_phase: phase.value
    property alias cfg_transparentShadow: transparentShadow.checked // boolean
    property alias cfg_showBackground: showBackground.checked // boolean
    property alias cfg_dateFormat: dateFormat.currentIndex // code: 0= 1= 2=...
    property alias cfg_dateFormatString: dateFormatString.text
    property alias cfg_diskColor: diskColor.color
    property int cfg_lunarIndex: 0 // index into imageChoices
    property string cfg_lunarImage: '' // filename (from imageChoices)
    property int cfg_lunarImageTweak: 0 // rotation angle adjustment for the image (from imageChoices)
    property alias cfg_showShadow: showShadow.checked
    property alias cfg_showGrid: showGrid.checked
    property alias cfg_showTycho: showTycho.checked
    property alias cfg_showCopernicus: showCopernicus.checked

    onCfg_lunarIndexChanged: {
        cfg_lunarImage = imageChoices.get(cfg_lunarIndex).filename;
        cfg_lunarImageTweak = imageChoices.get(cfg_lunarIndex).tweak;
        if (cfg_lunarImage == '')
            cfg_transparentShadow = false;

    }

    ImageChoices {
        id: imageChoices
    }

    QtDialogs.ColorDialog {
        id: colorDialog

        title: i18n("Pick a color for the moon")
        visible: false
        selectedColor: diskColor.color
        onAccepted: diskColor.color = selectedColor
    }

    QtLayouts.GridLayout {
        columns: 2
        rowSpacing: 15

        QtControls.Label {
            text: i18n("Preview")
        }

        QtLayouts.RowLayout {
            spacing: 20

            QtControls.Button {
                id: previousButton

                icon.source: "go-previous"
                enabled: cfg_lunarIndex > 0
                onClicked: {
                    cfg_lunarIndex -= 1;
                }
            }

            LunaIcon {
                id: lunaPreview

                width: 200
                height: 200
                latitude: cfg_latitude
                theta: cfg_phase
                showShadow: cfg_showShadow
                transparentShadow: false
                lunarImage: cfg_lunarImage
                lunarImageTweak: cfg_lunarImageTweak
                diskColor: cfg_diskColor
                showGrid: cfg_showGrid
                showTycho: cfg_showTycho
                showCopernicus: cfg_showCopernicus
            }

            QtControls.Button {
                id: nextButton

                icon.source: "go-next"
                enabled: cfg_lunarIndex < imageChoices.count - 1
                onClicked: {
                    cfg_lunarIndex += 1;
                }
            }

            QtLayouts.ColumnLayout {
                spacing: 20

                QtControls.CheckBox {
                    id: showShadow

                    text: i18n("Show shadow")
                }

                QtControls.CheckBox {
                    id: showGrid

                    text: i18n("Show grid")
                }

                QtControls.CheckBox {
                    id: showTycho

                    text: i18n("Tycho")
                }

                QtControls.CheckBox {
                    id: showCopernicus

                    text: i18n("Copernicus")
                }

            }

        }

        QtControls.Label {
            text: i18n("Disk Color")
            visible: cfg_lunarImage === ""
        }

        Rectangle {
            id: diskColor

            width: 50
            height: 50
            color: '#808040'
            border.color: '#000000'
            radius: height / 2
            visible: cfg_lunarImage === ""

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    colorDialog.selectedColor = diskColor.color;
                    colorDialog.visible = true;
                }
            }

        }

        QtControls.Label {
            text: i18n("Latitude")
        }

        QtLayouts.RowLayout {
            spacing: 20

            QtControls.Label {
                id: lbl_latitude

                text: Math.abs(latitude.value) + "º " + (latitude.value < 0 ? "S" : "N")
                QtLayouts.Layout.preferredWidth: 40
                horizontalAlignment: Text.AlignRight
            }

            QtControls.Slider {
                id: latitude

                QtLayouts.Layout.fillWidth: true
                from: -90
                to: 90
                stepSize: 5
            }

        }

        QtControls.Label {
        }

        QtLayouts.RowLayout {
            spacing: 20

            QtControls.Label {
                id: lbl_place

                QtLayouts.Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
            }

        }

        QtControls.Label {
            text: i18n("Phase Preview")
            QtLayouts.Layout.preferredWidth: 85
            horizontalAlignment: Text.AlignRight
        }

        QtLayouts.RowLayout {
            spacing: 20

            QtControls.Label {
                id: lbl_phase

                text: Math.abs(phase.value) + "º "
                QtLayouts.Layout.preferredWidth: 40
                horizontalAlignment: Text.AlignRight
            }

            QtControls.Slider {
                id: phase

                value: lunaPreview.theta
                QtLayouts.Layout.fillWidth: true
                from: 0
                to: 360
                stepSize: 1
            }

        }

        QtControls.Label {
            text: i18n("Date Format")
        }

        QtControls.ComboBox {
            id: dateFormat

            QtLayouts.Layout.fillWidth: true
            textRole: "key"

            model: ListModel {
                dynamicRoles: true
                Component.onCompleted: {
                    append({
                        "key": i18n("Text date"),
                        "value": 0
                    });
                    append({
                        "key": i18n("Short date"),
                        "value": 1
                    });
                    append({
                        "key": i18n("Long date"),
                        "value": 2
                    });
                    append({
                        "key": i18n("ISO date"),
                        "value": 3
                    });
                    append({
                        "key": i18n("Custom"),
                        "value": 4
                    });
                }
            }

        }

        QtControls.Label {
            text: i18n("Date Format String")
            visible: dateFormat.currentIndex == 4
        }

        QtControls.TextField {
            id: dateFormatString

            maximumLength: 24
            visible: dateFormat.currentIndex == 4
        }

        QtControls.Label {
            text: i18n("Background")
        }

        QtControls.CheckBox {
            id: showBackground

            text: i18n("Show background")
        }

        QtControls.Label {
            text: ""
        }

        QtControls.CheckBox {
            id: transparentShadow

            text: i18n("Transparent shadow")
            enabled: cfg_lunarImage != ""
        }

    }

}
