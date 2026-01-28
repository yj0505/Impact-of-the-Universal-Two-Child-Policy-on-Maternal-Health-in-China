/*change the storage path*/
cd"C:\Users\yajie\OneDrive\Desktop\research\CFPS data"
/*2012 data processing*/
/*choose spouse id for family*/
use "total data\ecfps2012famconf_092015.dta", clear
keep fid10 pid pid_s
save "total data\data file in process\2012spouseid.dta", replace

/*choose variables for family*/
use "total data\ecfps2012famecon_201906.dta", clear
keep fid10 cyear nonhousing_debts house_debts fincome2_adj total_asset familysize /*
*/ pce food dress house daily med trco eec other expense fresp1
gen double headid= fid10*1000+fresp1+100
rename fincome2_adj faminc
drop fresp1
save "total data\data file in process\2012family.dta",replace

/*choose variables for adult*/
use "total data\data file in process\2010adult.dta", clear
keep ethn fid10
sort fid10
save"total data\data file in process\2010ethn.dta", replace

use "total data\data file in process\2010adult.dta", clear
keep fid10 sibnum
sort fid10
save"total data\data file in process\2010sibnum.dta", replace
use "total data\ecfps2012adult_201906.dta", clear
keep fid10 fid12 pid provcd urban12 cfps2012_age cfps2012_gender qa701code eduy2012 qe104/*
*/ qg101 qp101 qp102 qp201 qp401 qp701 qq201 qq301 qq501 qq6016 qq60114 qq60111 qq60118 qq6017 qq60120 /*
*/ nchd1 income_adj qq6016 qp501followuptotal sg413 sg414 qq102_a_1 qq102_a_2 qq102_a_3 qq102_a_4/*
*/ qq102_a_5 qq102_a_6 qq102_a_7 qp202 qp303 qp403a qp403b
/*numbers of children*/
rename nchd1 childnum
/*urban*/
rename urban12 urban
/*age*/
rename cfps2012_age age
keep if age>=18 & age<=50
/*gender*/
rename cfps2012_gender male 
/*years of education*/
rename eduy2012 educ 
/*married*/
gen married=1 if qe104==2
replace married=0 if qe104==1| qe104==3| qe104==4| qe104==5
drop if qe104<0
/*Han ethnicity*/ 	  
sort fid10
merge m:m fid10 using "total data\data file in process\2010ethn.dta"
drop if _merge==2
replace ethn=1 if qa701code==1
replace ethn=0 if qa701code>1
drop _merge   
/*sibling number use 2010*/
sort fid10
merge m:m fid10 using "total data\data file in process\2010sibnum.dta"
drop if _merge==2
/*has a job*/
rename qg1 job
replace job=1 if job==5
replace job=0 if job<0 
/*working hours per month*/
replace sg413=1 if sg413<0
replace sg414=0 if sg414<0
gen workhour=sg413*sg414
/*exercise per week*/
gen exercise= qp701
replace exercise=0 if qp701==5
drop if exercise<0
replace exercise=1 if qp701<5
/*personal income*/
drop if income_adj<0
rename income_adj income
/*whether smoke*/
rename qq201 smoke
drop if smoke<0
/*whether drink*/
rename qq301 drink
drop if drink<0

/*health index*/
/*physical health*/
/*better physical health*/
rename qp202 phy_health1
replace phy_health1=. if phy_health1<0
replace phy_health1=0 if phy_health1==3
replace phy_health1=0 if phy_health1==5

/*recent diease*/
gen sick=0
replace sick=1 if qp303==5
/*hypertension*/
gen hypertension=0
replace hypertension=1 if qp403a=="11.66"|qp403b=="11.66"
/*obesity*/
gen hei_sq=qp101^2/10000
gen wei=qp102/2
gen bmivalue=wei/hei_sq
gen obesity=0 if bmivalue<30
replace obesity=1 if bmivalue>=30
/*self evaluation health, healthy=1 or if good health<3*/
drop if qp201<0
gen self_phy_health=0
replace self_phy_health=1 if qp201<=2	 
rename qp201 phy_health
drop if phy_health<0
replace phy_health=1 if phy_health<=1
replace phy_health=0 if phy_health>1
/*hospital expense*/
rename qp501followuptotal exp_hp
replace exp_hp=0 if exp_hp<0
replace exp_hp=1 if exp_hp>0
 /*chronic=1 */
rename qp401 chronic 
drop if chronic<0
/*body ability score*/
gen h_out=0
replace h_out=1 if qq102_a_1>0 & qq102_a_1<7 
gen h_eat=0
replace h_eat=1 if qq102_a_2>0 & qq102_a_2<7
gen h_kit=0
replace h_kit=1 if qq102_a_3>0 & qq102_a_3<7 
gen h_tras=0
replace h_tras=1 if qq102_a_4>0 & qq102_a_4<7 
gen h_shop=0
replace h_shop=1 if qq102_a_5>0 & qq102_a_5<7 
gen h_clean=0
replace h_clean=1 if qq102_a_6>0 & qq102_a_6<7 
gen h_laun=0
replace h_laun=1 if qq102_a_7>0 & qq102_a_7<7
gen phy_adl=0
replace phy_adl=1 if h_out==1| h_eat==1| h_kit==1|h_tras==1|h_shop==1|h_clean==1|h_laun==1
/*mental health*/
/*good memory*/
rename qq501 memory
gen good_mmy=0
replace good_mmy=1 if memory==1|memory==2
drop if memory<0
/*CES-D mental score high= unhealthy*/
rename qq6016 depress
rename qq60114 nervous
rename qq60111 restless
rename qq60118 hopeless
rename qq6017 effortless
rename qq60120 meaningless
drop if depress<0
drop if nervous<0
drop if restless<0
drop if hopeless<0
drop if effortless<0
drop if meaningless<0
replace depress=0 if depress==4
replace depress=4 if depress==3
replace depress=3 if depress==1
replace depress=1 if depress==4
replace nervous=0 if nervous==4
replace nervous=4 if nervous==3
replace nervous=3 if nervous==1
replace nervous=1 if nervous==4
replace restless=0 if restless==4
replace restless=4 if restless==3
replace restless=3 if restless==1
replace restless=1 if restless==4
replace hopeless=0 if hopeless==4
replace hopeless=4 if hopeless==3
replace hopeless=3 if hopeless==1
replace hopeless=1 if hopeless==4
replace effortless=0 if effortless==4
replace effortless=4 if effortless==3
replace effortless=3 if effortless==1
replace effortless=1 if effortless==4
replace meaningless=0 if meaningless==4
replace meaningless=4 if meaningless==3
replace meaningless=3 if meaningless==1
replace meaningless=1 if meaningless==4
gen mental_score=depress + nervous + hopeless + restless + effort + meaningless
/*depression 抑郁*/
gen depression=0 if mental_score>12
replace depression=1 if mental_score<=12
drop qe104 qa701code sg413 sg414 qp701 qp101 qp102 qq102_a_1 qq102_a_2 qq102_a_3 qq102_a_4/*
*/ qq102_a_5 qq102_a_6 qq102_a_7 hei_sq wei h_out h_kit h_eat h_tras h_shop h_clean h_laun /*
*/ memory depress nervous restless hopeless effortless meaningless qp303 qp403a qp403b
save "total data\data file in process\2012adult.dta",replace
/*total sample*/
use "total data\data file in process\2012adult.dta",clear
sort fid10
drop _merge
merge m:m fid10 using "total data\data file in process\2012family.dta"
keep if _merge==3
drop _merge
gen head=0
replace head=1 if pid==headid
save"total data\data file in process\2012paperdata.dta",replace
/*add living with parents*/
use "total data\ecfps2012famconf_092015.dta", clear
gen withparent=0
replace withparent=1 if tb6_a12_f==1| tb6_a12_m==1
keep pid fid10 withparent
sort pid fid10
save "total data\data file in process\2012withparent.dta",replace
merge m:m pid fid10 using "total data\data file in process\2012paperdata.dta"
drop if _merge==1
drop _merge
merge m:m pid fid10 using "total data\data file in process\2012spouseid.dta"
drop if _merge==1
drop _merge
save"total data\data file in process\2012paperdata.dta",replace4

/*2014 data processing*/
/*choose spouse id for family*/
 use "total data\\ecfps2014famconf_170630.dta", clear
 keep fid10 pid pid_s
 save "total data\data file in process\2014spouseid.dta", replace
/*choose variables for family*/
use "total data\ecfps2014famecon_201906.dta", clear
keep fid10 cyear nonhousing_debts house_debts fincome2 total_asset familysize /*
*/ pce food dress house daily med trco eec other expense fresp1pid
rename fincome2 faminc
rename fresp1pid headid
save "total data\data file in process\2014family.dta",replace
/*choose variables for adult*/
use "total data\data file in process\2012adult.dta", clear
keep ethn fid12
sort fid12
save"total data\data file in process\2012ethn.dta", replace
use "total data\ecfps2014adult_201906.dta", clear
keep fid10 fid12 fid14 pid provcd14 urban14 cfps2014_age cfps_gender qa701code cfps2014eduy_im qea0/*
*/ qg1 qp101 qp102 qp201 qp401 qp702 qq201 qq301 qq501 qq601 qq602 qq603 qq604 qq605 qq606/*
*/ code_a_c1 code_a_c2 code_a_c3 code_a_c4 code_a_c5 code_a_c6 code_a_c7 code_a_c8/*
*/ code_a_c9 code_a_c10 incomea incomeb qp501 qg6 qq102_a_1 qq102_a_2 qq102_a_3 qq102_a_4/*
*/ qq102_a_5 qq102_a_6 qq102_a_7 qp202 qp303 qp402acode qp402bcode
/*numbers of children*/
gen child1=1 if code_a_c1 !=-8
replace child1=0 if child1==.
gen child2=1 if code_a_c2 !=-8
replace child2=0 if child2==.
gen child3=1 if code_a_c3 !=-8
replace child3=0 if child3==.
gen child4=1 if code_a_c4 !=-8
replace child4=0 if child4==.
gen child5=1 if code_a_c5 !=-8
replace child5=0 if child5==.
gen child6=1 if code_a_c6 !=-8
replace child6=0 if child6==.
gen child7=1 if code_a_c7 !=-8
replace child7=0 if child7==.
gen child8=1 if code_a_c8 !=-8
replace child8=0 if child8==.
gen child9=1 if code_a_c9 !=-8
replace child9=0 if child9==.
gen child10=1 if code_a_c10 !=-8
replace child10=0 if child10==.
gen childnum=child1+child2+child3+child4+child5+child6+child7+child8+child9+child10
/*province*/
rename provcd14 provcd
/*urban*/
rename urban14 urban
/*age*/
rename cfps2014_age age
keep if age>=18 & age<=50
/*gender*/
rename cfps_gender male 
/*years of education*/
rename cfps2014eduy_im educ 
/*married*/
gen married=1 if qea0==2
replace married=0 if qea0==1| qea0==4| qea0==5| qea0==3
drop if qea0<0
/*Han ethnicity*/ 	 
sort fid12
merge m:m fid12 using "total data\data file in process\2012ethn.dta"
drop if _merge==2
replace ethn=1 if qa701code==1
replace ethn=0 if qa701code>1
drop _merge 
/*sibling number use 2010*/
sort fid10
merge m:m fid10 using "total data\data file in process\2010sibnum.dta"
drop if _merge==2
drop _merge
/*has a job*/
rename qg1 job
replace job=1 if job==5
replace job=0 if job<0 
/*working hours per month*/
replace qg6=0 if qg<0 |qg==.
replace qg6=qg6*4
rename qg6 workhour
/*exercise per week*/
gen exercise= qp702
replace exercise=0 if qp702<0
/*personal income*/
replace incomea=0 if incomea<0 | incomea==.
replace incomeb=0 if incomeb<0 | incomeb==.
gen income= incomea +incomeb
/*whether smoke*/
rename qq201 smoke
drop if smoke<0
/*whether drink*/
rename qq301 drink
drop if drink<0
/*health index*/
/*physical health*/
/*better physical health*/
rename qp202 phy_health1
replace phy_health1=. if phy_health1<0
replace phy_health1=0 if phy_health1==3
replace phy_health1=0 if phy_health1==5
/*recent diease*/
gen sick=0
replace sick=1 if qp303==5
/*hypertension*/
gen hypertension=0
replace hypertension=1 if qp402acode=="11.66"|qp402bcode=="11.66" 
/*obesity*/
gen hei_sq=qp101^2/10000
gen wei=qp102/2
gen bmivalue=wei/hei_sq
gen obesity=0 if bmivalue<30
replace obesity=1 if bmivalue>=30
/*self evaluation health, healthy=1 or if good health<3*/
drop if qp201<0
gen self_phy_health=0
replace self_phy_health=1 if qp201<=2
rename qp201 phy_health
drop if phy_health<0
replace phy_health=1 if phy_health<=1
replace phy_health=0 if phy_health>1
/*whether hospital*/
rename qp501 hosp
replace hosp=0 if hosp<0|hosp==.
/*chronic=1 */
rename qp401 chronic 
drop if chronic<0
/*body ability score*/
gen h_out=0
replace h_out=1 if qq102_a_1>0 & qq102_a_1<7
gen h_eat=0
replace h_eat=1 if qq102_a_2>0 & qq102_a_2<7
gen h_kit=0
replace h_kit=1 if qq102_a_3>0 & qq102_a_3<7 
gen h_tras=0
replace h_tras=1 if qq102_a_4>0 & qq102_a_4<7
gen h_shop=0
replace h_shop=1 if qq102_a_5>0 & qq102_a_5<7 
gen h_clean=0
replace h_clean=1 if qq102_a_6>0 & qq102_a_6<7 
gen h_laun=0
replace h_laun=1 if qq102_a_7>0 & qq102_a_7<7
gen phy_adl=0
replace phy_adl=1 if h_out==1| h_eat==1| h_kit==1|h_tras==1|h_shop==1|h_clean==1|h_laun==1
/*mental health*/
/*good memory*/
rename qq501 memory
gen good_mmy=0
replace good_mmy=1 if memory==1|memory==2
drop if memory<0
/*CES-D mental score high= unhealthy*/
rename qq601 depress
rename qq602 nervous
rename qq603  restless
rename qq604 hopeless
rename qq605 effortless
rename qq606 meaningless
drop if depress<0
drop if nervous<0
drop if restless<0
drop if hopeless<0
drop if effortless<0
drop if meaningless<0
replace depress=0 if depress==1|depress==2
replace depress=1 if depress==3
replace depress=2 if depress==4
replace depress=3 if depress==5
replace nervous=0 if nervous==1|nervous==2
replace nervous=1 if nervous==3
replace nervous=2 if nervous==4
replace nervous=3 if nervous==5
replace restless=0 if restless==1|restless==2
replace restless=1 if restless==3
replace restless=2 if restless==4
replace restless=3 if restless==5
replace hopeless=0 if hopeless==1|hopeless==2
replace hopeless=1 if hopeless==3
replace hopeless=2 if hopeless==4
replace hopeless=3 if hopeless==5
replace effortless=0 if effortless==1|effortless==2
replace effortless=1 if effortless==3
replace effortless=2 if effortless==4
replace effortless=3 if effortless==5
replace meaningless=0 if meaningless==1|meaningless==2
replace meaningless=1 if meaningless==3
replace meaningless=2 if meaningless==3
replace meaningless=3 if meaningless==5
gen mental_score=depress + nervous + hopeless + restless + effort + meaningless
/*depression 抑郁*/
gen depression=0 if mental_score>12
replace depression=1 if mental_score<=12
drop code_a_c1 code_a_c2 code_a_c3 code_a_c4 code_a_c5 code_a_c6 code_a_c7 code_a_c8/*
*/ code_a_c9 code_a_c10 qea0 qa701code qp702 qp101 qp102 qq102_a_1 qq102_a_2 qq102_a_3 qq102_a_4/*
*/ qq102_a_5 qq102_a_6 qq102_a_7 h_out h_kit h_eat h_tras h_shop h_clean h_laun memory depress nervous restless hopeless effortless meaningless/*
*/ incomea incomeb child1 child2 child3 child4 child5 child6 child7 child8 child9 child10 hei_sq wei qp303 qp402acode qp402bcode
save "total data\data file in process\2014adult.dta",replace
/*total sample*/
use "total data\data file in process\2014adult.dta",clear
sort fid10
merge m:m fid10 using "total data\data file in process\2014family.dta"
keep if _merge==3
drop _merge
gen head=0
replace head=1 if pid==headid
merge m:m pid fid10 using "total data\data file in process\2014spouseid.dta"
drop if _merge==1
drop _merge
save"total data\data file in process\2014paperdata.dta",replace

/*2016 data processing*/
/*choose spouse id for family*/
use "total data\ecfps2016famconf_201804.dta", clear
keep fid10 pid pid_s
save "total data\data file in process\2016spouseid.dta", replace
/*choose variables for family*/
use "total data\ecfps2016famecon_201807.dta", clear
keep fid10 fid12 cyear nonhousing_debts house_debts fincome2 total_asset familysize16 /*
*/ pce food dress house daily med trco eec other expense resp1pid
rename fincome2 faminc
rename familysize16 familysize
rename resp1pid headid
save "total data\data file in process\2016family.dta",replace
/*choose variables for adult*/
use "total data\data file in process\2014adult.dta", clear
keep ethn fid14
sort fid14
save"total data\data file in process\2014ethn.dta", replace
use "total data\ecfps2016adult_201906.dta", clear
keep fid10 fid12 fid14 fid16 pid provcd16 urban16 cfps_age cfps_gender pa701code cfps2016eduy_im qea0/*
*/ qg1 qp101 qp102 qp201 qp401 qp702 qq201 qq301 qq501 pn406 pn414 pn411 pn418 pn407 pn420 cfps_childn/*
*/ incomea incomeb qg6 qq1011 qq1012 qq1013 qq1014 qq1015 qq1016 qq1017 qp202 qp303 qp402acode qp402bcode
/*numbers of children*/
rename cfps_childn childnum
/*province*/
rename provcd16 provcd
/*urban*/
rename urban16 urban
/*age*/
rename cfps_age age
keep if age>=18 & age<=50
/*gender*/
rename cfps_gender male 
/*years of education*/
rename cfps2016eduy_im educ 
/*married*/
gen married=1 if qea0==2
replace married=0 if qea0==1| qea0==4| qea0==5| qea0==3
drop if qea0<0
/*Han ethnicity*/ 	 
sort fid14
merge m:m fid14 using "total data\data file in process\2014ethn.dta"
drop if _merge==2
replace ethn=1 if pa701code==1
replace ethn=0 if pa701code>1
drop _merge 
save "total data\data file in process\2016ethn.dta",replace
/*sibling number use 2010*/
sort fid10
merge m:m fid10 using "total data\data file in process\2010sibnum.dta"
drop if _merge==2
drop _merge
/*has a job*/
rename qg1 job
replace job=1 if job==5
replace job=0 if job<0 
/*working hours per month*/
replace qg6=0 if qg<0 |qg==.
replace qg6=qg6*4
rename qg6 workhour
/*exercise per week*/
gen exercise= qp702
replace exercise=0 if qp702<0
/*personal income*/
replace incomea=0 if incomea<0 | incomea==.
replace incomeb=0 if incomeb<0 | incomeb==.
gen income= incomea +incomeb
/*whether smoke*/
rename qq201 smoke
drop if smoke<0
/*whether drink*/
rename qq301 drink
drop if drink<0
/*health index*/
/*physical health*/
/*better physical health*/
rename qp202 phy_health1
replace phy_health1=. if phy_health1<0
replace phy_health1=0 if phy_health1==3
replace phy_health1=0 if phy_health1==5
/*recent diease*/
gen sick=0
replace sick=1 if qp303==5
/*hypertension*/
gen hypertension=0
replace hypertension=1 if qp402acode=="11.66"|qp402bcode=="11.66" 
/*obesity*/
gen hei_sq=qp101^2/10000
gen wei=qp102/2
gen bmivalue=wei/hei_sq
gen obesity=0 if bmivalue<30
replace obesity=1 if bmivalue>=30
/*self evaluation health, healthy=1 or if good health<3*/
drop if qp201<0
gen self_phy_health=0
replace self_phy_health=1 if qp201<=2	 
rename qp201 phy_health
drop if phy_health<0
replace phy_health=1 if phy_health<=1
replace phy_health=0 if phy_health>1
/*whether hospital
rename qp501 hosp
replace hosp=0 if hosp<0|hosp==.*/
/*chronic=1 */
rename qp401 chronic 
drop if chronic<0
/*body ability score*/
gen h_out=0
replace h_out=1 if qq1011==0
gen h_eat=0
replace h_eat=1 if qq1012==0
gen h_kit=0
replace h_kit=1 if qq1013==0
gen h_tras=0
replace h_tras=1 if qq1014==0
gen h_shop=0
replace h_shop=1 if qq1015==0
gen h_clean=0
replace h_clean=1 if qq1016==0
gen h_laun=0
replace h_laun=1 if qq1017==0
gen phy_adl=0
replace phy_adl=1 if h_out==1| h_eat==1| h_kit==1|h_tras==1|h_shop==1|h_clean==1|h_laun==1
/*mental health*/
/*good memory*/
rename qq501 memory
gen good_mmy=0
replace good_mmy=1 if memory==1|memory==2
drop if memory<0
/*CES-D mental score high= unhealthy*/
rename pn406 depress
rename pn414 nervous
rename pn411  restless
rename pn418 hopeless
rename pn407 effortless
rename pn420 meaningless
drop if depress<0
drop if nervous<0
drop if restless<0
drop if hopeless<0
drop if effortless<0
drop if meaningless<0
replace depress=0 if depress==4
replace depress=4 if depress==3
replace depress=3 if depress==1
replace depress=1 if depress==4
replace nervous=0 if nervous==4
replace nervous=4 if nervous==3
replace nervous=3 if nervous==1
replace nervous=1 if nervous==4
replace restless=0 if restless==4
replace restless=4 if restless==3
replace restless=3 if restless==1
replace restless=1 if restless==4
replace hopeless=0 if hopeless==4
replace hopeless=4 if hopeless==3
replace hopeless=3 if hopeless==1
replace hopeless=1 if hopeless==4
replace effortless=0 if effortless==4
replace effortless=4 if effortless==3
replace effortless=3 if effortless==1
replace effortless=1 if effortless==4
replace meaningless=0 if meaningless==4
replace meaningless=4 if meaningless==3
replace meaningless=3 if meaningless==1
replace meaningless=1 if meaningless==4
gen mental_score=depress + nervous + hopeless + restless + effort + meaningless
/*depression 抑郁*/
gen depression=0 if mental_score>12
replace depression=1 if mental_score<=12
drop qea0 pa701code qp702 qp101 qp102 qq1011 qq1012 qq1013 qq1014/*
*/ qq1015 qq1016 qq1017 h_out h_kit h_eat h_tras h_shop h_clean h_laun memory depress nervous restless hopeless effortless meaningless/*
*/ incomea incomeb hei_sq wei qp303 qp402acode qp402bcode
save "total data\data file in process\2016adult.dta",replace
/*total sample*/
use "total data\data file in process\2016adult.dta",clear
sort fid10
merge m:m fid10 using "total data\data file in process\2016family.dta"
keep if _merge==3
drop _merge
gen head=0
replace head=1 if pid==headid
merge m:m pid fid10 using "total data\data file in process\2016spouseid.dta"
drop if _merge==1
drop _merge
save"total data\data file in process\2016paperdata.dta",replace

/*2018 data processing*/
use "total data\ecfps2018famconf_202008.dta", clear
keep fid10 pid pid_a_s
rename pid_a_s pid_s
save "total data\data file in process\2018spouseid.dta", replace
/*choose variables for family*/
use "total data\ecfps2018famecon_202101.dta", clear
keep fid10 fid12 cyear nonhousing_debts house_debts fincome2 total_asset familysize18 /*
*/ pce food dress house daily med trco eec other expense resp1pid
rename fincome2 faminc
rename familysize18 familysize
rename resp1pid headid
save "total data\data file in process\2018family.dta",replace
/*choose variables for adult*/
use "total data\data file in process\2016adult.dta", clear
keep ethn fid16
sort fid16
save"total data\data file in process\2016ethn.dta", replace
use "total data\data file in process\2016paperdata.dta", clear
sort fid12
keep fid12 childnum
save "total data\data file in process\2016childnum.dta", replace
/*# of children*/  
use "C:\Users\yajie\OneDrive\Desktop\research\CFPS data\total data\ecfps2018famconf_202008.dta",clear
gen child1=1 if code_a_c1 !=-8 & code_a_c1 !=77 & code_a_c1 !=79
replace child1=0 if child1==.
gen child2=1 if code_a_c2 !=-8 & code_a_c2 !=77 & code_a_c2 !=79
replace child2=0 if child2==.
gen child3=1 if code_a_c3 !=-8 & code_a_c3 !=77 & code_a_c3 !=79
replace child3=0 if child3==.
gen child4=1 if code_a_c4 !=-8 & code_a_c4 !=77 & code_a_c4 !=79
replace child4=0 if child4==.
gen child5=1 if code_a_c5 !=-8 & code_a_c5 !=77 & code_a_c5 !=79
replace child5=0 if child5==.
gen child6=1 if code_a_c6 !=-8 & code_a_c6 !=77 & code_a_c6 !=79
replace child6=0 if child6==.
gen child7=1 if code_a_c7 !=-8 & code_a_c7 !=77 & code_a_c7 !=79
replace child7=0 if child7==.
gen child8=1 if code_a_c8 !=-8 & code_a_c8 !=77 & code_a_c8 !=79
replace child8=0 if child8==.
gen child9=1 if code_a_c9 !=-8 & code_a_c9 !=77 & code_a_c9 !=79
replace child9=0 if child9==.
gen child10=1 if code_a_c10 !=-8 & code_a_c10 !=77 & code_a_c10 !=79
replace child10=0 if child10==.
gen childnum=child1+child2+child3+child4+child5+child6+child7+child8+child9+child10
keep fid18 childnum
save "total data\data file in process\2018childnum.dta", replace

use "total data\ecfps2018person_202012.dta", clear
keep fid10 fid18 fid16 pid provcd18 urban18 age gender qa701code cfps2018eduy_im qea0/*
*/ qg1 qp101 qp102 qp201 qp401 qp702 qq201 qq301 qq501 qn406 qn418 qn411 qn414 qn407 qn420/*
*/ xchildpid_a_1 xchildpid_a_2 xchildpid_a_3 xchildpid_a_4 xchildpid_a_5 xchildpid_a_6/*
*/ xchildpid_a_7 xchildpid_a_8 xchildpid_a_9 xchildpid_a_10 incomea incomeb qg6 qq1011/*
*/ qq1012 qq1013 qq1014 qq1015 qq1016 qq1017 qp202 qp303 qp402acode qp402bcode
sort fid18
merge m:m fid18 using "total data\data file in process\2018childnum.dta"
drop if _merge==2
drop _merge
/*province*/
rename provcd18 provcd
/*urban*/
rename urban18 urban
/*age*/
keep if age>=18 & age<=50
/*gender*/
rename gender male 
/*years of education*/
rename cfps2018eduy_im educ 
/*married*/
gen married=1 if qea0==2
replace married=0 if qea0==1| qea0==4| qea0==5| qea0==3
drop if qea0<0
/*Han ethnicity*/ 	 
sort fid16
merge m:m fid16 using "total data\data file in process\2016ethn.dta"
drop if _merge==2
replace ethn=1 if qa701code==1
replace ethn=0 if qa701code>1
drop _merge
save "total data\data file in process\2018ethn.dta",replace
/*sibling number use 2010*/
sort fid10
merge m:m fid10 using "total data\data file in process\2010sibnum.dta"
drop if _merge==2
drop _merge
/*has a job*/
rename qg1 job
replace job=1 if job==5
replace job=0 if job<0 
/*working hours per month*/
replace qg6=0 if qg<0 |qg==.
replace qg6=qg6*4
rename qg6 workhour
/*exercise per week*/
gen exercise= qp702
replace exercise=0 if qp702<0
/*personal income*/
replace incomea=0 if incomea<0 | incomea==.
replace incomeb=0 if incomeb<0 | incomeb==.
gen income= incomea +incomeb
/*whether smoke*/
rename qq201 smoke
drop if smoke<0
/*whether drink*/
rename qq301 drink
drop if drink<0
/*health index*/
/*physical health*/
/*better physical health*/
rename qp202 phy_health1
replace phy_health1=. if phy_health1<0
replace phy_health1=0 if phy_health1==3
replace phy_health1=0 if phy_health1==5
/*recent diease*/
gen sick=0
replace sick=1 if qp303==5
/*hypertension*/
gen hypertension=0
replace hypertension=1 if qp402acode=="11.66"|qp402bcode=="11.66" 
/*obesity*/
gen hei_sq=qp101^2/10000
gen wei=qp102/2
gen bmivalue=wei/hei_sq
gen obesity=0 if bmivalue<30
replace obesity=1 if bmivalue>=30
/*self evaluation health, healthy=1 or if good health<3*/
drop if qp201<0
gen self_phy_health=0
replace self_phy_health=1 if qp201<=2
rename qp201 phy_health
drop if phy_health<0
replace phy_health=1 if phy_health<=1
replace phy_health=0 if phy_health>1
/*chronic=1 */
rename qp401 chronic 
drop if chronic<0
/*body ability score*/
gen h_out=0
replace h_out=1 if qq1011==0
gen h_eat=0
replace h_eat=1 if qq1012==0
gen h_kit=0
replace h_kit=1 if qq1013==0
gen h_tras=0
replace h_tras=1 if qq1014==0
gen h_shop=0
replace h_shop=1 if qq1015==0 
gen h_clean=0
replace h_clean=1 if qq1016==0
gen h_laun=0
replace h_laun=1 if qq1017==0
gen phy_adl=0
replace phy_adl=1 if h_out==1| h_eat==1| h_kit==1|h_tras==1|h_shop==1|h_clean==1|h_laun==1
/*mental health*/
/*good memory*/
rename qq501 memory
gen good_mmy=0
replace good_mmy=1 if memory==5|memory==4
drop if memory<0
/*CES-D mental score high= unhealthy*/
rename qn406 depress
rename qn418 nervous
rename qn411  restless
rename qn414 hopeless
rename qn407 effortless
rename qn420 meaningless
drop if depress<0
drop if nervous<0
drop if restless<0
drop if hopeless<0
drop if effortless<0
drop if meaningless<0
replace depress=0 if depress==4
replace depress=4 if depress==3
replace depress=3 if depress==1
replace depress=1 if depress==4
replace nervous=0 if nervous==4
replace nervous=4 if nervous==3
replace nervous=3 if nervous==1
replace nervous=1 if nervous==4
replace restless=0 if restless==4
replace restless=4 if restless==3
replace restless=3 if restless==1
replace restless=1 if restless==4
replace hopeless=0 if hopeless==4
replace hopeless=4 if hopeless==3
replace hopeless=3 if hopeless==1
replace hopeless=1 if hopeless==4
replace effortless=0 if effortless==4
replace effortless=4 if effortless==3
replace effortless=3 if effortless==1
replace effortless=1 if effortless==4
replace meaningless=0 if meaningless==4
replace meaningless=4 if meaningless==3
replace meaningless=3 if meaningless==1
replace meaningless=1 if meaningless==4
gen mental_score=depress + nervous + hopeless + restless + effort + meaningless
/*depression 抑郁*/
gen depression=0 if mental_score>12
replace depression=1 if mental_score<=12
drop qea0 qa701code qp702 qp101 qp102 qq1011 qq1012 qq1013 qq1014/*
*/ xchildpid_a_1 xchildpid_a_2 xchildpid_a_3 xchildpid_a_4 xchildpid_a_5 xchildpid_a_6/*
*/ xchildpid_a_7 xchildpid_a_8 xchildpid_a_9 xchildpid_a_10 qq1015 qq1016 qq1017 h_out/* 
*/ h_kit h_eat h_tras h_shop h_clean h_laun memory depress nervous restless hopeless effortless meaningless/*
*/ incomea incomeb hei_sq wei qp303 qp402acode qp402bcode
save "total data\data file in process\2018adult.dta",replace
/*total sample*/
use "total data\data file in process\2018adult.dta",clear
sort fid10
merge m:m fid10 using "total data\data file in process\2018family.dta"
keep if _merge==3
drop _merge
gen head=0
replace head=1 if pid==headid
merge m:m pid fid10 using "total data\data file in process\2018spouseid.dta"
drop if _merge==1
drop _merge
save"total data\data file in process\2018paperdata.dta",replace

/*2020 data processing*/
use "total data\ecfps2020famconf_202306.dta", clear
keep fid10 pid pid_a_s
rename pid_a_s pid_s
save "total data\data file in process\2020spouseid.dta", replace
/*choose variables for family*/
use "total data\ecfps2020famecon_202306.dta", clear
keep fid10 fid12 cyear nonhousing_debts house_debts fincome1 total_asset familysize20 /*
*/ pce food dress house daily med trco eec other expense resp1pid
rename fincome1 faminc
rename familysize20 familysize
rename resp1pid headid
save "total data\data file in process\2020family.dta",replace
/*choose variables for adult*/
use "total data\data file in process\2018adult.dta", clear
keep ethn fid18
sort fid18
save"total data\data file in process\2018ethn.dta", replace
use "total data\data file in process\2018paperdata.dta", clear
sort fid12
keep fid12 childnum
save "total data\data file in process\2018childnum.dta", replace
/*# of children*/  
use "C:\Users\yajie\OneDrive\Desktop\research\CFPS data\total data\ecfps2020famconf_202306.dta",clear
gen child1=1 if code_a_c1 !=-8 & code_a_c1 !=77 & code_a_c1 !=79
replace child1=0 if child1==.
gen child2=1 if code_a_c2 !=-8 & code_a_c2 !=77 & code_a_c2 !=79
replace child2=0 if child2==.
gen child3=1 if code_a_c3 !=-8 & code_a_c3 !=77 & code_a_c3 !=79
replace child3=0 if child3==.
gen child4=1 if code_a_c4 !=-8 & code_a_c4 !=77 & code_a_c4 !=79
replace child4=0 if child4==.
gen child5=1 if code_a_c5 !=-8 & code_a_c5 !=77 & code_a_c5 !=79
replace child5=0 if child5==.
gen child6=1 if code_a_c6 !=-8 & code_a_c6 !=77 & code_a_c6 !=79
replace child6=0 if child6==.
gen child7=1 if code_a_c7 !=-8 & code_a_c7 !=77 & code_a_c7 !=79
replace child7=0 if child7==.
gen child8=1 if code_a_c8 !=-8 & code_a_c8 !=77 & code_a_c8 !=79
replace child8=0 if child8==.
gen child9=1 if code_a_c9 !=-8 & code_a_c9 !=77 & code_a_c9 !=79
replace child9=0 if child9==.
gen child10=1 if code_a_c10 !=-8 & code_a_c10 !=77 & code_a_c10 !=79
replace child10=0 if child10==.
gen childnum=child1+child2+child3+child4+child5+child6+child7+child8+child9+child10
keep fid20 childnum
save "total data\data file in process\2020childnum.dta", replace
use "total data\ecfps2020person_202306.dta", clear
keep fid10 fid18 fid20 pid provcd20 urban20 age gender qa701code cfps2020eduy_im qea0/*
*/ qg1 qp101 qp102 qp201 qp401 qp702n qq201 qq301 qq501 qn406 qn418 qn411 qn414 qn407 qn420/*
*/ xchildpid_a_1 xchildpid_a_2 xchildpid_a_3 xchildpid_a_4 xchildpid_a_5 xchildpid_a_6/*
*/ xchildpid_a_7 xchildpid_a_8 incomea incomeb qg6 qq1011/*
*/ qq1012 qq1013 qq1014 qq1015 qq1016 qq1017 qp202 qp303 qp402acode qp402bcode 
sort fid20
merge m:m fid20 using "total data\data file in process\2020childnum.dta"
drop if _merge==2
drop _merge
/*province*/
rename provcd20 provcd
/*urban*/
rename urban20 urban
/*age*/
keep if age>=18 & age<=50
/*gender*/
rename gender male 
/*years of education*/
rename cfps2020eduy_im educ 
/*married*/
gen married=1 if qea0==2
replace married=0 if qea0==1| qea0==4| qea0==5| qea0==3
drop if qea0<0
/*Han ethnicity*/ 	 
sort fid18
merge m:m fid18 using "total data\data file in process\2018ethn.dta"
drop if _merge==2
replace ethn=1 if qa701code==1
replace ethn=0 if qa701code>1
drop _merge  
/*sibling number use 2010*/
sort fid10
merge m:m fid10 using "total data\data file in process\2010sibnum.dta"
drop if _merge==2
drop _merge
/*has a job*/
rename qg1 job
replace job=1 if job==5
replace job=0 if job<0 
/*working hours per month*/
replace qg6=0 if qg<0 |qg==.
replace qg6=qg6*4
rename qg6 workhour
/*exercise per week*/
gen exercise= qp702n/60
replace exercise=0 if qp702n<0
/*personal income*/
replace incomea=0 if incomea<0 | incomea==.
replace incomeb=0 if incomeb<0 | incomeb==.
gen income= incomea +incomeb
/*whether smoke*/
rename qq201 smoke
drop if smoke<0
/*whether drink*/
rename qq301 drink
drop if drink<0
/*health index*/
/*physical health*/
/*better physical health*/
rename qp202 phy_health1
replace phy_health1=. if phy_health1<0
replace phy_health1=0 if phy_health1==3
replace phy_health1=0 if phy_health1==5
/*recent diease*/
gen sick=0
replace sick=1 if qp303==5
/*hypertension*/
gen hypertension=0
replace hypertension=1 if qp402acode=="11.66"|qp402bcode=="11.66" 
/*obesity*/
gen hei_sq=qp101^2/10000
gen wei=qp102/2
gen bmivalue=wei/hei_sq
gen obesity=0 if bmivalue<30
replace obesity=1 if bmivalue>=30
/*self evaluation health, healthy=1 or if good health<3*/
drop if qp201<0
gen self_phy_health=0
replace self_phy_health=1 if qp201<=2	 
rename qp201 phy_health
drop if phy_health<0
replace phy_health=1 if phy_health<=1
replace phy_health=0 if phy_health>1
/*chronic=1 */
rename qp401 chronic 
drop if chronic<0
/*body ability score*/
gen h_out=0
replace h_out=1 if qq1011==0
gen h_eat=0
replace h_eat=1 if qq1012==0
gen h_kit=0
replace h_kit=1 if qq1013==0
gen h_tras=0
replace h_tras=1 if qq1014==0
gen h_shop=0
replace h_shop=1 if qq1015==0
gen h_clean=0
replace h_clean=1 if qq1016==0
gen h_laun=0
replace h_laun=1 if qq1017==0
gen phy_adl=0
replace phy_adl=1 if h_out==1| h_eat==1| h_kit==1|h_tras==1|h_shop==1|h_clean==1|h_laun==1
/*mental health*/
/*good memory*/
rename qq501 memory
gen good_mmy=0
replace good_mmy=1 if memory==4|memory==5
drop if memory<0
/*CES-D mental score high= unhealthy*/
rename qn406 depress
rename qn418 nervous
rename qn411  restless
rename qn414 hopeless
rename qn407 effortless
rename qn420 meaningless
drop if depress<0
drop if nervous<0
drop if restless<0
drop if hopeless<0
drop if effortless<0
drop if meaningless<0
replace depress=0 if depress==4
replace depress=4 if depress==3
replace depress=3 if depress==1
replace depress=1 if depress==4
replace nervous=0 if nervous==4
replace nervous=4 if nervous==3
replace nervous=3 if nervous==1
replace nervous=1 if nervous==4
replace restless=0 if restless==4
replace restless=4 if restless==3
replace restless=3 if restless==1
replace restless=1 if restless==4
replace hopeless=0 if hopeless==4
replace hopeless=4 if hopeless==3
replace hopeless=3 if hopeless==1
replace hopeless=1 if hopeless==4
replace effortless=0 if effortless==4
replace effortless=4 if effortless==3
replace effortless=3 if effortless==1
replace effortless=1 if effortless==4
replace meaningless=0 if meaningless==4
replace meaningless=4 if meaningless==3
replace meaningless=3 if meaningless==1
replace meaningless=1 if meaningless==4
gen mental_score=depress + nervous + hopeless + restless + effort + meaningless
/*depression 抑郁*/
gen depression=0 if mental_score>12
replace depression=1 if mental_score<=12
drop qea0 qa701code qp702n qp101 qp102 qq1011 qq1012 qq1013 qq1014/*
*/ xchildpid_a_1 xchildpid_a_2 xchildpid_a_3 xchildpid_a_4 xchildpid_a_5 xchildpid_a_6/*
*/ xchildpid_a_7 xchildpid_a_8 qq1015 qq1016 qq1017 h_out/* 
*/ h_kit h_eat h_tras h_shop h_clean h_laun memory depress nervous restless hopeless effortless meaningless/*
*/ incomea incomeb hei_sq wei  qp303 qp402acode qp402bcode
save "total data\data file in process\2020adult.dta",replace
/*total sample*/
use "total data\data file in process\2020adult.dta",clear
sort fid10
merge m:m fid10 using "total data\data file in process\2020family.dta"
keep if _merge==3
drop _merge
gen head=0
replace head=1 if pid==headid
merge m:m pid fid10 using "total data\data file in process\2020spouseid.dta"
drop if _merge==1
drop _merge
save"total data\data file in process\2020paperdata.dta",replace


/*append data*/
/*2010,2012,2014,2016,2018,2020 append data*/
use "total data\data file in process\2012paperdata.dta", clear
append using "total data\data file in process\2014paperdata.dta"
append using "total data\data file in process\2016paperdata.dta"
append using "total data\data file in process\2018paperdata.dta"
append using "total data\data file in process\2020paperdata.dta"
save "total data\data file in process\paperdata.dta",replace
use "total data\data file in process\paperdata.dta", clear
drop if urban<0
drop if educ<0
drop if childnum<0
drop if male<0
replace bmivalue=. if bmivalue<0
replace bmivalue=. if bmivalue>60
drop if mental_score<0
drop if total_asset<0
drop obesity
gen obesity=0
replace obesity=1 if bmivalue>=30
keep if married==1
replace cyear=2012 if cyear==2011
replace cyear=2014 if cyear==2013
replace cyear=2016 if cyear==2015
replace cyear=2018 if cyear==2017
replace cyear=2020 if cyear==2019
save "total data\data file in process\modpaperdata.dta", replace
/*keep spouse*/
*use"total data\data file in process\modpaperdata.dta", clear
keep fid10 pid_s
rename pid_s pid
save "total data\data file in process\spouseid.dta", replace
use"total data\data file in process\modpaperdata.dta", clear
merge m:m fid10 pid using "total data\data file in process\spouseid.dta"
keep if _merge==3
rename _merge _spouse
gen t2014=1 if cyear==2014| cyear==2016| cyear==2018| cyear==2020
replace t2014=0 if cyear==2010| cyear==2012
gen t2016=1 if cyear==2016| cyear==2018| cyear==2020
replace t2016=0 if cyear==2010| cyear==2012| cyear==2014
gen t2012=1 if cyear==2012| cyear==2014| cyear==2016| cyear==2018| cyear==2020
replace t2012=0 if cyear==2010
gen t2018=1 if cyear==2018| cyear==2020
replace t2018=0 if cyear==2010| cyear==2012| cyear==2014| cyear==2016
gen t2020=1 if cyear==2020
replace t2020=0 if cyear==2010| cyear==2012| cyear==2014| cyear==2016| cyear==2018
/*2014 group*/
sort pid
merge m:m pid using "total data\data file in process\2014 group.dta"
drop if _merge==2
drop _merge 
duplicates drop fid10 pid cyear, force
/*drop sibling*/
gen no_sibling = (sibnum==0)
bysort fid10: egen has_no_sibling = max(no_sibling)
keep if has_no_sibling == 0
/*urban/rural*/
gen treat1=t2016*urban
gen ptreat1=t2012*urban
*ethn*/
gen treat2=t2016*ethn
gen ptreat2=t2012*ethn
/*age*/
gen age40=1
replace age40=0 if age>=40
gen treat3=t2016*onekid
gen ptreat3=t2012*onekid
gen ptreat314=t2014*onekid
gen ptreat318=t2018*onekid
gen ptreat320=t2020*onekid
save "total data\data file in process\fixpaperdata2.dta", replace
/*summry statistics*/
drop if mental_score==.
drop if ethn==.
drop if edu==.
drop if med==.
drop if income==.
drop if mental_score==19
drop if childnum1==0
replace income=income/10000
replace med = med/10000
replace total_asset=total_asset/10000
drop if cyear==2014 & childnum==0
drop if onekid==.
/*drop if total_asset==.*/
sum phy_health mental_score treat3 t2016 onekid ethn urban age educ income head med childnum if male==0
sum phy_health mental_score treat3 t2016 onekid ethn urban age educ income head med childnum if male==1
logout, save(sum1) excel replace: sum phy_health self_phy_health mental_score t2016 onekid ethn urban age educ income total_asset head med childnum if male==1 & cyear==2014 
logout, save(sum2) excel replace: sum phy_health self_phy_health mental_score t2016 onekid ethn urban age educ income total_asset head med childnum if male==0 & cyear==2014
/*graph for onekid*/
ssc install lgraph
preserve
keep if male==0
collapse (mean) self_phy_health, by(cyear onekid)
lgraph self_phy_health cyear, by(onekid) xline(2016)
restore
/*drop if childnum==0*/
ssc install lgraph
preserve
keep if male==0 
collapse (mean) mental_score, by(cyear onekid)
lgraph mental_score cyear, by(onekid) xline(2016)
restore
/*graph for urban*/
ssc install lgraph
preserve
keep if male==0
collapse (mean) phy_health, by(cyear onekid)
lgraph phy_health cyear, by(onekid) xline(2016)
restore
ssc install lgraph
preserve
keep if male==0
collapse (mean) mental_score, by(cyear onekid)
lgraph mental_score cyear, by(onekid) xline(2016)
restore
/*fertility baseline*/
*childnum*/
duplicates drop fid10 pid cyear, force
xtset pid cyear
xtreg childnum t2016 if male==0,fe
est sto ch1
xtreg childnum t2016 i.provcd i.cyear if male==0,fe
est sto ch2
xtreg childnum t2016 age i.provcd i.cyear if male==0, fe
est sto ch3
xtreg childnum t2016 age educ urban ethn house_debts nonhousing_debts total_asset faminc i.provcd i.cyear if male==0, fe
est sto ch4
esttab ch1 ch2 ch3 ch4 using "childnum.rtf", se replace b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) stats(r2 N, labels("R-squared" "Observations")) ///
title("Regression Results") label
/*herterogenetiy*/
gen age45=0
replace age45=1 if age>=45
gen t_age40= t2016*age40
xtset pid cyear
xtreg childnum t_age40 t2016 age40 educ urban ethn house_debts nonhousing_debts total_asset faminc   i.provcd i.cyear if male==0, fe
est sto ch4
gen t_job =t2016*job
xtreg childnum t_job t2016 job age educ urban ethn house_debts nonhousing_debts total_asset faminc   i.provcd i.cyear if male==0, fe
est sto ch5
gen t_head=t2016*head
xtreg childnum t_head t2016 head age educ urban ethn house_debts nonhousing_debts total_asset faminc   i.provcd i.cyear if male==0, fe
est sto ch6
esttab ch4 ch5 ch6 using "heterchild.rtf", se replace b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) stats(r2 N, labels("R-squared" "Observations")) ///
title("Table 3") label
/*onekid baseline*/
duplicates drop fid10 pid cyear, force
xtset pid cyear
xtreg self_phy_health t2016 treat3 onekid if male==0, r
est store ob1
xtreg self_phy_health t2016 treat3 onekid i.provcd if male==0, fe
est store ob2
xtreg self_phy_health t2016 treat3 onekid age educ income urban/*
*/ ethn childnum i.provcd if male==0, fe
est store ob3
xtreg mental_score t2016 treat3 onekid if male==0, r
est store ob4
xtreg mental_score t2016 treat3 onekid i.provcd if male==0, fe
est store ob5
xtreg mental_score t2016 treat3 onekid age educ income urban/*
*/ ethn childnum i.provcd if male==0,fe
est store ob6
esttab ob1 ob2 ob3 ob4 ob5 ob6 using "basepanel.rtf", se replace b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) stats(r2 N, labels("R-squared" "Observations")) ///
title("Table 3") label
/*onekid male*/
xtreg phy_health t2016 treat3 onekid if male==1,r
est store mob1
xtreg phy_health t2016 treat3 onekid i.provcd if male==1,fe
est store mob2
xtreg phy_health t2016 treat3 onekid age educ income urban/*
*/ ethn i.provcd if male==1,fe
est store mob3
xtreg mental_score t2016 treat3 onekid if male==1,r
est store mob4
xtreg mental_score t2016 treat3 onekid i.provcd if male==1,fe
est store mob5
xtreg mental_score t2016 treat3 onekid age educ income urban/*
*/ ethn childnum i.provcd if male==1,fe
est store mob6
esttab mob1 mob2 mob3 mob4 mob5 mob6 using "basemen.rtf", se replace b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) stats(r2 N, labels("R-squared" "Observations")) ///
title("Table 5") label
/*parallel*/
xtreg childnum t2014 ptreat314 onekid age income educ urban/*
*/  ethn i.provcd  if male==0, fe
est store pap1
xtreg self_phy_health t2014 ptreat314 onekid age income educ urban/*
*/  ethn familysize i.provcd if male==0, fe
est store pap2
xtreg mental_score t2014 ptreat314 onekid age income educ urban/*
*/ ethn childnum i.provcd if male==0, fe
est store pap3
esttab pap2 pap3 using "parallel.rtf", se replace b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) stats(r2 N, labels("R-squared" "Observations")) ///
title("Table 6") label
/*heterogenity*/
/*age*/
gen age40=0
replace age40=1 if age>=40
gen treat_age=treat3*age40
gen kid_age= onekid*age40
gen t_age= t2016*age40
xtreg self_phy_health treat_age treat3 kid_age t_age t2016 onekid income educ urban/*
*/  ethn childnum i.provcd if male==0, fe
est store h1p
xtreg mental_score treat_age treat3 kid_age t_age t2016 onekid income educ urban/*
*/ ethn childnum i.provcd if male==0, fe
est store h2p
/*job*/
gen treat_job=treat3*job
gen kid_job= onekid*job
gen t_job= t2016*job
xtreg mental_score treat_job treat3 kid_job t_job t2016 onekid job age educ urban/*
*/ ethn childnum i.provcd if male==0, fe
est store h4p
xtreg phy_health treat_job treat3 kid_job t_job t2016 onekid job age educ urban/*
*/ ethn childnum i.provcd if male==0, fe
est store h3p
/*household head*/
gen treat_head=treat3*head
gen kid_head=onekid*head
gen t_head=t2016*head
xtreg self_phy_health treat_head treat3 kid_head t_head head t2016 onekid age educ urban/*
*/ ethn childnum i.provcd if male==0, fe
est store h5p
xtreg mental_score treat_head treat3 kid_head t_head t2016 onekid job age educ urban/*
*/ ethn childnum i.provcd if male==0, fe
est store h6p 
esttab h1p h2p h3p h4p h5p h6p using "heterp1.rtf", se replace b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) stats(r2 N, labels("R-squared" "Observations")) ///
title("Table 7") label
/*mechinism*/
/*direct effects and indirect effects*/
gen treat_male= treat3*male
gen kid_male = onekid*male
gen t_male= t2016*male
xtreg phy_health treat_male kid_male t_male male t2016 onekid age educ urban/*
*/ ethn childnum i.provcd , fe
est store h5p
xtreg mental_score treat_male kid_male t_male male t2016 onekid job age educ urban/*
*/ ethn childnum i.provcd , fe
est store h6p 
xtreg phy_health t2016 treat3 onekid if male==1, r
est store ob1
xtreg phy_health t2016 treat3 onekid i.provcd if male==1, fe
est store ob2
xtreg phy_health t2016 treat3 onekid age educ income urban/*
*/ ethn i.provcd i.cyear if male==1, fe
est store ob3
xtreg mental_score t2016 treat3 onekid if male==1, r
est store ob4
xtreg mental_score t2016 treat3 onekid i.provcd if male==1, fe
est store ob5
xtreg mental_score t2016 treat3 onekid age educ income urban/*
*/ ethn i.provcd if male==1,fe
est store ob6
esttab ob1 ob2 ob3 ob4 ob5 ob6 using male1.rft,star(* 0.1 ** 0.05 *** 0.01) replace
/*drink/smoke*/
xtreg drink t2016 treat3 onekid age  income educ urban/*
*/ ethn childnum i.provcd if male==0, fe
est store me1p
xtreg smoke t2016 treat3 onekid age  income educ urban/*
*/  ethn childnum i.provcd if male==0, fe
est store me2p
/*medical expense*/
xtreg med t2016 treat3 onekid age income educ urban/*
*/  ethn childnum i.provcd if male==0, fe
est store me3p
/*income*/
xtreg job t2016 treat3 onekid age educ urban/*
*/  ethn childnum i.provcd if male==0, fe
est store me4p
/*hypertension*/
xtreg hypertension t2016 treat3 onekid age educ urban/*
*/  ethn childnum i.provcd if male==0, fe
est store me5p
/*childnum*/
xtreg childnum t2016 treat3 onekid age educ urban/*
*/  ethn  i.provcd i.cyear if male==0, fe
est store me6p
esttab me1p me2p me3p me4p me5p me6p using "mechinism.rtf", se replace b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) stats(r2 N, labels("R-squared" "Observations")) ///
title("Table 8") label
/**/
/*long-term effect*/
xtreg childnum ptreat314 treat3 ptreat318 ptreat320 t2014 t2016 t2018 t2020 onekid age income educ urban total_asset/*
*/  ethn i.provcd if male==0, fe
est sto pl3
coefplot pl3, keep(ptreat314 treat3 ptreat318 ptreat320) vertical recast(connect) yline(0) xline(2,lp(dash))/*
*/ coeflabels(ptreat314=2014 treat3=2016 ptreat318=2018 ptreat320=2020) ytitle("Children Number") xtitle("Year")
xtreg self_phy_health ptreat314 treat3 ptreat318 ptreat320 t2014 t2016 t2018 t2020 onekid age income educ urban total_asset/*
*/  ethn childnum i.provcd if male==0, fe
est sto pl1
coefplot pl1, keep(ptreat314 treat3 ptreat318 ptreat320) vertical recast(connect) yline(0) xline(2,lp(dash))/*
*/ coeflabels(ptreat314=2014 treat3=2016 ptreat318=2018 ptreat320=2020) ytitle("Physical Health") xtitle("Year")
xtreg mental_score ptreat314 treat3 ptreat318 ptreat320 t2014 t2016 t2018 t2020 onekid age income educ urban total_asset/*
*/  ethn i.provcd if male==0, fe
est sto pl2
coefplot pl2, keep(ptreat314 treat3 ptreat318 ptreat320) vertical recast(connect) yline(0) xline(2,lp(dash))/*
*/ coeflabels(ptreat314=2014 treat3=2016 ptreat318=2018 ptreat320=2020) ytitle("Mental Health") xtitle("Year")
esttab pl1 pl2 using "long.rtf", se replace b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) stats(r2 N, labels("R-squared" "Observations")) ///
title("Table 9") label
/*robustness*/
duplicates drop fid10 pid cyear, force
xtset pid cyear
 xtreg phy_health t2016 treat3 onekid if male==0, r
est store ob1
xtreg phy_health t2016 treat3 onekid childnum i.provcd if male==0, fe
est store ob2
xtreg phy_health t2016 treat3 onekid age educ income urban/*
*/ ethn childnum i.provcd if male==1, fe
est store rob1
xtreg mental_score t2016 treat3 onekid if male==0, r
est store ob4
xtreg mental_score t2016 treat3 onekid i.provcd if male==0, fe
est store ob5
xtreg mental_score t2016 treat3 onekid age educ income urban/*
*/ ethn childnum i.provcd if male==1,fe
est store rob2 
esttab ob1 ob2 ob3 ob4 ob5 ob6 using basepanel.rft,star(* 0.1 ** 0.05 *** 0.01) replace
drop if cyear==2020
xtreg phy_health t2016 treat3 onekid if male==0, r
est store ob1
xtreg phy_health t2016 treat3 onekid i.provcd if male==0, fe
est store ob2
xtreg phy_health t2016 treat3 onekid age educ income urban/*
*/ ethn childnum i.provcd if male==0, fe
est store rob3
xtreg mental_score t2016 treat3 onekid if male==0, r
est store ob4
xtreg mental_score t2016 treat3 onekid i.provcd if male==0, fe
est store ob5
xtreg mental_score t2016 treat3 onekid age educ income urban/*
*/ ethn childnum i.provcd if male==0,fe
est store rob4
esttab rob1 rob2 rob3 rob4 using "robust.rtf", se replace b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) stats(r2 N, labels("R-squared" "Observations")) ///
title("Table 9") label






