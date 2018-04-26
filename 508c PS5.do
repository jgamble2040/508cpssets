
********* WWS508c PS4 *********
*  Spring 2018			      *
*  Author : Joelle Gamble     *
*  Email: jcgamble@           *
*******************************
//credit: //

clear all

*Set directory, dta file, etc.
use wws508c_crime_ps5.dta,clear
ssc install mdesc
ssc install outreg2
set more off

********************************************************************************
**                                   P1                                       **
********************************************************************************
//comment code if it needs some explanations//
sum birthyr crimerate conscripted property murder drug
tabstat birthyr crimerate conscripted property murder drug
foreach var of varlist crimerate conscripted {
	graph bar `var', over(birthyr)
}
graph bar arms, over(birthyr)
//Crime rates raee rougly the same for all birth years. The year 1958 has a 
//slightly higher conscription rate.
********************************************************************************
**                                   P2                                       **
********************************************************************************
//comment code if it needs some explanations//

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

********************************************************************************
**                                   P8                                       **
********************************************************************************
//comment code if it needs some explanations//

********************************************************************************
**                                   P9                                       **
********************************************************************************
//comment code if it needs some explanations//

********************************************************************************
**                                   P10                                      **
********************************************************************************
//comment code if it needs some explanations//
