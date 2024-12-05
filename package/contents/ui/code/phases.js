/*

	Copyright (C) 2024 Samuel Jimenez <therealsamueljimenez@gmail.com>

	JavaScript version
	Copyright 2011 Glad Deschrijver <glad.deschrijver@gmail.com>
	with the same license as below.
*/
/*
    This file is part of the kmoon application with explicit permission by the author
    Copyright 1996 Christopher Osburn <chris@speakeasy.org>

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Library General Public
    License as published by the Free Software Foundation; either
    version 3 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Library General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, see <http://www.gnu.org/licenses/>.
*/



.pragma library

// var LUNATION_OFFSET = 953//lunation of LUNATION_EPOCH in Brown Lunation Number
const LUNATION_OFFSET = 0//lunation of LUNATION_EPOCH using Meeus's Lunation Number
// LUNATION_EPOCH
//date of first new moon of 2000 (2000-01-06 18:14:00)
const LUNATION_EPOCH_MS = 947182440000// number of milliseconds between 1970-01-01 00:00:00 and epoch
const LUNATION_EPOCH_JD = 2451550.259722222//epoch in JD

// milliseconds in one day
const MS_PER_DAY = 86400000

// average lunation duration
const LUNATION_CYCLE_DURATION = 29.530588853
const LUNATION_CYCLE_DURATION_MS = 2551442877

/* DatefromJD(int) => Date
 *
 * convert a Julian Date to a JavaScript Date object
 */
function DatefromJD(jd)
{
	// convert to epoch time, then instantiate Date
	return new Date((jd - 2440587.5) * MS_PER_DAY)
}

/* radian(x) : x in Reals -> [-2 PI, 2 PI]
 *
 * convert x to radians from degrees
 */

function radian(x)
{
	return ((x % 360.0) * Math.PI/180)
}

/* getLunation(Date time) => int lunation
 *
 * Given time, returns number of lunation time falls in
 *
 */
function getLunation(time)
{

	// find lunation
	var lunation = Math.floor((time.getTime() - LUNATION_EPOCH_MS) / LUNATION_CYCLE_DURATION_MS) + LUNATION_OFFSET

	//verify result
	var currNew = DatefromJD(moonphasebylunation(lunation, 0))
	var nextNew
	while (currNew > time) {
		// math is off: log result
		console.log("Lunation number", lunation, "too high for", time.toISOString())
		lunation--
		currNew = DatefromJD(moonphasebylunation(lunation, 0))
	}
	nextNew = DatefromJD(moonphasebylunation(lunation + 1, 0))
	while (nextNew < time) {
		// math is off: log result
		console.log("Lunation number", lunation, "too low for", time.toISOString())
		lunation++
		nextNew = DatefromJD(moonphasebylunation(lunation + 1, 0))
	}

	return lunation;
}

/*
** moonphase.c
** 1996/02/11
**
** Copyright 1996, Christopher Osburn, Lunar Outreach Services,
** Non-commercial usage license granted to all.
**
** calculate phase of the moon per Meeus Ch. 47 (ISBN:9780943396613)
**
** Parameters:
**    int lun:  phase parameter.  This is the number of lunations
**              since the New Moon of 2000 January 6.
**
**    int phi:  another phase parameter, selecting the phase of the
**              moon.  0 = New, 1 = First Qtr, 2 = Full, 3 = Last Qtr
**
** Return:  Apparent JD of the needed phase
*/
function moonphasebylunation(lun, phi)
{
	var k = lun - LUNATION_OFFSET + phi / 4.0

	// Julian Ephemeris Day of phase event
	var JDE

	// time parameter, Julian Centuries since LUNATION_EPOCH (47.3)
	var T = k / 1236.85

	// Eccentricity anomaly (45.6)
	var E = 1.0 + T * (-0.002516 + -0.0000074 * T)

	// Sun's mean anomaly (47.4)
	var M = radian(2.5534 + 29.10535669 * k
		+ T * T * (-0.0000218 + -0.00000011 * T))
	// Moon's mean anomaly (47.5)
	var M1 = radian(201.5643 + 385.81693528 * k
		+ T * T * (0.0107438 + T * (0.00001239 + -0.000000058 * T)))
	// Moon's argument of latitude (47.6)
	var F = radian(160.7108 + 390.67050274 * k
		+ T * T * (-0.0016341 * T * (-0.00000227 + 0.000000011 * T)))
	// Moon's longitude of ascending node (47.7)
	var O = radian(124.7746 - 1.56375580 * k
		+ T * T * (0.0020691 + 0.00000215 * T))

	// planetary arguments
	var planetaryArgumentsArray = [
		[0.000325, 0.000165, 0.000164, 0.000126, 0.000110, 0.000062, 0.000060, 0.000056, 0.000047, 0.000042, 0.000040, 0.000037, 0.000035, 0.000023,],
		[299.77 +  0.107408 * k - 0.009173 * T * T, 251.88 +  0.016321 * k, 251.83 + 26.651886 * k, 349.42 + 36.412478 * k, 84.66 + 18.206239 * k, 141.74 + 53.303771 * k, 207.14 +  2.453732 * k, 154.84 +  7.306860 * k, 34.52 + 27.261239 * k, 207.19 +  0.121824 * k, 291.34 +  1.844379 * k, 161.72 + 24.198154 * k, 239.56 + 25.513099 * k, 331.55 +  3.592518 * k,]]
	var planetaryArgumentsCorrection = 0
	for (var i = 0; i < 14; i++) {
		planetaryArgumentsCorrection += planetaryArgumentsArray[0][i] * Math.sin(radian(planetaryArgumentsArray[1][i]))
	}


	// added correction for quarter phases
	var W

	//group First, Last Quarter
	var orbitalCorrectionIndex = 2 - Math.abs(2 - phi)

	var orbitalCorrectionCoeffArray = [
		// New Moon
		[+0.17241, +0.00208, +0.00004, -0.40720, +0.00739, -0.00514, +0.00000, -0.00007, -0.00111, -0.00057, +0.01608, +0.01039, -0.00024, +0.00056, -0.00042, -0.00002, +0.00002, +0.00038, +0.00042, -0.00017, +0.00004, +0.00003, -0.00002, +0.00003, +0.00003, -0.00003,],
		// First Quarter, Last Quarter,
		[+0.17172, +0.00204, +0.00003, -0.62801, +0.00454, -0.01183, +0.00004, -0.00028* E * E, -0.00180, -0.00070, +0.00862, +0.00804, -0.00034, +0.00027, -0.00040, -0.00002, +0.00000, +0.00032, +0.00032, -0.00017, +0.00002, +0.00004, -0.00005, +0.00002, +0.00003, -0.00004,],
		// New Moon
		[+0.17302, +0.00209, +0.00004, -0.40614, +0.00734, -0.00515, +0.00000, -0.00007, -0.00111, -0.00057, +0.01614, +0.01043, -0.00024, +0.00056, -0.00042, -0.00002, +0.00002, +0.00038, +0.00042, -0.00017, +0.00004, +0.00003, -0.00002, +0.00003, +0.00003, -0.00003,]]

	var orbitalCorrectionEccentricityArray = [E, E * E, 1, 1, E, E, 1, 1, 1, 1, 1, 1, E, E, 1, 1, 1, E, E, 1, 1, 1, 1, 1, 1, 1,]

	var orbitalCorrectionAngleArray = [M, 2.0 * M, 3.0 * M, M1, M1 - M, M1 + M, M1 - 2.0 * M, M1 + 2.0 * M, M1 - 2.0 * F, M1 + 2.0 * F, 2.0 * M1, 2.0 * F, 2.0 * M1 - M, 2.0 * M1 + M, 3.0 * M1, 3.0 * M1 + M, 4.0 * M1, M - 2.0 * F, M + 2.0 * F, O, 2.0 * M1 - 2.0 * F, 2.0 * M1 + 2.0 * F, M1 - M - 2.0 * F, M1 - M + 2.0 * F, M1 + M - 2.0 * F, M1 + M + 2.0 * F,]

	var orbitalCorrectionCoeffs =
		orbitalCorrectionCoeffArray[orbitalCorrectionIndex]

	var orbitalApproximation = 0
	for (var i = 0; i < 26; i++) {
		orbitalApproximation +=
			orbitalCorrectionCoeffs[i]
			* orbitalCorrectionEccentricityArray[i]
			* Math.sin(orbitalCorrectionAngleArray[i])
	}


	// this is the first approximation.  all else is for style points! (47.1)
	JDE = LUNATION_EPOCH_JD + (LUNATION_CYCLE_DURATION * k)
	    + T * T * (0.0001337 + T * (-0.000000150 + 0.00000000073 * T))


	JDE = JDE
		+ orbitalApproximation
		+ planetaryArgumentsCorrection

	// extra correction for quarter phases
	if (orbitalCorrectionIndex == 1) {
		W = 0.00306
		- 0.00038 * E * Math.cos(M)
		+ 0.00026 * Math.cos(M1)
		- 0.00002 * Math.cos(M1 - M)
		+ 0.00002 * Math.cos(M1 + M)
		+ 0.00002 * Math.cos(2.0 * F)
		if (phi == 3){
			W = -W
		}
		JDE += W
	}

	return JDE
}






