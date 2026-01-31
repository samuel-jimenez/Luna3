/**
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

import QtQuick 2.1 as QtQuick

/*lunarIndex
Defines the list of images of the moon.
  key - was a string name to be be shown in a ComboBox - not used
  value - not used because elsewhere just uses the index into this model
  filename - relative to the data directory
  tweak - degrees to rotate the image, which is helpful if you can't draw
*/
QtQuick.ListModel {
    id: imageChoices

    // key: "Light"
    QtQuick.ListElement {
        value: 0
        filename: "fife-moon.svg"
        tweak: 4
    }

    // key: "Dark"
    QtQuick.ListElement {
        value: 1
        filename: "full-moon-dark.svg"
        tweak: -18
    }

    // key: "Original"
    QtQuick.ListElement {
        value: 2
        filename: "luna-gskbyte13.svg"
        tweak: 0
    }

    // key: "Detailed"
    QtQuick.ListElement {
        value: 3
        filename: "the-moon-dan-gerhards-01.svg"
        tweak: 0
    }

    // key: "Custom Color"
    QtQuick.ListElement {
        value: 4
        filename: ""
        tweak: 0
    }

}
