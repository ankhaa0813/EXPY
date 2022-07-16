use "C:\Users\Ankhaa\Documents\ADB trade\Stata\benchmark1.dta", clear
drop var1

set obs 48180000
gen year=int(((_n)-1)/2190000)+1995
gen c=mod(((_n)-1),219)+1
sort year c
gen product=mod(((_n)-1),10000)+1
sort year c product 
save "C:\Users\Ankhaa\Documents\ADB trade\Stata\base1.dta", replace
merge m:m product using "C:\Users\Ankhaa\Documents\ADB trade\Stata\HS-4digit.dta"
drop if _merge==1
drop _merge
save "C:\Users\Ankhaa\Documents\ADB trade\Stata\base2.dta", replace
merge m:m c using "C:\Users\Ankhaa\Documents\ADB trade\Stata\C.dta"
drop _merge
save "C:\Users\Ankhaa\Documents\ADB trade\Stata\base25.dta", replace
sort year count product
merge m:m year count using "C:\Users\Ankhaa\Documents\ADB trade\Stata\GDP.dta"
drop if gdpp==.
drop if _merge==2
sort year count product
drop _merge
merge m:m year count product using "C:\Users\Ankhaa\Documents\ADB trade\Stata\data_0515_2.dta"
drop _merge
drop if gdpp==.
save "C:\Users\Ankhaa\Documents\ADB trade\Stata\base5.dta", replace
*Calculating PRODY
prody using prody_0516_check, trade(value) gdp(gdpp) time(year) prod(product) id(count) bal(strong)
merge m:m year product using "C:\Users\Ankhaa\Documents\\prody_0516_check.dta", keep(match) nogen 
expy using expy_0516_check , trade(value) prody(prody_tvar) id(count) product(product) time(year) replace
save "C:\Users\Ankhaa\Documents\ADB trade\Stata\PERFECT.dta", replace

*Nonmining EXPY 
keep if 2500>product | 2799<product
*Calculating EXPY
expy using expy_0515_NM , trade(value) prody(prody_tvar) id(count) product(product) time(year) replace





drop if _merge==2
su value 
replace value=0 if value==.
su value 


merge m:m year c product using "C:\Users\Ankhaa\Documents\ADB trade\Stata\data1212.dta"
drop _merge
merge m:m c using "C:\Users\Ankhaa\Documents\ADB trade\Stata\C.dta"
drop if value==.
sort year country product
drop _merge 
merge m:m year country using "C:\Users\Ankhaa\Documents\ADB trade\Stata\GDP.dta"
drop if gdpp==.
drop _merge
save "C:\Users\Ankhaa\Documents\ADB trade\Stata\output12.dta", replace
prody using prody1_output, trade(value) gdp(gdpp) time(year)  prod(product) id(country) bal(strong)



use data_expy, clear
egen country1=group(country)
list country country1  in 1/10, sepby(country)
xtset country1 year
table country year if country1==117, contents(sum expy )
table country year if country1==174, contents(sum expy )
table country year if country1==34, contents(sum expy )


rca value,  j(c) m(product)index(BRCA) by(year)


