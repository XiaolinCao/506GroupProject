* Import and merge ------------------------------------------------------------
pwd
cd C:\Users\xiaolc\Downloads
pwd

// response variables
// diabetes
fdause DIQ_I.XPT, clear
quietly compress
gsort +seqn
keep seqn diq010
save DIABETES.dta, replace

// predicting variables
// gender, age
fdause DEMO_I.XPT, clear
quietly compress
gsort +seqn
keep seqn riagendr ridageyr
merge 1:1 seqn using DIABETES.dta

keep if _merge == 3
save DIA_DEMO.dta, replace

// alcohol
fdause ALQ_I.XPT, clear
quietly compress
gsort +seqn
keep seqn alq130
merge 1:1 seqn using DIA_DEMO.dta, generate(merge2)

keep if merge2 == 3
save DIA_DEMO_ALC.dta, replace

// total sugars, total fat
fdause DR1TOT_I.XPT
quietly compress
gsort +seqn
keep seqn dr1tsugr dr1ttfat
merge 1:1 seqn using DIA_DEMO_ALC.dta, generate(merge3)

keep if merge3 == 3
save DIA_DEMO_ALC_NUTR.dta, replace

// occupation
fdause OCQ_I.XPT, clear
quietly compress
gsort +seqn
keep seqn ocq260
merge 1:1 seqn using DIA_DEMO_ALC_NUTR.dta, generate(merge4)

keep if merge4 == 3
save DIA_DEMO_ALC_NUTR_OCU.dta, replace

// sleep disorder
fdause SLQ_I.XPT
quietly compress
gsort +seqn
keep seqn sld012
merge 1:1 seqn using DIA_DEMO_ALC_NUTR_OCU.dta, generate(merge5)

keep if merge5 == 3
save dataset.dta, replace

rename sld012 sleep
rename ocq260 occupation
rename dr1tsugr tot_sugr
rename dr1ttfat tot_fat
rename alq130 alcohol
rename riagendr gender
rename ridageyr age
rename diq010 diabete

// recode diabete: 0: no diabete, 1: has diabete
replace diabete = 0 if diabete == 2

// recode occupation: 1: private business employee
//					  2: government employee
//					  3: self-employed
replace occupation = 2 if (occupation == 2 | occupation == 3 | occupation == 4)
replace occupation = 3 if occupation == 5

// remove missing values and unqualified values
generate missing = 0
replace missing = 1 if (seqn == . | diabete == 3 | diabete == 7 | diabete == 9 | diabete == . | age == . | gender == . | alcohol == 777 | alcohol == 999 | alcohol == . | tot_fat == . | tot_sugr == . | occupation == 6 | occupation == 77 | occupation == 99 | occupation == . | sleep == .)
drop if missing == 1

// fit the logistic model
logit diabete age i.gender alcohol tot_fat tot_sugr i.occupation sleep, or
matrix model = r(table)

mata
model = st_matrix("model")
model = round(model[(1, 2, 5, 6), (1, 3, 4, 5, 6, 8, 9, 10)], 0.001)
model = model'
st_matrix("final_model", model)
end

putexcel set 506project_res.csv, replace
putexcel A2 = "age"
putexcel A3 = "2.gender"
putexcel A4 = "alcohol"
putexcel A5 = "tot_fat"
putexcel A6 = "tot_sugr"
putexcel A7 = "2.occupation"
putexcel A8 = "3.occupation"
putexcel A9 = "sleep"
putexcel B1 = "est"
putexcel C1 = "se"
putexcel D1 = "lwr"
putexcel E1 = "upr"
putexcel B2 = matrix(final_model)

putexcel save













