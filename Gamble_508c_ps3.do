
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
ssc install mdesc
set more off
ssc install outreg2

********************************************************************************
**                                   P1                                       **
********************************************************************************
//Generate binary variable and summarize//
gen unhealthy=1 if health >3
replace unhealthy=0 if health<=3
tab unhealthy
summarize
tab mort5 sex
tab health race
********************************************************************************
**                                   P2                                       **
********************************************************************************
//Mortality and Health Status with age//
gen male=1 if sex==1
replace male=0 if sex==2
drop if mort5==.
graph twoway lfit mort5 age if male==1 || lfit mort5 age if male==0
**women have lower mortality than men**
graph twoway lfit unhealthy age if male==1 || lfit unhealthy age if male==0
**women reported poorer health status than men at younger ages but then it switches after 60**
----
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
oprobit unhealthy income, robust
graph bar unhealthy mort5, over(income)
**graph 3**
**DESCRIBE***

**education**
gen edulevel=1 if edyrs<12
replace edulevel=2 if edyrs==12
replace edulevel=3 if inlist(edyrs,13, 14, 15)
replace edulevel=4 if edyrs==16
replace edulevel=5 if edyrs>16
oprobit mort5 edulevel, robust
oprobit unhealthy edulevel, robust
graph bar unhealthy mort5, over(edulevel)
**graph 4**

**race**
gen race=3 if white==1
replace race=2 if black==1
replace race=1 if hisp==1
replace race=0 if white==0 & black==0 & hisp==0
mprobit mort5 race, robust
mprobit unhealthy race, robust
graph bar unhealthy mort5, over(race)
**graph 5-population that died within 5 years**
**mortality is highest for white people**
**poor health is highest for black people**
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
reg mort5 age income edulevel race, robust // higher R-squared higher SE// *prefer*
predict p_ols
label var p_ols "OLS"
outreg2 using mortality.xls, replace ctitle (MORTALITY_LPM)
reg mort5 youth income edulevel race, robust //higher SEs and coeff//
probit mort5 age income edulevel race, robust
mfx
predict p_probit
label var p_probit "Probit"
outreg2 using mortality.xls, append ctitle (MORTALITY_PROBIT)
logistic mort5 age income edulevel race, robust
mfx
predict p_logistic
label var p_logistic "Logistic"
outreg2 using mortality.xls, append ctitle (MORTALITY_LOGISTIC)
logit mort5 age income edulevel race, robust
mfx
predict p_logit
label var p_logit "Logit"
outreg2 using mortality.xls, append ctitle (MORTALITY_LOGIT)
sort age
twoway scatter mort5 age||line p_ols age||line p_probit age||line p_logistic age||line p_logit age, xlabel(,noticks nolabel) ytitle(mortality) ylabel(-0.5(0.5)1.5)

*Choose logistic. Gives odds ratio*
*health*
reg unhealthy age income edyrs race, robust //for LPM continuous seems better//
reg unhealthy age income edulevel race, robust // higher R-squared higher SE// *prefer*
predict p_ols
label var p_ols "OLS"
reg unhealthy youth income edulevel race, robust //higher SEs and coeff//
probit unhealthy age income edulevel race, robust
mfx
predict p_probit
label var p_probit "Probit"
logistic unhealthy age income edulevel race, robust
mfx
predict p_logistic
label var p_logistic "Logistic"
logit unhealthy age income edyrs race, robust
mfx
predict p_logit
label var p_logit "Logit"
sort age
twoway scatter unhealthy age||line p_ols age||line p_probit age||line p_logistic age||line p_logit age, xlabel(,noticks nolabel) ytitle(health) ylabel(-0.5(0.5)1.5)
**use outreg and append to get all the outputs in one table**
**maybe I should look at the scatterplots to determine best fit?*
*Marginal effects are similar across the models. Here logit and probit become nearly the same*
//Age MFX	0.004	0.0032	0.0026	0.0026 //
********************************************************************************
**                                   P5                                       **
********************************************************************************
//high income Arfrican Americans v. low income Whites//
gen highincome=1 if income==2
replace highincome=0 if income<2
gen lowincome=1 if income==0
replace lowincome=0 if income>0
logistic mort5 age income edulevel black
**coeff is 1.22**
probit mort5 age income edulevel black
foreach var in age income edulevel black {
	su `var'
gen `var'_mean = r(mean)
}
di normprob(_b[age]*age_mean + _b[edulevel]*edulevel_mean + _b[income]*income_mean +_b[black]*black_mean + _b[_cons])
**coeff is .036**
mfx
margins, dydx(black) at (income==2)
**coeff is .0092**
logistic mort5 age income edulevel white 
**coeff is 0.916**
probit unhealthy age income edulevel black
foreach var in age income edulevel black {
	su `var'
gen `var'_mean = r(mean)
}
di normprob(_b[age]*age_mean + _b[edulevel]*edulevel_mean + _b[income]*income_mean +_b[black]*black_mean + _b[_cons])
**coeff is .11**
mfx
margins, dydx(white) at (income==0)
**coeff is -0.0059**
**What's up with the logistic v probit**
**No because factors other than income may be confounding the impact of income**
**health for African Americans also determined by---neighborhood, wealth, etc**
********************************************************************************
**                                   P6                                       **
********************************************************************************
//Are mfx on family income causal//
logistic mort5 age income edulevel black
mfx
margins, dydx(income)
**coeff is -0.018**
logistic mort5 age income edulevel white 
mfx
margins, dydx(income)
**coeff is -0.019**
**Since marginal effects are similar to the Beta in OLS and we have a random sample**
**it COULD be causal. But, as we run other models, we find OVB, they may not be the true beta**
********************************************************************************
**                                   P7                                       **
********************************************************************************
//comment code if it needs some explanations//
gen coverage=1 if uninsured==2
replace coverage=0 if uninsured==1
logistic unhealthy income age, robust
logistic unhealthy income age coverage, robust 
**income coefficient doesn't decrease. It moves up to 0.36. Uninsured is .977**
logistic unhealthy income age alc5upyr, robust
**income coeff moves downward to 0.34 and alc5upyr is roughly one...which is interesting**
logistic unhealthy income age smokev, robust 
** income 0.359 smoking 1.03**
logistic unhealthy income age vig10fwk, robust
**income 0.378 vig10fwk 0.85**IMPORTANT ONE**
logistic unhealthy income age bacon, robust  
**income 0.357 bacone 1.00....interesting that it doesn't seem to matter*

********************************************************************************
**                                   P8                                       **
********************************************************************************
//multinomial health status//
logistic mort5 health age income, robust
**coeff on health is 1.62**
logistic mort5 unhealthy age income, robust
**coeff is 2,84 when only looking at poor health**
scatter mort5 health || fpfit mort5 health
********************************************************************************
**                                   P9                                       **
********************************************************************************
//comment code if it needs some explanations//

********************************************************************************
**                                   P10                                      **
********************************************************************************
//comment code if it needs some explanations//
