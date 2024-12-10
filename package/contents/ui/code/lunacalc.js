/**

	Copyright 1998, 2000  Stephan Kulow <coolo@kde.org>
	Copyright 2008 by Davide Bettio <davide.bettio@kdemail.net>
	Copyright (C) 2009, 2011, 2012, 2013 Glad Deschrijver <glad.deschrijver@gmail.com>
	Copyright 2017 Bill Binder <dxtwjb@gmail.com>
	Copyright (C) 2024 Samuel Jimenez <therealsamueljimenez@gmail.com>

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


.import "phases.js" as Phases

var lunation = 0;


function getPhasesByLunation(lunation)
{
	var phases = new Array();
	phases[0] = Phases.DatefromJD(Phases.moonphasebylunation(lunation, 0)) // new moon
	phases[1] = Phases.DatefromJD(Phases.moonphasebylunation(lunation, 1)) // first quarter
	phases[2] = Phases.DatefromJD(Phases.moonphasebylunation(lunation, 2)) // full moon
	phases[3] = Phases.DatefromJD(Phases.moonphasebylunation(lunation, 3)) // last quarter
	phases[4] = Phases.DatefromJD(Phases.moonphasebylunation(lunation + 1, 0)) // next new moon
	return phases;
}

function getTodayPhases()
{
	var today = new Date()
	lunation = Phases.getLunation(today)
	return getPhasesByLunation(lunation)
}

function getPreviousPhases()
{
	lunation--
	return getPhasesByLunation(lunation)
}

function getNextPhases()
{
	lunation++
	return getPhasesByLunation(lunation)
}

function reloadPhases()
{
	return getPhasesByLunation(lunation)
}



function getCurrentPhase()
{

	var today = new Date().getTime() // this function assumes that today is between phases[0] (last new moon) and phases[4] (next new moon)
	var phases = getTodayPhases()
	var terminator
	var lunaCalc = {
		terminator:terminator,
		text: "",
		subText: ""}

	// Estimate where the terminator is - base this on knowing where it
	// is at each quarter, and interpolating. Cowboy maths.
	// Determines how far into the current quarter we are, and uses
	// the result to work out where the terminator is. This allows for
	// the quarters being different sizes, rather than assuming they are
	// each one quarter of the cycle time.

	var qnum = 0
	while (today > phases[qnum+1] && qnum < 3) {
		qnum++
	}
	var quarterTime = phases[qnum+1].getTime() - phases[qnum].getTime()
	var sinceQuarter = today - phases[qnum].getTime()
	terminator = Math.floor(((sinceQuarter / quarterTime) + qnum) * 90)

	// Keep this in the range [0,360):
	lunaCalc.terminator = terminator % 360

	// set time for all phases to 00:00:00 (midnight local time) in order to obtain the correct phase for today
	for (var i = 0; i < 5; i++) {
		phases[i].setHours(0)
		phases[i].setMinutes(0)
		phases[i].setSeconds(0)
	}



	var daysFromLastNew = Math.floor((today - phases[0].getTime()) / Phases.MS_PER_DAY)
	var daysFromFirstQuarter = Math.floor((today - phases[1].getTime()) / Phases.MS_PER_DAY)
	var daysFromFullMoon = Math.floor((today - phases[2].getTime()) / Phases.MS_PER_DAY)
	var daysFromThirdQuarter = Math.floor((today - phases[3].getTime()) / Phases.MS_PER_DAY)
	var daysToNextNew = -Math.floor((today - phases[4].getTime()) / Phases.MS_PER_DAY)
	if (daysFromLastNew == 0 || daysToNextNew == 0){
		lunaCalc.text=i18n("New Moon")
	} else if (daysFromFirstQuarter == 0){
		lunaCalc.text=i18n("First Quarter")
	} else if (daysFromFullMoon == 0){
		lunaCalc.text=i18n("Full Moon")
	} else if (daysFromThirdQuarter == 0){
		lunaCalc.text=i18n("Last Quarter")
	} else if (daysFromFirstQuarter < 0) {
		// if today <= first quarter, calculate day since last new moon
		lunaCalc.text=i18n("Waxing Crescent")
		if (daysFromLastNew == 1){
			lunaCalc.subText=i18n("Yesterday was New Moon")
		} else{// assume that today >= last new moon
			lunaCalc.subText=i18n("%1 days since New Moon", daysFromLastNew)
		}
	} else if (daysFromThirdQuarter > 0) {
		// if today >= third quarter, calculate day until next new moon
		lunaCalc.text=i18n("Waning Crescent")
		if (daysToNextNew == 1){
			lunaCalc.subText=i18n("Tomorrow is New Moon")}
		else {// assume that today <= next new moon
			lunaCalc.subText=i18n("%1 days to New Moon", daysToNextNew)}
	} else if (daysFromFullMoon < 0) {
		// if today >= full moon, calculate day until full moon
		lunaCalc.text=i18n("Waxing Gibbous")
		if (daysFromFullMoon == -1){
			lunaCalc.subText=i18n("Tomorrow is Full Moon")
		} else {
			lunaCalc.subText=i18n("%1 days to Full Moon", -daysFromFullMoon)
		}
	} else if (daysFromFullMoon > 0){
		// in all other cases, calculate day since full moon
		lunaCalc.text=i18n("Waning Gibbous")
		if (daysFromFullMoon == 1){
			lunaCalc.subText=i18n("Yesterday was Full Moon")
		} else{
			lunaCalc.subText=i18n("%1 days since Full Moon", daysFromFullMoon)
		}
	} else {
		// this should never happen:
		console.log("We cannot count :-(", today)
	}
	return lunaCalc
}
