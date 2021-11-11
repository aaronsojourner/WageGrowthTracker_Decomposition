* Graph WGT


**********************************
****SET PATHS AND READ IN DATA****
**********************************

set more off, permanently
display "$S_TIME"

global yourpath
global programspath "${yourpath}\WageGrowthTracker\Programs"  /* store programs here */
global rawdatapath "${yourpath}\WageGrowthTracker\Data\rawdata" /*save cadre data file and group dataset here*/
global processeddatapath "${yourpath}\WageGrowthTracker\Data\processeddata" /* save ouput here */
global outputpath ""

***
use "${processeddatapath}\wage-growth-data_unweighted_smoothed_v2.dta", replace


** Age - 6 groups
scalar lag = 3
twoway (line WGT_age61_`=lag'mma date_monthly) || (line WGT_age62_`=lag'mma date_monthly) ///
	(line WGT_age63_`=lag'mma date_monthly) || (line WGT_age64_`=lag'mma date_monthly) ///
	(line WGT_age65_`=lag'mma date_monthly) || (line WGT_age66_`=lag'mma date_monthly), ///
	legend(label(1 "16-24") label(2 "25-34") label(3 "35-44") label(4 "45-54") label(5 "55-64") label(6 "65+") pos(3)) ///
		title("Annual wage growth rate by age") subtitle("`=lag'-month moving average of median annual growth") ///
		ytitle(Percent) ///
		note("Atlanta Fed Wage Growth Tracker, Current Population Survey hourly data. Calcs & graphs: @aaronsojourner.") 
	graph export "${outputpath}\gr_WGT_age6_`=lag'.jpg", replace

** Age by switcher

forvalues g = 1/4 {
	if `g' == 1 {
		local ages "16-29"
	}
	else if `g' == 2 {
		local ages "30-44"
	}
	else if `g' == 3 {
		local ages "45-59"
	}	
	else if `g' == 4 {
		local ages "60+"
	}
	
foreach lag in 3 12 {
twoway (line WGT_age`g'sw_`lag'mma date_monthly) || (line WGT_age`g'st_`lag'mma date_monthly), ///
	legend(label(1 "Switcher") label(2 "Stayer") pos(3)) ///
		title("Annual wage growth rate for `ages' year olds by job switcher/stayer") ///
		subtitle("`lag'-month moving average of median annual growth") ///
		ytitle(Percent) ///
		note("Atlanta Fed Wage Growth Tracker, Current Population Survey hourly data. Calcs & graphs: @aaronsojourner.") 
	graph export "${outputpath}\gr_WGT_age`g'SW_`lag'.jpg", replace
}
}


** sector
/*
gen WGT_cmi = WGT if indgroup=="Construction & Mining"
gen WGT_ehi = WGT if indgroup=="Education & Health"
gen WGT_fpi = WGT if indgroup=="Finance and Business Services"
gen WGT_lhi = WGT if indgroup=="Leisure & Hospitality"
gen WGT_mni = WGT if indgroup=="Manufacturing"
gen WGT_pai = WGT if indgroup=="Public Administration"
gen WGT_tti = WGT if indgroup=="Trade & Transportation"
*/
scalar lag = 3
twoway (line WGT_lhi_`=lag'mma date_monthly)  || (line WGT_tti_`=lag'mma date_monthly), ///
	legend(label(1 "Leisure & Hosp.") label(2 "Trade & Transport.") pos(3)) ///
		title("Annual wage growth rate by industry") subtitle("`=lag'-month moving average of median annual growth") ///
		ytitle(Percent) ///
		note("Atlanta Fed Wage Growth Tracker, Current Population Survey hourly data. Calcs & graphs: @aaronsojourner.") 
	graph export "${outputpath}\gr_WGT_selind_`=lag'.jpg", replace




** Switchers and stayers
* 3 month
twoway (line WGT_jsw_3mma date_monthly) || (line WGT_jst_3mma date_monthly), ///
	legend(label(1 "Job switchers") label(2 "Job stayers") pos(3)) ///
		title("Annual wage growth rate by job switcher/stayer") subtitle("3-month moving average of median annual growth") ///
		ytitle(Percent) ///
		note("Atlanta Fed Wage Growth Tracker, Current Population Survey hourly data. Calcs & graphs: @aaronsojourner.") 
	graph export "${outputpath}\gr_WGT_jswst_3.jpg", replace

* 12 vs 3
twoway (line WGT_jsw_12mma date_monthly) || (line WGT_jsw_3mma date_monthly), ///
	legend(label(1 "12-month") label(2 "3-month") pos(3)) ///
		title("Median annual wage growth rate for job switchers, by moving-average length") ///
		ytitle(Percent) ///
		note("Atlanta Fed Wage Growth Tracker, Current Population Survey hourly data. Calcs & graphs: @aaronsojourner.") 
	graph export "${outputpath}\gr_WGT_jsw_12_3.jpg", replace
	

twoway (line WGT_jst_12mma date_monthly) || (line WGT_jst_3mma date_monthly), ///
	legend(label(1 "12-month") label(2 "3-month") pos(3)) ///
		title("Median annual wage growth rate for job stayers, by moving-average length") ///
		ytitle(Percent) ///
		note("Atlanta Fed Wage Growth Tracker, Current Population Survey hourly data. Calcs & graphs: @aaronsojourner.") 
	graph export "${outputpath}\gr_WGT_jst_12_3.jpg", replace

* by age
* 3 month
twoway (line WGT_ya_3mma date_monthly) || (line WGT_pa_3mma date_monthly) || (line WGT_oa_3mma date_monthly), ///
	legend(label(1 "16-24") label(2 "25-54") label(3 "55+") pos(3)) ///
		title("Annual wage growth rate by age group") subtitle("3-month moving average of median annual growth") ///
		ytitle(Percent) ///
		note("Atlanta Fed Wage Growth Tracker, Current Population Survey hourly data. Calcs & graphs: @aaronsojourner.") 
	graph export "${outputpath}\gr_WGT_age_3.jpg", replace


* 12 m vs 3 m
twoway (line WGT_ya_12mma date_monthly) || (line WGT_ya_3mma date_monthly), ///
	legend(label(1 "12-month") label(2 "3-month") pos(3)) 	ytitle(Percent) ///
		title("Median annual wage growth rate for 16-24 year olds, by moving-average length") ///
		note("Atlanta Fed Wage Growth Tracker, Current Population Survey hourly data. Calcs & graphs: @aaronsojourner.") 
	graph export "${outputpath}\gr_WGT_ya_12_3.jpg", replace
	
twoway (line WGT_pa_12mma date_monthly) || (line WGT_pa_3mma date_monthly), ///
	legend(label(1 "12-month") label(2 "3-month") pos(3)) ytitle(Percent) ///
		title("Median annual wage growth rate for 25-54 year olds, by moving-average length") ///
		note("Atlanta Fed Wage Growth Tracker, Current Population Survey hourly data. Calcs & graphs: @aaronsojourner.") 
	graph export "${outputpath}\gr_WGT_pa_12_3.jpg", replace
	
twoway (line WGT_oa_12mma date_monthly) || (line WGT_oa_3mma date_monthly), ///
	legend(label(1 "12-month") label(2 "3-month") pos(3)) 		ytitle(Percent) ///
		title("Median annual wage growth rate for 55+ year olds, by moving-average length") ///
		note("Atlanta Fed Wage Growth Tracker, Current Population Survey hourly data. Calcs & graphs: @aaronsojourner.") 
	graph export "${outputpath}\gr_WGT_oa_12_3.jpg", replace

* Race
twoway (line WGT_wr_3mma date_monthly) || (line WGT_or_3mma date_monthly), ///
	legend(label(1 "White") label(2 "Not white") pos(3)) ///
		title("Annual wage growth rate by race/ethinicity") subtitle("3-month moving average of median annual growth") ///
		ytitle(Percent) ///
		note("Atlanta Fed Wage Growth Tracker, Current Population Survey hourly data. Calcs & graphs: @aaronsojourner.") 
	graph export "${outputpath}\gr_WGT_wr_3.jpg", replace

* Wage quartile
twoway (line WGT_q1_3mma date_monthly) || (line WGT_q2_3mma date_monthly) || ///
	 (line WGT_q3_3mma date_monthly) || (line WGT_q4_3mma date_monthly), ///
	legend(label(1 "1st quartile") label(2 "2nd quartile") label(3 "3rd quartile") label(4 "4th quartile") pos(3)) ///
		title("Annual wage growth rate by wage level") subtitle("3-month moving average of median annual growth") ///
		ytitle(Percent) ///
		note("Atlanta Fed Wage Growth Tracker, Current Population Survey hourly data. Calcs & graphs: @aaronsojourner.") 
	graph export "${outputpath}\gr_WGT_wagelevel_3.jpg", replace

	
* distribution
twoway (line WGT_p75_3mma date_monthly) (line WGT_avg_3mma date_monthly) ///
	(line WGT_3mma date_monthly) || (line WGT_p25_3mma date_monthly), ///
	legend(label(1 "75th percentile") label(2 "mean") label(3 "median") label(4 "25th percentile") pos(3)) ///
		title("Distribution of individual wage growth") subtitle("3-month moving average of median annual growth") ///
		ytitle(Percent) ///
		note("Atlanta Fed Wage Growth Tracker, Current Population Survey hourly data. Calcs & graphs: @aaronsojourner.") 
	graph export "${outputpath}\gr_WGT_dist_3.jpg", replace
