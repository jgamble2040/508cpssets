
********* WWS508c PS4 *********
*  Spring 2018			      *
*  Author : Joelle Gamble     *
*  Email: jcgamble@           *
*******************************
//credit: //

clear all

*Set directory, dta file, etc.
use probation_ps6.dta,clear
ssc install mdesc
ssc install outreg2
set more off

********************************************************************************
**                                   P1                                       **
********************************************************************************
//Plot histogram allowing for discontinuity at zero.//
hist dist_from_cut,start(-1.6) w(0.10) xline(0) saving(histogram,replace)
//Student bunch above the cutoff. Bunching may be explained by teachers knowing
//that students need to be above a certain GPA to be considered successful
//and inflate grades. Only the really poor students don't meet the cutoff.
//There is also a spike right after the cut off meaning that some teachers
//may bump students near the cutoff to right above it to avoid sending them
//to summer school.
//These results look like a threat to the design as there may be manipulation
//of the threshold assignment.
********************************************************************************
**                                   P2                                       **
********************************************************************************
//Test jump of predetermined variables//
// HS grades

//gender

//age at entry

//Born in North America

//English as native lanaguage

********************************************************************************
**                                   P3                                       **
********************************************************************************
//comment code if it needs some explanations//

********************************************************************************
**                                   P4                                       **
********************************************************************************
//comment code if it needs some explanations//

********************************************************************************
**                                   P5                                       **
********************************************************************************
//comment code if it needs some explanations//

********************************************************************************
**                                   P6                                       **
********************************************************************************
//comment code if it needs some explanations//

********************************************************************************
**                                   P7                                       **
********************************************************************************
//comment code if it needs some explanations//
