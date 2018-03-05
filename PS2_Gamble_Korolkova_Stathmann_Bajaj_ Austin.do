
********* WWS508c PS# *********
*  Spring 2018			      *
*  Author : Joelle Gamble     *
*  Email: jcgamble@           *
*******************************
//credit: Joelle Gamble, Chris Austin, Somya Baja, Luke Strathmann, Ana Korolkova//

clear all

*Set directory, dta file, etc.
cd "C:\Users\TerryMoon\Dropbox\Teaching Princeton\wws508c 2018S\ps\ps2"
*cd "/Users/joellegamble/Desktop/STATA"*
use cps08.dta,clear

set more off

********************************************************************************
**                                   P2                                       **
********************************************************************************
//comment code if it needs some explanations//
**Generate log hourly wage variable**
gen hourlywage = ln((incwage)/(wkswork1*uhrswork))
**Generate race dummies**
gen white=1 if race==100
replace white=0 if race!=100
gen black=1 if race==200
replace black=0 if race!=200
gen other=1 if race > 200
replace other=0 if race<=200
gen male=1 if sex==1
replace male=0 if male==.
**education variable for years of schooling**
gen eduyears=educ
replace eduyears=0.5 if educ==2
replace eduyears=2 if educ==10
replace eduyears=5.5 if educ==20
replace eduyears=7.5 if educ==30
replace eduyears=9 if educ==40
replace eduyears=10 if educ==50
replace eduyears=11 if educ==60
replace eduyears=11.5 if educ==71
replace eduyears=12 if educ==73
replace eduyears=13 if educ==81
replace eduyears=14 if educ==91
replace eduyears=14 if educ==92
replace eduyears=16 if educ==111
replace eduyears=18 if educ==123
replace eduyears=19 if educ==124
replace eduyears=20 if educ==125
**experience variable**
gen exper = age - eduyears - 5 
gen exper2 = (exper^2)
replace hourlywage=. if uhrswork < 35
drop if uhrswork < 35
drop if incwage==0
summarize eduyears age exper incwage
tab race
tab sex

********************************************************************************
**                                   P3                                       **
********************************************************************************
//comment//
**code**
reg hourlywage eduyears, robust
summarize hourlywage
summarize eduyears
**hand calculated the correlation using forumula**
correlate hourlywage eduyears
**hand wrote the relationship between squared r and R^2**

********************************************************************************
**                                   P4                                       **
********************************************************************************
//Two different versions of the Mincerian Wage Equation.//
**multivariate regression**
reg hourlywage eduyears exper exper2, robust
**Series of bivariate regressions as application of Frisch-Waugh Theorem**
reg hourlywage exper exper2, robust
predict u_y, residual
reg eduyears exper exper2, robust
predict u_x, residual
reg u_y u_x, robust

********************************************************************************
**                                   P5                                       **
********************************************************************************
//Extended Mincerian Equation with race and sex controls//
local extendedcontrols black other male
reg hourlywage eduyears exper exper2 `extendedcontrols', robust

********************************************************************************
**                                   P6                                       **
********************************************************************************
//Generate the wage-experience profile.//
**code**
egen edubar=mean(eduyears)
egen blackbar=mean(black)
egen otherbar=mean(other)
egen sexbar=mean(male)
reg hourlywage eduyears exper exper2 black other male, robust
gen pointhourlywage = _b[eduyears]*edubar + _b[exper]*exper + _b[exper2]*exper2 + _b[black]*blackbar + _b[other]*otherbar + _b[male]*sexbar + _b[_cons]
sort exper exper2
graph twoway (line pointhourlywage exper)
********************************************************************************
**                                   P7                                       **
********************************************************************************
//Change to NLSY data and regenerate variables//
**code**
use nlsy79.dta, clear
gen hourlywage=ln(laborinc07/hours07)
gen age=(age79+28)
//Age in 2007//
gen exper = age - educ - 5 
gen exper2 = (exper^2)
drop if hours07 < 1750
summarize laborinc07 educ age exper
tab black 
tab hisp
tab male
********************************************************************************
**                                   P8                                       **
********************************************************************************
//Calculate extended Mincerian Wage Equation//
**code**
local extendedcontrols black hisp male
reg hourlywage educ exper exper2 `extendedcontrols', robust

egen edubar=mean(educ)
egen blackbar=mean(black)
egen hispbar=mean(hisp)
egen sexbar=mean(male)
local extendedcontrols black hisp male
reg hourlywage educ exper exper2 `extendedcontrols', robust
gen pointhourlywage = _b[educ]*edubar + _b[exper]*exper + _b[exper2]*exper2 + _b[black]*blackbar + _b[hisp]*hispbar + _b[male]*sexbar + _b[_cons]
sort exper exper2
graph twoway (line pointhourlywage exper)

********************************************************************************
**                                   P10                                      **
********************************************************************************
**code**
local extendedcontrols black hisp male
reg hourlywage educ exper exper2 `extendedcontrols', robust
correlate afqt81 educ
local AFQTcontrols black hisp male afqt81
reg hourlywage educ exper exper2 `AFQTcontrols', robust
local extendedcontrols black hisp male
local childhoodcontrols foreign urban14 mag14 news14 lib14 educ_mom educ_dad numsibs
reg hourlywage educ exper exper2 `extendedcontrols' `childhoodcontrols', robust
local AFQTcontrols black hisp male afqt81
local childhoodcontrols foreign urban14 mag14 news14 lib14 educ_mom educ_dad numsibs
reg hourlywage educ exper exper2 `AFQTcontrols' `childhoodcontrols', robust
