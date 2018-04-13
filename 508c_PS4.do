
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
**Coeff -2.53

**poverty controls**
local controlspoverty lninc_0to3 lnbw
xtreg comp_score_5to6 head_start `controlspoverty', i(mom_id) re
**coeff is -.65

**family level controls**
local controlsfamily black hispanic momed dadhome_0to3
xtreg comp_score_5to6 head_start `controlsfamily', i(mom_id) re
**coeff -.77

**all controls**
local controlspoverty lninc_0to3 lnbw
local controlsfamily black hispanic momed dadhome_0to3
xtreg comp_score_5to6 head_start `controlspoverty' `controlsfamily', i(mom_id) re
**-.29 is coeff. It's not statistically significant

//HS is not exogenenous as it is correlated with factors in the error term.
********************************************************************************
**                                   P3                                       **
********************************************************************************
//comment code if it needs some explanations//
xtset mom_id
**no controls**
xtreg comp_score_5to6 head_start, i(mom_id) fe
//coefficient is 7.38. Standard error is higher than random effect.//

//I could not use post-treatment controls because they capture the effect of being in
// Head Start and mediate the impact of HS on the dependent variable.

**poverty controls**
local controlspoverty lninc_0to3 lnbw
xtreg comp_score_5to6 head_start `controlspoverty', i(mom_id) fe
** coeff is 6.9
//controls that had no effect on coefficient are perfectly collinear. Other controls
//reduced size of coefficient.

**family level controls**
local controlsfamily black hispanic momed dadhome_0to3
xtreg comp_score_5to6 head_start `controlsfamily', i(mom_id) fe
**coeff is 6.5


**all controls**
local controlspoverty lninc_0to3 lnbw
local controlsfamily black hispanic momed dadhome_0to3
xtreg comp_score_5to6 head_start `controlspoverty' `controlsfamily', i(mom_id) fe
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
//Certain demographics are more likely to do poorly on scores than others.//
//Let's use race as an example.
local controlsparents momed dadhome_0to3
local controlspoverty lninc_0to3 lnbw
reg comp_score_5to6 black `controlsparents' `controlspoverty', robust
// coeff is -2.78. Thus, being Black represents a disadvantage for students on exams.
//Even controlling for income, parental details and birth weight.

**primary fixed effects model**
xtset mom_id
xtreg comp_score_5to6 head_start, i(mom_id) fe
//head start has a significant positive effect on scores. It seems to partially 
//mitigate the negative impact of race and income. This coeff works for Black children too.
//This is especially important given that a larger than average proportion of Blacks are
//in HS.
correlate comp_score_5to6 comp_score_7to_10
// coefficient is 0.6199. So, the score you get at age 5/6 is correlated with future
// scores. Even though headstarts impact on later scores is smaller, impacting the 5/6 score
// will likely have positivie effects down the road.
correlate comp_score_5to6 comp_score_11to14
//coefficient is 0.5375. So, similar takeaway as above.

//However scores are not everything. The positive & significant relationship
//between H_S and high school graduation is also important.
xtreg hsgrad head_start, i(mom_id) fe
**coeff is 0.148 is the increase in the probability of graduating high school. 
logistic hsgrad head_start, robust
**For clarity I found the log of the odds. The coeff on HS is 1.028. So, HS participants
// have a 2.8 percent higher odds of graduating HS.
//Based on these results, I would recommend expanding the program.
