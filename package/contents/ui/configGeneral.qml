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

import QtPositioning
import QtQuick
import QtQuick.Controls as QtControls
import QtQuick.Dialogs as QtDialogs
import QtQuick.Layouts as QtLayouts
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: generalPage

    property int cfg_currentPhase: 0 // Degrees: 0= new moon, 90= first quarter, 180= full moon, 270= third quarter
    property alias previewPhase: phase.value
    property alias cfg_latitudeAuto: latitudeAuto.checked // 0=Equator, +90=North Pole, -90=South Pole
    property alias cfg_latitude: latitude.value // 0=Equator, +90=North Pole, -90=South Pole
    property alias cfg_transparentShadow: transparentShadow.checked // boolean
    property alias cfg_shadowOpacity: shadowOpacity.value // real in [0,1]
    property alias cfg_showBackground: showBackground.checked // boolean
    property alias cfg_diskColor: lunaPreview.diskColor
    property int cfg_lunarIndex: 0 // index into imageChoices
    property string cfg_lunarImage: '' // filename (from imageChoices)
    property int cfg_lunarImageTweak: 0 // rotation angle adjustment for the image (from imageChoices)
    property alias cfg_showShadow: showShadow.checked
    property bool cfg_showGrid: false
    property bool cfg_showTycho: false
    property bool cfg_showCopernicus: false

    onCfg_lunarIndexChanged: {
        cfg_lunarImage = imageChoices.get(cfg_lunarIndex).filename;
        cfg_lunarImageTweak = imageChoices.get(cfg_lunarIndex).tweak;
    }
    Component.onCompleted: {
        previewPhase = cfg_currentPhase;
    }

    PositionSource {
        id: geoSource

        readonly property bool locating: geoSource.active && geoSource.sourceError == PositionSource.NoError && !(geoSource.position.latitudeValid)

        updateInterval: 3600 * 1000
        active: cfg_latitudeAuto
        onPositionChanged: {
            cfg_latitude = Math.round(geoSource.position.coordinate.latitude);
        }
    }

    ImageChoices {
        id: imageChoices
    }

    QtDialogs.ColorDialog {
        id: colorDialog

        options: QtDialogs.ColorDialog.ShowAlphaChannel
        title: i18n("Moon color")
        visible: false
        selectedColor: cfg_diskColor
        onAccepted: cfg_diskColor = selectedColor
    }

    QtLayouts.ColumnLayout {
        spacing: 10
        QtLayouts.Layout.fillWidth: true

        QtControls.Frame {
            QtLayouts.Layout.fillWidth: true
            QtLayouts.Layout.alignment: Qt.AlignTop

            QtLayouts.GridLayout {
                anchors.fill: parent
                columns: 2
                rowSpacing: 0
                QtLayouts.Layout.alignment: Qt.AlignTop

                QtControls.Label {
                    text: i18n("Preview")
                    font.bold: true
                    QtLayouts.Layout.alignment: Qt.AlignTop
                }

                QtLayouts.RowLayout {
                    spacing: 20
                    QtLayouts.Layout.alignment: Qt.AlignLeft

                    QtControls.Button {
                        id: previousButton

                        QtControls.ToolTip.delay: 250
                        QtControls.ToolTip.timeout: 5000
                        QtControls.ToolTip.visible: hovered
                        QtControls.ToolTip.text: i18n("Previous Image")
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
                        theta: previewPhase
                        showShadow: cfg_showShadow
                        transparentShadow: cfg_transparentShadow
                        shadowOpacity: cfg_shadowOpacity
                        lunarImage: cfg_lunarImage
                        lunarImageTweak: cfg_lunarImageTweak
                        diskColor: cfg_diskColor
                        showGrid: cfg_showGrid
                        showTycho: cfg_showTycho
                        showCopernicus: cfg_showCopernicus

                        MouseArea {
                            anchors.fill: parent
                            visible: cfg_lunarImage === ""
                            QtControls.ToolTip.delay: 250
                            QtControls.ToolTip.timeout: 5000
                            QtControls.ToolTip.visible: visible && hovered
                            QtControls.ToolTip.text: i18n("Pick Color")
                            onClicked: {
                                colorDialog.visible = true;
                            }
                        }
                    }

                    QtControls.Button {
                        id: nextButton

                        QtControls.ToolTip.delay: 250
                        QtControls.ToolTip.timeout: 5000
                        QtControls.ToolTip.visible: hovered
                        QtControls.ToolTip.text: i18n("Next Image")
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

                        text: phase.value + "º "
                        QtLayouts.Layout.preferredWidth: 40
                        horizontalAlignment: Text.AlignRight
                    }

                    QtControls.Slider {
                        id: phase

                        QtLayouts.Layout.fillWidth: true
                        from: 0
                        to: 360
                        stepSize: 1
                    }
                }
            }
        }

        QtLayouts.GridLayout {
            columns: 2
            rowSpacing: 10
            QtLayouts.Layout.fillWidth: true

            QtLayouts.ColumnLayout {
                spacing: 10

                QtControls.Label {
                    text: i18n("Shadow")
                    horizontalAlignment: Text.AlignCenter
                    font.bold: true
                }

                QtControls.Label {
                    text: i18n("Opacity")
                    QtLayouts.Layout.preferredWidth: 85
                    horizontalAlignment: Text.AlignRight
                }
            }

            QtLayouts.ColumnLayout {
                spacing: 5
                QtLayouts.Layout.fillWidth: true

                QtControls.CheckBox {
                    id: transparentShadow

                    text: i18n("Transparent")
                }

                QtLayouts.RowLayout {
                    spacing: 20

                    QtControls.Label {
                        id: lbl_shadowOpacity

                        text: Math.round(shadowOpacity.value * 100) + "%"
                        QtLayouts.Layout.preferredWidth: 40
                        horizontalAlignment: Text.AlignRight
                    }

                    QtControls.Slider {
                        id: shadowOpacity

                        QtLayouts.Layout.fillWidth: true
                        from: 0
                        to: 1
                        stepSize: 0.05
                    }
                }
            }

            QtControls.Label {
                text: i18n("Latitude")
                font.bold: true
                lineHeight: 3
            }

            QtLayouts.ColumnLayout {
                spacing: 5

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
                        onMoved: cfg_latitudeAuto = false
                    }
                }

                QtControls.CheckBox {
                    id: latitudeAuto

                    text: i18n("Use current latitude")
                }
            }

            QtControls.Label {
                text: i18n("Background")
                font.bold: true
            }

            QtControls.CheckBox {
                id: showBackground

                text: i18n("Show background")
            }
        }
    }
}
