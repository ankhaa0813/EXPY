clear
set obs 2016
gen a=_n
forvalues i = 1995/2016 {
use "C:\Users\Ankhaa\Documents\ADB trade\Open forest\prody_0515.dta", clear
keep if year==`i'
drop year
save "C:\Users\Ankhaa\Documents\ADB trade\Open forest\p`i'.dta", replace 

use "C:\Users\Ankhaa\Documents\ADB trade\Open forest\prody_0515.dta", clear
keep if year==`i'
drop year
rename prody prody2
rename product1 product2 
save "C:\Users\Ankhaa\Documents\ADB trade\Open forest\pp`i'.dta", replace 

use "C:\Users\Ankhaa\Documents\ADB trade\Stata\PERFECT.dta", clear
keep if year==`i'
rca value, j(count) m(product) index(BRCA)
keep if c==193
rename  value_brca rca 
rename product product2
list count product2 rca in 1/10
rename  prody_tvar prody
keep product2 gdpp value year rca 

save "C:\Users\Ankhaa\Documents\ADB trade\Open forest\r`i'.dta", replace 

use "C:\Users\Ankhaa\Documents\ADB trade\Open forest\r`i'.dta", clear
rename rca rca1
rename product2 product1
rename value value2 
keep product1 rca1 value2
save "C:\Users\Ankhaa\Documents\ADB trade\Open forest\r`i'1.dta", replace 

clear
use "C:\Users\Ankhaa\Documents\ADB trade\Stata\benckmark2.dta", clear
drop var1

set obs 1690000

gen product=int(((_n)-1)/1300)+1
gen product2=mod(((_n)-1),1300)+1
save "C:\Users\Ankhaa\Documents\ADB trade\Stata\open forest.dta", replace
merge m:m product using "C:\Users\Ankhaa\Documents\ADB trade\Open forest\pcos.dta"
drop if _merge==1
rename var2 product1
drop product
drop _merge
rename product2 product
merge m:m product using "C:\Users\Ankhaa\Documents\ADB trade\Open forest\pcos.dta"
sort product1 var2
drop if _merge==1
rename var2 product2
drop _merge
drop product
merge m:m product1 product2 using "C:\Users\Ankhaa\Documents\ADB trade\Open forest\proxi.dta"
drop if _merge==1
drop _merge
merge m:m product2 using "C:\Users\Ankhaa\Documents\ADB trade\Open forest\r`i'.dta"
drop _merge
merge m:m product1 using "C:\Users\Ankhaa\Documents\ADB trade\Open forest\p`i'.dta"
drop _merge
merge m:m product2 using "C:\Users\Ankhaa\Documents\ADB trade\Open forest\pp`i'.dta"
drop _merge
merge m:m product1 using "C:\Users\Ankhaa\Documents\ADB trade\Open forest\r`i'1.dta"
replace rca=0 if rca==.
gen prox=proximity if rca>=1
sort product1 product2
by product1: egen dens1=total(prox)
by product1: egen density1=total(proximity)
gen density=dens1/density1
gen openf=prody*density if rca1<1

gen prox2=proximity if rca1<1
gen stata1=prox2/density1
gen stata2=stata1*prody2 if rca<1

by product1: egen strategy=total(stata2)

*mongoliin exportolson baraanii too tsuun uchir baga garna
save "C:\Users\Ankhaa\Documents\ADB trade\Open forest\OF`i'.dta", replace

drop  product2  rca prox _merge value proximity prox2 stata1 stata2 prody2
duplicates drop product1 year gdpp prody rca1 dens1 density1 density openf strategy value2, force
drop if year==.
 export excel using "Open_forest tjk", sheet("`i'")  firstrow(variables)


	}

forvalues i = 1(1)100 {
          2.       generate x`i' = runiform()
          3. }
