
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

//Upfront, this data has serious flaws. Major missing values for critical variables
//means there may not be enough statistical power to do much.

//Consider a bar graph or two.
********************************************************************************
**                                   P2                                       **
********************************************************************************
//When do we use sibdiff?//
xtset mom_id
xtreg comp_score_5to6 head_start, i(mom_id) re
outreg2 using Random.doc, replace ctitle (Model 1)
**Coeff -2.53 significant

**poverty controls**
local controlspoverty lninc_0to3 lnbw
xtreg comp_score_5to6 head_start `controlspoverty', i(mom_id) re
outreg2 using Random.doc, append ctitle (Model 2)
**coeff is -.65 not significant

**family level controls**
local controlsfamily black hispanic momed dadhome_0to3 male
xtreg comp_score_5to6 head_start `controlsfamily', i(mom_id) re
outreg2 using Random.doc, append ctitle (Model 3)
**coeff -.61 not sig

**all controls**
local controlspoverty lninc_0to3 lnbw
local controlsfamily black hispanic momed dadhome_0to3 male
xtreg comp_score_5to6 head_start `controlspoverty' `controlsfamily', i(mom_id) re
outreg2 using Random.doc, append ctitle (Model 4)
**-.13 is coeff. It's not statistically significant

//HS is not exogenenous as it is correlated with factors in the error term. 
// These coefficients are not significant when controls are added.
********************************************************************************
**                                   P3                                       **
********************************************************************************
//comment code if it needs some explanations//
xtset mom_id
**no controls**
xtreg comp_score_5to6 head_start, i(mom_id) fe
outreg2 using FE.doc, replace ctitle (Model 1)
//coefficient is 7.38. Standard error is higher than random effect.//

//I could not use post-treatment controls because they capture the effect of being in
// Head Start and mediate the impact of HS on the dependent variable.

**poverty controls**
local controlspoverty lninc_0to3 lnbw
xtreg comp_score_5to6 head_start `controlspoverty', i(mom_id) fe
outreg2 using FE.doc, append ctitle (Model 2)
** coeff is 6.9
//controls that had no effect on coefficient are perfectly collinear. Other controls
//reduced size of coefficient.

**family level controls**
local controlsfamily black hispanic momed dadhome_0to3 male
xtreg comp_score_5to6 head_start `controlsfamily', i(mom_id) fe
outreg2 using FE.doc, append ctitle (Model 3)
**coeff is 6.5


**all controls**
local controlspoverty lninc_0to3 lnbw
local controlsfamily black hispanic momed dadhome_0to3 male
xtreg comp_score_5to6 head_start `controlspoverty' `controlsfamily', i(mom_id) fe
outreg2 using FE.doc, append ctitle (Model 4)
**coeff is 5.7

//Fixed effects seems to capture more of the causal effect of head start on test
//scores. This is because Head Start eligibility is conditional on family level attributes.
//There are items in the error term that are correlated across entities, attenuating 
//the coefficient in the random effect and the fixed effect.  Thus, we need to use fixed
//effects with controls to account for that variation and get a truer estimate of head start's effects.

********************************************************************************
**                                   P4                                       **
********************************************************************************
//Fixed effects is causal if:
//--there is no OVB that is not captured by fixed effect. So, no variable in
//error that is correlated with head start and test scores.\\
//--In order to achieve this, there must be no observation level variation that is
//correlated with the error term that is not captured by the demeaning process used
//to estimate the fixed effect.
**Possible OVBs**

//To test if these is OVB, I use the obs-level sign. variables that I do have. If these are correlated,
//there are probably unobserved variables that also are correlated.

**Regression + F-test for joint significance**
reg head_start lnbw ppvt_3 firstborn male, robust
test lnbw ppvt_3 male firstborn
**All are signficant from zero
//There are observed correlated variables with HS. So, there are probably also unobserved.
//However, I think we are able to control for enough individual level variables that
//the following results are still useful to policy makers.


********************************************************************************
**                                   P5                                       **
********************************************************************************
//Headstart effect at different ages.//
//Test scores are over different age periods. So, we should weight them?
//5-6
local controlspoverty lninc_0to3 lnbw
local controlsfamily dadhome_0to3 
xtreg comp_score_5to6 head_start `controlspoverty' `controlsfamily', i(mom_id) fe
** coef 5.72 
sum comp_score_5to6
//To standardize, divide 5.72/22.3
di 5.72/22.3
** 26 percent STD improvement

//7-10
local controlspoverty lninc_0to3 lnbw
local controlsfamily dadhome_0to3
xtreg comp_score_7to10 head_start `controlspoverty' `controlsfamily', i(mom_id) fe
**coef 3.826 but not sig
sum comp_score_7to10
di 3.82/24.1
** 15 percent STD improvement BUT not significant.

//11-14
local controlspoverty lninc_0to3 lnbw
local controlsfamily dadhome_0to3
xtreg comp_score_11to14 head_start `controlspoverty' `controlsfamily', i(mom_id) fe
**coef 5.79
sum comp_score_11to14
di 5.79/24.8
**23.3 percent STD improvement

********************************************************************************
**                                   P6                                       **
********************************************************************************
//Effects on other outcomes//
**Repeating a grade
local controlspoverty lninc_0to3 lnbw
local controlsfamily dadhome_0to3
xtreg repeat head_start `controlspoverty' `controlsfamily', i(mom_id) fe
outreg2 using later.doc, replace ctitle (Repeat)
**coef -0.0645. P-value 0.194

**Learning disability
local controlspoverty lninc_0to3 lnbw
local controlsfamily dadhome_0to3
xtreg learndis head_start `controlspoverty' `controlsfamily', i(mom_id) fe
outreg2 using later.doc, append ctitle (Disability)
**coef -0.021 p-value is 0.327

**Graduating High School
local controlspoverty lninc_0to3 lnbw
local controlsfamily dadhome_0to3
xtreg hsgrad head_start `controlspoverty' `controlsfamily', i(mom_id) fe
outreg2 using later.doc, append ctitle (HS Grad)
** coef 0.15 p-value 0.007

**Some college
local controlspoverty lninc_0to3 lnbw
local controlsfamily dadhome_0to3
xtreg somecoll head_start `controlspoverty' `controlsfamily', i(mom_id) fe
outreg2 using later.doc, append ctitle (Some College)
** 0.031 p-value 0.558

**Health
local controlspoverty lninc_0to3 lnbw
local controlsfamily dadhome_0to3
xtreg fphealth head_start `controlspoverty' `controlsfamily', i(mom_id) fe
outreg2 using later.doc, append ctitle (Health)
**coef -0.092 p-value 0.018. Note: Should be interpreted as head start reducing poor health

**Idleness
local controlspoverty lninc_0to3 lnbw
local controlsfamily dadhome_0to3
xtreg idle head_start `controlspoverty' `controlsfamily', i(mom_id) fe
outreg2 using later.doc, append ctitle (Idle)
** coef -0.047 p-value 0.295

//Effects on later outcomes are small and many are not significant.
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
//In conclusion, HS doesn't have a different impact by race or gender. But, if HS
// matters and many people of color are in it, one may still care about the program.
//It could also mean that we'd need more statistical power to estimate the DID.


********************************************************************************
**                                   P8                                       **
********************************************************************************
//Certain demographics are more likely to do poorly on scores than others.//
//Let's use race as an example.
local controlsparents momed dadhome_0to3
local controlspoverty lninc_0to3 lnbw
reg comp_score_5to6 black `controlsparents' `controlspoverty', robust
// coeff is -2.78. Thus, being Black represents a disadvantage for students on exams.
//Even controlling for income, parental details and birth weight.

**primary fixed effects model**
xtset mom_id
local controlsparents momed dadhome_0to3
local controlspoverty lninc_0to3 lnbw
xtreg comp_score_5to6 head_start `controlsparents' `controlspoverty', i(mom_id) fe
//Coeff 5.72 head start has a significant positive effect on scores. HS has
// 26 percent STD improvementIt seems to partially 
//mitigate the negative impact of race and income. This coeff works for Black children too.
//This is especially important given that a larger than average proportion of Blacks are
//in HS.
correlate comp_score_5to6 comp_score_7to_10
// coefficient is 0.6199. So, the score you get at age 5/6 is correlated with future
// scores. Even though headstarts impact on later scores is smaller, impacting the 5/6 score
// will likely have positivie effects down the road.
correlate comp_score_5to6 comp_score_11to14
//correlation coefficient is 0.5375. So, similar takeaway as above.

//However scores are not everything. The positive & significant relationship
//between H_S and high school graduation is also important.
local controlsparents momed dadhome_0to3
local controlspoverty lninc_0to3 lnbw
xtreg hsgrad head_start `controlsparents' `controlspoverty', i(mom_id) fe
**coeff is 0.151 is the increase in the probability of graduating high school. 
local controlsparents momed dadhome_0to3
local controlspoverty lninc_0to3 lnbw
logistic hsgrad head_start `controlsparents' `controlspoverty', robust
outreg2 using log.doc, replace ctitle (HS Grad)
**For clarity I found the log of the odds. The coeff on HS is 1.127. So, HS participants
// have a 12.7 percent higher odds of graduating HS.
////Important note: There were many missing values, calling into quetion the data set.
//If further study with a better data set, I would recommend expanding the program.
