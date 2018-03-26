
********* WWS508c PS#3 *********
*  Spring 2018			      *
*  Author : Joelle Gamble     *
*  Email: jcgamble@           *
*******************************
//credit:

clear all

*Set directory, dta file, etc.
cd "/Users/joellegamble/Desktop/STATA/ps3"
use nhis2000.dta,clear

set more off

********************************************************************************
**                                   P1                                       **
********************************************************************************
//Generate binary variable and summarize//
gen unhealthy=1 if health >3
replace unhealthy=0 if health<=3
tab unhealthy
summarize age
********************************************************************************
**                                   P2                                       **
********************************************************************************
//Mortality and Health Status with age//
gen male=1 if sex==1
replace male=0 if sex==2
drop if mort5==.
probit mort5 c.age##i.male, robust
twoway fpfit mort5 age if male==1, saving(male)
twoway fpfit mort5 age if male==0, saving(female)
gr combine male.gph female.gph, ycommon
probit unhealthy c.age##i.male, robust
twoway fpfit unhealthy age if male==1, saving(male2)
twoway fpfit unhealthy age if male==0, saving(female2)
gr combine male2.gph female2.gph, ycommon

********************************************************************************
**                                   P3                                       **
********************************************************************************
//Socioeconomic status and health//
**income**
gen income=2 if faminc_gt75==1
replace income=1 if faminc_20t75==1
replace income=0 if faminc_gt==0 & faminc_20t75==0 
drop if income==.
oprobit mort5 income, robust
graph bar mort5, over(income)
oprobit unhealthy income, robust
graph bar unhealthy, over(income)
**education**
gen edulevel=1 if edyrs<12
replace edulevel=2 if edyrs==12
replace edulevel=3 if inlist(edyrs,13, 14, 15)
replace edulevel=4 if edyrs==16
replace edulevel=5 if edyrs>16
oprobit mort5 edulevel, robust
graph bar mort5, over(edulevel)
oprobit unhealthy edulevel, robust
graph bar unhealthy, over(edulevel)
**race**
gen race=3 if white==1
replace race=2 if black==1
replace race=1 if hisp==1
replace race=0 if white==0 & black==0 & hisp==0
mprobit mort5 race, robust
graph bar mort5, over(race)
mprobit unhealthy race, robust
graph bar unhealthy, over(race)
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
