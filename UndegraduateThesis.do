***************Integrated Household Survey of The Gambia 2015/2016******************************************
*Title: THE IMPACT OF REMITTANCES ON HOUSEHOLD WELFARE IN THE GAMBIA: EVIDENCE FROM HOUSEHOLD SURVEY
*Author: Amadou Jawo
*Supervisor: Dr. Hamidou Jawara
*Data Source: Gambia Bureau of Statistics Integrated Household Survey 2015/2016

clear
set more off

//First import the data for Part Section 1 to 6 Individual level
use "C:\Users\22031\Desktop\Files\All files\GMB_2015_IHS_v01_M_Stata8\Part A Section 1-6 Individual-level.dta" 
compress
//Describe Data set
count
des
//keep household head characteristics( note that am anlysing based on household head information)
keep if s1q6==1
//keep variable of interest
keep hid area select_hhold s1q4a s1q5 s1q8 s1q9 s1q10 s3aq6 s4aq3 s4aq5 s4aq7 s4aq10 s4bq4

*Rename Variables
rename area Area
rename select_hhold hhsize
rename s1q4a Age
rename s1q5 Gender
rename s1q8 Ethnicity
rename s1q9 Religion
rename s1q10 Marital_Status
rename s3aq6 Educational_Level
//Generate employment status variable where employ_status=1 means employed and 2 not_employed
gen employed_status=.
replace employed_status=1 if (s4aq3==1)| (s4aq5==1)|(s4aq7==1)
replace employed_status=1 if (s4aq3==2 & s4aq10==1)|(s4aq5==2 & s4aq10==1)|(s4aq7==2 & s4aq10==1)
replace employed_status=2 if employed_status!=1 & (s4aq3==2 & s4bq4==1)| (s4aq5==2 & s4bq4==1)|(s4aq7==2 & s4bq4==1)|(s4aq10==2 & s4bq4==1)
*recode not_employed from 2 to 0
//recode employed_status (2=0)
tab employed_status,m
tab employed_status
drop s4aq3 s4aq5 s4aq7 s4aq10 s4bq4

save "C:\Users\22031\Downloads\IHS_cleaning_part1_6_data.dta", replace


clear
**Import part A section 12A-Transfers received( Note that the transfer received is the remittances) 

use "C:\Users\22031\Desktop\Files\All files\GMB_2015_IHS_v01_M_Stata8\Part A Section 12A-Transfers received.dta" 

* Generate a remittance variable and later define it as 1 if the household head received remittances and 0 otherwise
// gen received_remittances=.
// replace received_remittances=1 if (s12aq1==1)|(s12aq2==1)
// replace received_remittances=2 if received_remittances!=1 & (s12aq1==2 & s12aq2==2)
// recode received_remittances (2=0)
rename s12aq1 remittances
gen remittance_v1=(remittances<=1)
tab remittance_v1
drop remittances
rename remittance_v1 remittances
keep hid remittances
***Check for unique identification of hid using isid hid and then we drop duplicates
duplicates report hid
duplicates drop hid, force
count
isid hid
save "C:\Users\22031\Downloads\IHS_cleaning_parta_12a_data.dta", replace 

**Merge the individual characteristics and Remittances
use "C:\Users\22031\Downloads\IHS_cleaning_part1_6_data.dta"
merge 1:1 hid using "C:\Users\22031\Downloads\IHS_cleaning_parta_12a_data.dta"
keep if _merge==3
drop _merge
save "C:\Users\22031\Downloads\IHS_Part A_master.dta", replace
************************************************************************************************************************************************************************
clear
*** Food Consumption Expenditure-section1.0A exclude food consumtion outside the household ( here we using 7 days recall as classified in the survey questionnaire)***********
use "C:\Users\22031\Desktop\Files\All files\GMB_2015_IHS_v01_M_Stata8\Part B Section 1A-Food_consumption expenditure.dta" 
keep hid s1aq5
**check if household identification is uniquely identify using isid hid and then drop duplicates
duplicates report hid
duplicates drop hid, force
save "C:\Users\22031\Downloads\IHS_food_cons_exp_sa_data.dta", replace

clear
*** Food Consumption Expenditure-section1.1A exclude food consumtion outside the household ( here we using 7 days recall as classified in the survey questionnaire)***********
use "C:\Users\22031\Desktop\Files\All files\GMB_2015_IHS_v01_M_Stata8\Part B Section 1A-Food_consumption expenditure1.dta" 
keep hid s1aq5
rename s1aq5 s1aq5_v1
**check if household identification is uniquely identify using isid hid and then drop duplicates
duplicates report hid
duplicates drop hid, force
save "C:\Users\22031\Downloads\IHS_food_cons_exp_s1a_data.dta", replace

clear 
*** Food Consumption Expenditure-section1.2A exclude food consumtion outside the household ( here we using 7 days recall as classified in the survey questionnaire)***********
use "C:\Users\22031\AppData\Local\Temp\Temp1_GMB_2015_IHS_v01_M_Stata8 (1).zip\Part B Section 1A-Food_consumption expenditure-2.dta"
keep hid s1aq5
rename s1aq5 s1aq5_v2
**check if household identification is uniquely identify using isid hid and then drop duplicates
duplicates report hid
duplicates drop hid, force

save "C:\Users\22031\Downloads\IHS_food_cons_exp2_data.dta", replace

clear
*** Food Consumption Expenditure-section1B outside the household  for the past 7 days***********
use "C:\Users\22031\Desktop\Files\All files\GMB_2015_IHS_v01_M_Stata8\Part B Section 1B-Food_outside.dta" 
keep hid s1bq3
**check if household identification is uniquely identify using isid hid and then drop duplicates
duplicates report hid
duplicates drop hid, force
save "C:\Users\22031\Downloads\IHS_food_cons_ouside_hh.dta", replace

clear

//We can merge all the three(3) food consumption in the household and outside the household, after we can calculate the total food consumption
use "C:\Users\22031\Downloads\IHS_food_cons_exp_sa_data.dta"
merge 1:1 hid using "C:\Users\22031\Downloads\IHS_food_cons_exp_s1a_data.dta"
keep if _merge==3
drop _merge
merg 1:1 hid using "C:\Users\22031\Downloads\IHS_food_cons_exp2_data.dta"
keep if _merge==3
drop _merge
merge 1:1 hid using "C:\Users\22031\Downloads\IHS_food_cons_ouside_hh.dta"
keep if _merge==3


**Generate the total food consumption expenditure***
egen Food_Consumption_Expenditure=rowtotal(s1aq5 s1aq5_v1 s1aq5_v2 s1bq3)
keep hid Food_Consumption_Expenditure
**Save Food Consumption Expeniture
save "C:\Users\22031\Downloads\IHS_Food_Consumption_Spending.dta", replace
*********************************************************************************************************************************************************
clear 
****Non-Food Consumption expenditure***********
// SECTION 2A: NON-FOOD LAST SEVEN DAYS
use "C:\Users\22031\Desktop\Files\All files\GMB_2015_IHS_v01_M_Stata8\Part B Section 2A-Nonfood last 7 days.dta" 
keep hid s2aq3
**check if household identification is uniquely identify using isid hid and then drop duplicates to make it uniquely identify
duplicates report hid
duplicates drop hid, force
save "C:\Users\22031\Downloads\IHS_Non_Food_exp_7day_recall_data.dta", replace

clear
*******SECTION 2B: NON-FOOD LAST 1 MONTH*******************
use "C:\Users\22031\Desktop\Files\All files\GMB_2015_IHS_v01_M_Stata8\Part B Section 2B-Nonfood last 1 month.dta" 
keep hid s2bq3
**check if household identification is uniquely identify using isid hid and then drop duplicates to make it uniquely identify
duplicates report hid
duplicates drop hid, force
save "C:\Users\22031\Downloads\IHS_Non_food_exp_1month_data.dta", replace

clear
****SECTION 2C: NON-FOOD LAST 3 MONTHS*****
use "C:\Users\22031\Desktop\Files\All files\GMB_2015_IHS_v01_M_Stata8\Part B Section 2C-Nonfood last 3 months.dta" 
keep hid s2cq3
**check if household identification is uniquely identify using isid hid and then drop duplicates to make it uniquely identify
duplicates report hid
duplicates drop hid, force
save "C:\Users\22031\Downloads\IHS_Non_Food_exp_3month.dta", replace

clear
****SECTION 2C: NON-FOOD LAST 12 MONTHS***** Note that this is classified as known frequency 

use "C:\Users\22031\Desktop\Files\All files\GMB_2015_IHS_v01_M_Stata8\Part B Section 2D-Nonfood last 12 months.dta" 
keep hid s2dq3
**check if household identification is uniquely identify using isid hid and then drop duplicates to make it uniquely identify
duplicates report hid
duplicates drop hid, force
save "C:\Users\22031\Downloads\IHS_Non_Food_exp_12month.dta", replace


//We can now merge all of the non food expenditure
use "C:\Users\22031\Downloads\IHS_Non_Food_exp_7day_recall_data.dta"
merge 1:1 hid using "C:\Users\22031\Downloads\IHS_Non_food_exp_1month_data.dta"
keep if _merge==3
drop _merge
merge 1:1 hid using "C:\Users\22031\Downloads\IHS_Non_Food_exp_3month.dta"
keep if _merge==3
drop _merge
merge 1:1 hid using  "C:\Users\22031\Downloads\IHS_Non_Food_exp_12month.dta"
keep if _merge==3


*Generate Non Food Expenditure
egen Non_Food_Expenditure=rowtotal(s2aq3 s2bq3 s2cq3 s2dq3)
keep hid Non_Food_Expenditure
**save Non Food Expenditure
save "C:\Users\22031\Downloads\Non_Food_Expenditure.dta", replace
*******************************************************************************************************************************************
*Merge PartA_master(individual characteristics) with food consumption expenditure and non food expenditure, and calculate the total expenditure by summing food and non expenditure
use "C:\Users\22031\Downloads\IHS_Part A_master.dta"
merge 1:1 hid using "C:\Users\22031\Downloads\IHS_Food_Consumption_Spending.dta"
keep if _merge==3
drop _merge
merge 1:1 hid using "C:\Users\22031\Downloads\Non_Food_Expenditure.dta"
keep if _merge==3
drop _merge
egen Total_expenditure=rowtotal( Food_Consumption_Expenditure Non_Food_Expenditure)

**Now we can save our Master Dataset
save "C:\Users\22031\Downloads\IHS_Master_data_set_Amadou.dta", replace
********************************************************************************************************************************
* We want to winsorize to reduce the potential of outliers on our data for statistical analysis. 
*First install winsor
//ssc install winsor
* Winsorizing age,hhsize, food and non-food expenditure, and total expenditure
winsor Age, gen(wisnor_age) p(0.1) 
winsor hhsize, gen( winsor_hhsize) p(0.1)
winsor Total_expenditure, gen( winsor_Total_expenditure4) p(0.01)
winsor Food_Consumption_Expenditure, gen(winsor_Food_Expenditure4) p(0.01)
winsor Non_Food_Expenditure, gen( winsor_Non_Food_Expenditure4) p(0.01)
* Mean and Standard Deviation for the treatment and control group
bysort remittances: tabstat winsor_Total_expenditure4 winsor_Food_Expenditure4 winsor_Non_Food_Expenditure4 wisnor_age winsor_hhsize  Gender Ethnicity Religion Marital_Status  Educational_Level employed_status Area, stat(mean sd) 
*Pooled mean and Standard Deviation
tabstat winsor_Total_expenditure4 winsor_Food_Expenditure4 winsor_Non_Food_Expenditure4 wisnor_age winsor_hhsize Gender Ethnicity Religion Marital_Status Educational_Level employed_status Area, stat(mean sd) 
*Use ttest to calculate mean difference between treatment and control
ttest winsor_Total_expenditure4,by(remittances) 
ttest winsor_Food_Expenditure4,by(remittances) 
ttest winsor_Non_Food_Expenditure4 ,by(remittances) 
ttest winsor_hhsize,by(remittances) 
ttest wisnor_age,by(remittances) 
ttest Gender ,by(remittances)  
ttest Ethnicity ,by(remittances) 
ttest Religion,by(remittances) 
ttest Marital_Status,by(remittances) 
ttest Educational_Level ,by(remittances) 
ttest employed_status,by(remittances) 
ttest Area ,by(remittances) 
********************************************************************************************************************************************************************
************************************************************Propensity Score Matching********************************************************************************
** Use Pscore to estimates the propensity scores, balancing condition and common support. They are two assumptions very relevant for Propensity score Matching to be valid  
pscore remittances winsor_hhsize wisnor_age Gender Ethnicity Religion Marital_Status Educational_Level employed_status , pscore(myscore) blockid(myblock) comsup
**Balancing diagnostics only on the total expenditure
kmatch ps remittances wisnor_age winsor_hhsize ( winsor_Total_expenditure4= wisnor_age winsor_hhsize ), ematch( employed_status Educational_Level Marital_Status Religion Ethnicity Gender Area ) att 
kmatch density
kmatch cumul
**Overlap Propensity score plots before matching; note that we can still used the above estimated score and the predict score after our probit model and have the same results
probit remittances winsor_hhsize wisnor_age Gender Ethnicity Religion Marital_Status Educational_Level employed_status
predict pscore, p
psgraph, bin(10) treated(remittances) ps(pscore ) title( "Overlap plots before matching") name(graph1, replace)
***Main Analysis using nearest neibor matching and kernel matching how we need to install kmatch using ssc install kmatch, Am using one nearest neighbor(nn) matching
*Nearest neibor matching
teffects psmatch (winsor_Total_expenditure4 ) ( remittances employed_status Educational_Level Marital_Status Religion Ethnicity Gender Area wisnor_age winsor_hhsize , probit), nneighbor(1) atet  
teffects psmatch (winsor_Food_Expenditure4) ( remittances employed_status Educational_Level Marital_Status Religion Ethnicity Gender Area wisnor_age winsor_hhsize , probit), nneighbor(1) atet 
teffects psmatch (winsor_Non_Food_Expenditure4) ( remittances employed_status Educational_Level Marital_Status Religion Ethnicity Gender Area wisnor_age winsor_hhsize , probit), nneighbor(1) atet
*Using 3 nn matching
teffects psmatch (winsor_Total_expenditure4 ) ( remittances employed_status Educational_Level Marital_Status Religion Ethnicity Gender Area wisnor_age winsor_hhsize , probit), nneighbor(3) atet 
teffects psmatch (winsor_Food_Expenditure4) ( remittances employed_status Educational_Level Marital_Status Religion Ethnicity Gender Area wisnor_age winsor_hhsize , probit), nneighbor(3) atet 
teffects psmatch (winsor_Non_Food_Expenditure4) ( remittances employed_status Educational_Level Marital_Status Religion Ethnicity Gender Area wisnor_age winsor_hhsize , probit), nneighbor(3) atet

 
**Overlap Propensity score plots after matching
teffects overlap, title( "Overlap plots after matching") name(graph2, replace)
graph combine graph1 graph2

*Kernel matching
kmatch ps remittances wisnor_age winsor_hhsize ( winsor_Total_expenditure4= wisnor_age winsor_hhsize ), ematch( employed_status Educational_Level Marital_Status Religion Ethnicity Gender Area ) att
kmatch ps remittances wisnor_age winsor_hhsize (winsor_Food_Expenditure4= wisnor_age winsor_hhsize), ematch( employed_status Educational_Level Marital_Status Religion Ethnicity Gender Area ) att
kmatch ps remittances wisnor_age winsor_hhsize (winsor_Non_Food_Expenditure4= wisnor_age winsor_hhsize ), ematch( employed_status Educational_Level Marital_Status Religion Ethnicity Gender Area ) att
*compare matched/unmatch/total plots
kmatch cdensity
**Radius Matching 
attr winsor_Total_expenditure4 remittances winsor_hhsize wisnor_age employed_status Educational_Level Marital_Status Religion Ethnicity Gender Area,pscore(myscore) comsup boot  dots radius(0.1)
attr winsor_Food_Expenditure4 remittances winsor_hhsize wisnor_age employed_status Educational_Level Marital_Status Religion Ethnicity Gender Area,pscore(myscore) comsup boot  dots radius(0.1)
attr winsor_Non_Food_Expenditure4 remittances winsor_hhsize wisnor_age employed_status Educational_Level Marital_Status Religion Ethnicity Gender Area,pscore(myscore) comsup boot  dots radius(0.1)

***Sensitivity Analysis for robustness check**** 
*Note that there are diffirent approaches to sensitivity analysis, however, I am going to used results from outcome efficient and selection efficient to determine this
// ssc install sensatt
sensatt winsor_Total_expenditure4 remittances winsor_hhsize wisnor_age Area Gender Ethnicity Religion Marital_Status Educational_Level employed_status , p11(0.6) p10(0.5) p01(0.5)p00(0.2) reps(100) comsup
sensatt winsor_Food_Expenditure4 remittances winsor_hhsize wisnor_age Area Gender Ethnicity Religion Marital_Status Educational_Level employed_status , p11(0.6) p10(0.5) p01(0.5) p00(0.2) reps(100) comsup
sensatt winsor_Non_Food_Expenditure4 remittances winsor_hhsize wisnor_age Area Gender Ethnicity Religion Marital_Status Educational_Level employed_status , p11(0.6) p10(0.5) p01(0.5) p00(0.2) reps(100) comsup
