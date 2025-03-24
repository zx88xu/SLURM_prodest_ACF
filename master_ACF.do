********************************************************************************************************************************
************************************************ Estimating Production Function using LP+ACF  
********************************************************************************************************************************
 
* logic of the code: 

* 0. loop over run_num from  1 to 1720:

*    get mod(run_num, 86) to figure out which sectoral data I need to load in.  
*    get (run_num-mod(run_num, 86))/86 to figure out which seed I would use.

*              Note I use the seeds from 1-20 , this is for the purpose of GMM initialization.

* 1. loop over sec_num from 1 to 86, within each sec_num, loop over 20 random seed  

* 2. within each sec_num + random seed pair, we call the local ado file "prodest_ACF" 100 times and take the minimum in GMM and save the results as  "postest_sector_`sec_num'_seed_`seed_num'"



*define globals

global SERVER_ANALYSIS_DATA = "/home/zx88/Documents/server_sector_data"
global SERVER_POSTEST_DATA = "/home/zx88/Documents/server_postest_sector_data"

 

*local total_runs = 1720

local run_num = "`1'" 

 

local   sec_num    =   mod(`run_num' − 1, 86) + 1
local   seed_num   =   floor((`run_num' − 1)/86) + 1

   
use  "$SERVER_ANALYSIS_DATA/superslim_`sec_num'.dta", clear

 set seed `seed_num'

   
gen res_sqd=100

gen elast_wl_NTV = .
gen elast_mat_NTV = .
gen elast_k_NTV = .
gen elast_share4_NTV = .
gen elast_share3_NTV = .

local current_min_res = 100


forvalues i = 1/100 {
	
	
 prodest_ACF log_s_KLEMS, free(log_wl_KLEMS) proxy(log_mat_KLEMS) state(log_k_KLEMS) met(lp) control(nace_4_shares nace_3_shares) acf reps(3) id(firm_id) t(year)  randomize_init(0.2)  last_min_res(`current_min_res')

display `c'
disp `i'
disp e(initguess_val)
disp e(crit_val)


 
 if e(crit_val)<=`current_min_res'{
 	
 local current_min_res = e(crit_val)
	
	
 replace elast_wl_NTV = _b[log_wl_KLEMS]          
 replace elast_mat_NTV = _b[log_mat_KLEMS]                   
 replace elast_k_NTV = _b[log_k_KLEMS]  
 replace elast_share4_NTV = _b[nace_4_shares]  
 replace elast_share3_NTV = _b[nace_3_shares]   

 replace res_sqd  = e(crit_val)  


}

    
}

sum elast_*  res_sqd


   save  "$SERVER_POSTEST_DATA/postest_sec_`sec_num'_seed_`seed_num'.dta", replace

