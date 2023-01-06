************Analysis of Post Election survey conducted by the Students' union of The University of The Gambia*********
*******Name of Analyst:Amadou Jawo*****************************

clear 
set more off 

//upload the datasets
use "C:\Users\22031\Desktop\Poverty\Fiinal_Master_Data_SU_2022.dta"

*********Before Starting try to install the following*********************
//First install commands used in this do file
local user_commands splitvallabels catplot yalescheme estout
   foreach command of local user_commands {
       cap which `command'
       if _rc == 111 {
           ssc install `command'
       }
   }

set scheme yale 
//set graphics off
graph set window fontface "Palatino-Roman" // Text font for graphs
*************************Demographic Characteristics*******************************
catplot gender age , percent(gender) var1opts(label(labsize(small))) ///
var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
blabel(bar, format(%4.1f)) intensity(50) asyvars

//Gender by Educational Level
catplot lga ,over( educational_level) stack asyvars percent( educational_level) recast(bar)

****** Tabulation and graphics for the rest of the questions**********************

tab peace
asdoc tab peace, save(peace)
tab advocate_peace
graph pie, over( advocate_peace ) plabel(_all percent) scheme(yale)
asdoc tab advocate_peace
tab peace_coexistence_community
graph pie, over( peace_coexistence_community ) plabel(_all percent) scheme(yale)
graph pie, over( attend_seminar_community ) plabel(_all percent) scheme(yale)
tab NGO_gov_adv_com_peace
tab NGO_gov_ad_after
tab ethnic_difference
graph pie, over( ethnic_difference ) plabel(_all percent) scheme(yale)
tab lga ethnic_difference if ethnic_difference==2
help tab
table ( lga ) ( ethnic_difference ) ()
table ( lga ) ( ethnic_difference ) (), statistic(percent  lga)
table ( lga ) ( ethnic_difference ) ()
table ( lga ) ( ethnic_difference ) (), statistic(mean  ethnic_difference)
tab ethnic_witness_heard
asdoc tab ethnic_witness_heard
tab face_ethnic_sentiment
tab lga face_ethnic_sentiment
asdoc tab face_ethnic_sentiment
tab vote_ethnic_construction
tab peace_before
tab rate_peace_during
sum rate_peace_during Peace_after
asdoc sum rate_peace_during Peace_after
tab electn_divide_pple
graph bar,over( electn_divide_pple ) asyvars blabel(bar, format(%9.1f))
tab cand_attac_tribes
tab transparent
graph bar,over( transparent ) asyvars blabel(bar, format(%9.1f))
tab trust_iec
graph pie, over( trust_iec ) plabel(_all percent) scheme(yale)
tab multi_party
asdoc tab multi_party
tab political_tolerance
asdoc tab political_tolerance

