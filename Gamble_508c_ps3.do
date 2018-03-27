
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
//LPM + PROBIT + LOGIT//
**generate age categorical*
gen youth=1 if age<40
replace youth=2 if inlist(age,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,59,60)
replace youth=3 if age>60
*mortality*
reg mort5 age income edyrs race, robust //for LPM continuous seems better//
reg mort5 youth income edulevel race, robust //higher SEs and coeff//
probit mort5 age income edyrs race, robust
mfx
scatter mort5 age || fpfit mort5 age ||, by(income, edyrs, race)
probit mort5 youth income edulevel race, robust //same 
logit mort5 age income edyrs race, robust
mfx
scatter mort5 age || fpfit mort5 age
logit mort5 youth income edulevel race, robust //same
logistic mort5 age income edyrs race, robust
mfx
*Choose logistic. Gives odds ratio*
*health*
reg unhealthy age income edyrs race, robust //for LPM continuous seems better//
reg unhealthy youth income edulevel race, robust //higher SEs and coeff//
probit unhealthy age income edyrs race, robust
mfx
probit unhealthy youth income edulevel race, robust //same 
logit unhealthy age income edyrs race, robust
mfx
logit unhealthy youth income edulevel race, robust //same
logistic unhealthy age income edyrs race, robust
mfx
**maybe I should look at the scatterplots to determine best fit?*
*Marginal effects are similar across the models. Here logit and probit become nearly the same*
********************************************************************************
**                                   P5                                       **
********************************************************************************
//high income Arfrican Americans v. low income Whites//
gen highincome=1 if income==2
replace highincome=0 if income<2
gen lowincome=1 if income==0
replace lowincome=0 if income>0
logistic mort5 age income edyrs black
mfx
margins, dydx(black) at (income==2)
**coeff is .008**
logistic mort5 age income edyrs white 
mfx
margins, dydx(white) at (income==0)
**coeff is -0.006**
**No because factors other than income may be confounding the impact of income**
**health for African Americans---neighborhood, wealth, etc**
********************************************************************************
**                                   P6                                       **
********************************************************************************
//Are mfx on family income causal//
logistic mort5 age income edyrs black
mfx
margins, dydx(income)
**coeff is -0.021**
logistic mort5 age income edyrs white 
mfx
margins, dydx(income)
**ceoff is -0.21**
**Since marginal effects are similar to the Beta in OLS, we can assign causality**

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
