# Luna 3
-----------

Description
-----------

This plasmoid displays the current phase of the moon and shows the dates
of the important moon phases in the same month (last new moon, first quarter,
full moon, third quarter and next new moon). You can navigate to previous or
future moon phases by clicking the arrow keys. Clicking the middle button
returns to the current dates.


This plasmoid is a port to Plasma 6 of Luna II (https://store.kde.org/p/1165459/),  
which is a port to Plasma 5 of Luna QML 1.4 (https://store.kde.org/p/1002036/)

Installation
------------

#### A. Command line, installs to `~/local/share/plasma/plasmoids`   
   This works the same way as loading a new widget from "Add Widgets..."  
 
Install:

    $ plasmapkg2 -i Luna3-<ver>.plasmoid

Update:

	$ plasmapkg2 -u Luna3-<ver>.plasmoid

Uninstall:

	$ plasmapkg2 -r org.kde.userbase.plasma.Luna3



#### B. Command line, installs to `/usr/local/share/plasma/plasmoids`

Install:

	# plasmapkg2 -g -i Luna3-<ver>.plasmoid

Update:
	
	# plasmapkg2 -g -u Luna3-<ver>.plasmoid

Uninstall:

	# plasmapkg2 -g -r org.kde.userbase.plasma.Luna3


#### C. CMake, installs to `/usr/local/share/plasma/plasmoids`

  0. Clone/download source from [Github](https://github.com/samuel-jimenez/Luna3) or
[opencode.net](https://www.opencode.net/samuel-jimenez/Luna3).
  1. The top directory contains the CMakeLists.txt file
  2. Run: ``` # make install```


Custom Date Formats
-------------------
For example: `dddd, dd-MM-yyyy`  => Saturday, 10-Dec-2016

    d    the day as number without a leading zero (1 to 31)
    dd   the day as number with a leading zero (01 to 31)
    ddd  the abbreviated localized day name (e.g. 'Mon' to 'Sun'). Uses QDate::shortDayName().
    dddd the long localized day name (e.g. 'Monday' to 'Qt::Sunday'). Uses QDate::longDayName().
    M    the month as number without a leading zero (1-12)
    MM   the month as number with a leading zero (01-12)
    MMM  the abbreviated localized month name (e.g. 'Jan' to 'Dec'). Uses QDate::shortMonthName().
    MMMM the long localized month name (e.g. 'January' to 'December'). Uses QDate::longMonthName().
    yy   the year as two digit number (00-99)
    yyyy the year as four digit number

In addition the following expressions can be used to specify the time:

    h   the hour without a leading zero (0 to 23 or 1 to 12 if AM/PM display)
    hh  the hour with a leading zero (00 to 23 or 01 to 12 if AM/PM display)
    m   the minute without a leading zero (0 to 59)
    mm  the minute with a leading zero (00 to 59)
    s   the second without a leading zero (0 to 59)
    ss  the second with a leading zero (00 to 59)
    z   the milliseconds without leading zeroes (0 to 999)
    zzz the milliseconds with leading zeroes (000 to 999)
    AP  use AM/PM display. AP will be replaced by either "AM" or "PM".
    ap  use am/pm display. ap will be replaced by either "am" or "pm".

License
-------

Copyright 2019 Ismael <ismailof@github.com>  
Copyright 2016, 2017 Bill Binder <dxtwjb@gmail.com>  
Copyright (C) 2011, 2012, 2013 Glad Deschrijver <glad.deschrijver@gmail.com>  
Copyright (C) 2024 Samuel Jimenez <therealsamueljimenez@gmail.com>

The JavaScript code is based on the C++ code of the original Luna plasmoid
in the KDE Plasma Workspace. This C++ code is licensed as follows:  

	Copyright 1996 Christopher Osburn <chris@speakeasy.org>  
	Copyright 1998,2000  Stephan Kulow <coolo@kde.org>  
	Copyright 2008 by Davide Bettio <davide.bettio@kdemail.net>  
	licensed under the GNU GPL version 2 or later.

Several fixes in the changes for 2.1 series were based on the Gealach plasmoid by
koffeinfriedhof <koffeinfriedhof@gmail.com>, in particular the resizing of the
LunaWidget when different date formats are selected.

The luna image, `gskbyte13.svg`, was extracted from the luna SVG file created by:

	  Copyright 2009 Jose Alcala (project manager), Dan Gerhards (moon artwork),
	                 Jeremy M. Todaro (shadows and layout)
	  (available at http://kde-look.org/content/show.php/luna.svgz+(full+SVG+image)?content=106013
	  original available at http://www.public-domain-photos.com/free-cliparts/science/astronomy/the_moon_dan_gerhards_01-5094.htm)
	  released in the public domain

The luna images, `fife-moon.svg` & `full-moon-dark.svg`, were generated from photos
by Bill Binder. Released 2017 under Creative Commons Attribution-ShareAlike 3.0
(http://creativecommons.org/licenses/by-sa/3.0/)

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.


