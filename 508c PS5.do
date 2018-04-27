
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
//Relationship between conscription and different types of crime//
local controls birthyr indigenous naturalized
reg crimerate conscripted `controls', robust
//coefficient on conscripted is 0.002 and significant.

local controls birthyr indigenous naturalized
reg property conscripted `controls', robust
//coefficient on conscripted is 0.00084 and significant.

local controls birthyr indigenous naturalized
reg murder conscripted `controls', robust
//coefficient on conscripted is -0.00004 and NOT significant.

local controls birthyr indigenous naturalized
reg drug conscripted `controls', robust
//coefficient on conscripted is -0.000046 and NOT significant.

local controls birthyr indigenous naturalized
reg sexual conscripted `controls', robust
//coefficient on conscripted is 0.00016 and only significant at 10 percent.

local controls birthyr indigenous naturalized
reg threat conscripted `controls', robust
//coefficient on conscripted is 0.00027 and NOT significant.

local controls birthyr indigenous naturalized
reg arms conscripted `controls', robust
//coefficient on conscripted is 0.00013 and NOT significant.

local controls birthyr indigenous naturalized
reg whitecollar conscripted `controls', robust
//coefficient on conscripted is 0.00064 and significant.

//The very small coefficients and lack of significance reflect the potential
//for OVB and possible reverse causality. The fact that crime type was only
//only available in 2000 could mean that there is reverse causality
//The crime means that there could be a bunch of other factors between the time
//of conscription and a conviction in 2000-20005 that impact crime other than
//conscription.
********************************************************************************
**                                   P3                                       **
********************************************************************************
//Recode Draft Assignment//
generate eligible=1 if birthyr==1958 & draftnumber>=175
replace eligible=0 if birthyr==1958 & draftnumber<175
replace eligible=1 if birthyr==1959 & draftnumber>=320
replace eligible=0 if birthyr==1959 & draftnumber<320
replace eligible=1 if birthyr==1960 & draftnumber>=341
replace eligible=0 if birthyr==1960 & draftnumber<341
replace eligible=1 if birthyr==1961 & draftnumber>=350
replace eligible=0 if birthyr==1961 & draftnumber<350
replace eligible=1 if birthyr==1962 & draftnumber>=320
replace eligible=0 if birthyr==1962 & draftnumber<320
********************************************************************************
**                                   P4                                       **
********************************************************************************
//For overal crime rate: first stage effect//
reg conscripted eligible, robust

local controls birthyr indigenous naturalized
reg conscripted eligible `controls', robust
reg conscripted eligible birthyr, robust
//Use birthyear fixed effect as there was a downward bias in X due to OVB.
//No need to use identity controls as they were not significant.

********************************************************************************
**                                   P5                                       **
********************************************************************************
//comment code if it needs some explanations//

reg conscripted eligible birthyr, robust
predict double zhat

reg crimerate zhat birthyr, robust
//Coefficient is 0.0027 and significant.

reg property zhat birthyr, robust
//Coefficient is 0.0008 and p-value .016.

reg murder zhat birthyr, robust
//Coefficient is -0.000055 and NOT significant.

reg drug zhat birthyr, robust
//Coefficient is -0.000068 and NOT significant.

reg sexual zhat birthyr, robust
//Coefficient is 0.00014 and NOT significant.

reg threat zhat birthyr, robust
//Coefficient is 0.00022 and NOTsignificant.


reg arms zhat birthyr, robust
//Coefficient is 0.00012 and NOT significant.


reg whitecollar zhat birthyr, robust
//Coefficient is 0.0006 and significant.

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
