
********* WWS508c PS4 *********
*  Spring 2018			      *
*  Author : Joelle Gamble     *
*  Email: jcgamble@           *
*******************************
//credit: //

clear all

*Set directory, dta file, etc.
cd "/Users/joellegamble/Downloads/ps4"
use wws508c_deming.dta,clear
ssc install mdesc
ssc install outreg2
set more off

**Clean up data**
mdesc
**Many variables have >1000 missing values**
**Choose to drop missing values in income and mother's years of education**
drop if momed==.
drop if lninc_0to3==.
**Dropping other values represents to large of a portion of the data set.**
********************************************************************************
**                                   P1                                       **
********************************************************************************
//comment code if it needs some explanations//
sum
tab head_start male, row
tab head_start hsgrad, row
tab head_start black, row
tab head_start hispanic, row
tab sibdiff
di 932/4041

********************************************************************************
**                                   P2                                       **
********************************************************************************
//When do we use sibdiff?//
xtset mom_id
xtreg comp_score_5to6 head_start, i(mom_id) re
local controlspoverty lninc_0to3 lnbw
xtreg comp_score_5to6 head_start `controlspoverty', i(mom_id) re
local controlsfamily black hispanic momed dadhome_0to3
xtreg comp_score_5to6 head_start `controlsfamily', i(mom_id) re
local controlspoverty lninc_0to3 lnbw
local controlsfamily black hispanic momed dadhome_0to3
xtreg comp_score_5to6 head_start `controlspoverty' `controlsfamily', i(mom_id) re

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
