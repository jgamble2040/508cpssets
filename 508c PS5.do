
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
reg conscripted eligible i.birthyr
estimates store first_stage
//Use birthyear fixed effect as there was a downward bias in X due to OVB.
//No need to use identity controls as they were not significant.

********************************************************************************
**                                   P5                                       **
********************************************************************************
//comment code if it needs some explanations//

reg crimerate eligible i.birthyr
estimates store reduced_form
suest first_stage reduced_form, robust
nlcom [reduced_form_mean]eligible/[first_stage_mean]eligible
//Coefficient is 0.0027 and significant. Increase in probability of crime if conscripted

sum crimerate if eligible==0

di .0027/.068
//Increase is .0397

foreach var of varlist property murder drug sexual threat arms whitecollar {
	reg `var' eligible i.birthyr
	estimates store reduced_form
	suest first_stage reduced_form, robust
	nlcom [reduced_form_mean]eligible/[first_stage_mean]eligible
}


********************************************************************************
**                                   P6                                       **
********************************************************************************
//comment code if it needs some explanations//
//See above.

********************************************************************************
**                                   P7                                       **
********************************************************************************
//comment code if it needs some explanations//

ivregress 2sls crimerate (conscripted=eligible) i.birthyr, robust
//finding is similar but a little higher than that of the OLS. Eligibility is 
//capturing the exogenous effects of conscription on crime.

foreach var of varlist property murder drug sexual threat arms whitecollar{
	ivregress 2sls `var' (conscripted=eligible) i.birthyr, robust
}
********************************************************************************
**                                   P8                                       **
********************************************************************************
//comment code if it needs some explanations//
//To test significance of IV, eligibility must be correlated with conscription 
//and not correlated with any other.

correlate eligible conscripted
//coeff is .987

foreach var of varlist crimerate murder property drug sexual whitecollar arms threat {
	correlate eligible `var'
}
//Numbers look low but run F-test to be  sure
reg eligible crimerate murder property drug sexual whitecollar arms threat
test crimerate murder property drug sexual whitecollar arms threat
//F-stat is 2.88 prob is .0034
//Eligibility is a viable IV

********************************************************************************
**                                   P9                                       **
********************************************************************************
//comment code if it needs some explanations//

********************************************************************************
**                                   P10                                      **
********************************************************************************
//comment code if it needs some explanations//
