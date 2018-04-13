
********* WWS508c PS4 *********
*  Spring 2018			      *
*  Author : Joelle Gamble     *
*  Email: jcgamble@           *
*******************************
//credit: //

clear all

*Set directory, dta file, etc.
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
drop if learndis==.
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

**poverty controls**
local controlspoverty lninc_0to3 lnbw
xtreg comp_score_5to6 head_start `controlspoverty', i(mom_id) re

**family level controls**
local controlsfamily black hispanic momed dadhome_0to3
xtreg comp_score_5to6 head_start `controlsfamily', i(mom_id) re

**all controls**
local controlspoverty lninc_0to3 lnbw
local controlsfamily black hispanic momed dadhome_0to3
xtreg comp_score_5to6 head_start `controlspoverty' `controlsfamily', i(mom_id) re

********************************************************************************
**                                   P3                                       **
********************************************************************************
//comment code if it needs some explanations//
xtset mom_id
**no controls**
xtreg comp_score_5to6 head_start, i(mom_id) fe
//coefficient is 7.3. Standard error is higher than random effect.//

//I could not use post-treatment controls because they capture the effect of being in
// Head Start and mediate the impact of HS on the dependent variable.

**poverty controls**
local controlspoverty lninc_0to3 lnbw
xtreg comp_score_5to6 head_start `controls poverty', i(mom_id) fe
//controls had no effect on coefficient as these controls are perfectly collinear
//with the entity level fixed effect and fixed effects drops the gamma 
//that accounts for within entity variation like log birth weight

**family level controls**
local controlsfamily black hispanic momed dadhome_0to3
xtreg comp_score_5to6 head_start `controls family', i(mom_id) fe
//same as above//

**all controls**
local controlspoverty lninc_0to3 lnbw
local controlsfamily black hispanic momed dadhome_0to3
xtreg comp_score_5to6 head_start `controls poverty' `controls family', i(mom_id) fe
//same as above//

//Fixed effects seems to capture more of the causal effect of head start on test
//scores. This is because there are items in the error term that are correlated 
//across entities, attenuating the coefficient in the random effect. Head Start
//eligibility is conditional on family level attributes. Thus, we need to use fixed
//effects to account for that variation and get a truer estimate of head start's effects.

********************************************************************************
**                                   P4                                       **
********************************************************************************
//Fixed effects is causal if:
//--there is no OVB that is not captured by fixed effect. So, no variable in
//error that is correlated with head start and test scores and varies over time.\\\\\\\\\\\\\\\\\\\
//--In order to achieve this, there must be no observation level variation that is
//correlated with the error term that is not captured by the demeaning process used
//to estimate the fixed effect.
**Possible OVBs**
**sibdiff**
reg comp_score_5to6 head_start, robust
reg comp_score_5to6 head_start sibdiff, robust
//sibdiff in this regression had a more negative impact on scores than headstart at large.
//but it was not a significant.
xtreg comp_score_5to6 head_start sibdiff, i(mom_id) fe
xtreg comp_score_5to6 sibdiff, i(mom_id) fe
//Sibdiff ommitted due to multicollinearity. It seems like it is not an OV.
**ppvt_3**
xtreg comp_score_5to6 head_start ppvt_3, i(mom_id) fe
//coefficient became negative but not significant.

//Because controlling for other possible OVBs produced statistically insig. results
// or collinearity, one can conclude that the coefficient is causal.

********************************************************************************
**                                   P5                                       **
********************************************************************************
//Headstart effect at different ages.//
//Test scores are over different age periods. So, we should weight them?
//5-6
xtreg comp_score_5to6 head_start, i(mom_id) fe
** coef 7.31

//7-10
xtreg comp_score_7to10 head_start, i(mom_id) fe
**coef 3.78

//11-14
xtreg comp_score_11to14 head_start, i(mom_id) fe
**coef 3.94

********************************************************************************
**                                   P6                                       **
********************************************************************************
//Effects on other outcomes//
**Repeating a grade
xtreg repeat head_start, i(mom_id) fe
**coef -0.06. P-value 0.048....barely significant at the 5 % level.

**Learning disability
xtreg learndis head_start, i(mom_id) fe
**coef -0.029 p-value is 0.027

**Graduating High School
xtreg hsgrad head_start, i(mom_id) fe
** coef 0.147 p-value 0.00

**Some college
xtreg somecoll head_start, i(mom_id) fe
** 0.096 p-value 0.004

**Health
xtreg fphealth head_start, i(mom_id) fe
**coef -0.07 p-value 0.003. Note: Should be interpreted as head start reducing poor health

**Idleness
xtreg idle head_start, i(mom_id) fe
** coef -0.068 p-value 0.016

//Effects on later outcomes are small but mostly significant.
********************************************************************************
**                                   P7                                       **
********************************************************************************
//regressions with race interaction//
xtreg hsgrad i.head_start##i.black, i(mom_id) fe
**Beta 3 is 0.07 indicating that being Black and in head start increases probability of
**finishing High School
xtreg repeat i.head_start##i.black, i(mom_id) fe
**Being Black may reduce the impact HS has on repeating a grade. B1 is -0.7 B3 is 0.008.
**Neither are statistically significant though.
xtreg learndis i.head_start##i.black, i(mom_id) fe
**Not statistically sig.
xtreg somecoll i.head_start##i.black, i(mom_id) fe
** B3 is 0.14. It's significant. But, B1 in this regression is not.
xtreg idle i.head_start##i.black, i(mom_id) fe
**None are statistically significant.
xtreg fphealth i.head_start##i.black, i(mom_id) fe
**B3 is not sig. B1 (-0.106) is sig.

//regressions with sex interaction //
xtreg hsgrad i.head_start##i.male, i(mom_id) fe
**Beta 3 is 0.037 but p value is 0.412. So, it's not statistically significant
xtreg repeat i.head_start##i.male, i(mom_id) fe
**Not significant
xtreg learndis i.head_start##i.male, i(mom_id) fe
**Not significant
xtreg somecoll i.head_start##i.male, i(mom_id) fe
**B1 is significant but not interaction term.
xtreg idle i.head_start##i.male, i(mom_id) fe
**Not significant
xtreg fphealth i.head_start##i.male, i(mom_id) fe
**Not significant

//Only the regressions looking at race and gender on high school graduation was significant
//This could be that the effects on other outcomes are insignificant.
//It could also mean that we'd need more statistical power to estimate the DID.


********************************************************************************
**                                   P8                                       **
********************************************************************************
//comment code if it needs some explanations//
