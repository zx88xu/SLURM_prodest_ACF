********************************************************************************************************************************
************************************************ Estimating Production Function using LP+ACF  
********************************************************************************************************************************


* Test file:             1. use the slurm thing to set 5 jobs
*                        2. run this code 5 times "simultaneously"



local run_num = "`1'" 

set obs 100
  
  

local   sec_num    =   mod(run_num − 1, 86) + 1
local   seed_num   =   floor((run_num − 1)/86) + 1


  gen run_n = `run_num'
  
  gen sec = `sec_num'
  
  gen seed = `seed_num'
  



save  "/try/try_`run_num'.dta", replace
 
