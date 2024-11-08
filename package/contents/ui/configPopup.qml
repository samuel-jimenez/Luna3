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
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as Plasma5Support

KCM.SimpleKCM {
    id: generalPage

    property alias cfg_dateFormat: dateFormat.currentIndex // code: 0= 1= 2=...
    property alias cfg_dateFormatString: dateFormatString.text

    QtLayouts.ColumnLayout {
        spacing: 5
        QtLayouts.Layout.fillWidth: true

        QtLayouts.GridLayout {
            columns: 2
            rowSpacing: 15
            QtLayouts.Layout.fillWidth: true

            QtControls.Label {
                text: i18n("Date Format")
                font.bold: true
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

        }

    }

}
