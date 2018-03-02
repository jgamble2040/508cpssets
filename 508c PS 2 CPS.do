
********* WWS508c PS# *********
*  Spring 2018			      *
*  Author : Joelle Gamble     *
*  Email: jcgamble@           *
*******************************
//credit: Joelle Gamble, Chris Austin, Somya Baja, Luke Strathmann, Ana Ko//

clear all
use cps08.dta,clear

set more off

********************************************************************************
**                                   P2                                       **
********************************************************************************
//comment code if it needs some explanations//
**Generate log hourly wage variable**
gen hourlywage = (incwage)/(wkswork1*uhrswork)
//some of the incwage inputs were "0" despite there being a number of hours worked//
**Generate race dummies**
gen white=1 if race==100
replace white=0 if race!=100
gen black=1 if race==200
replace black=0 if race!=200
gen other=1 if race > 200
replace other=0 if race<=200
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
********************************************************************************
**                                   P3                                       **
********************************************************************************
//comment//
**code**
reg hourlywage eduyears, robust
//Estimated return is 2.25 percent increase in wages for a year increase in education.//
summarize hourlywage
summarize eduyears
**hand calculated the correlation using forumula**
correlate hourlywage eduyears
**hand wrote the relationship between squared r and R^2**

********************************************************************************
**                                   P4                                       **
********************************************************************************
//comment//
**code**

********************************************************************************
**                                   P5                                       **
********************************************************************************
//comment//
**code**

********************************************************************************
**                                   P6                                       **
********************************************************************************
//comment//
**code**

********************************************************************************
**                                   P7                                       **
********************************************************************************
//comment//
**code**

********************************************************************************
**                                   P8                                       **
********************************************************************************
//comment//
**code**

********************************************************************************
**                                   P9                                       **
********************************************************************************
//comment//
**code**

********************************************************************************
**                                   P10                                      **
********************************************************************************
//comment//
**code**

********************************************************************************
**                                   P11                                      **
********************************************************************************
//comment//
**code**
