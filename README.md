# LEVO-SAS-Analysis

finalchurn.sas7bdat

* Create permanent library in SAS: 'MYMIS480.FINALCHURN'

pp_m5_summary-stats_range.sas

* SAS code to determine summary statistics of 'MYMIS480.FINALCHURN' data
* SAS code to visualizations for the distribution of each relevant variable

pp_m5_clusters_logistic-regression.sas

* SAS VARCLUS procedure to determine ideal variables for logistic regression
* SAS LOGISTIC procedure on 5 variables with forward selection to remove insignificant variables at 95% confidence level

pp_m5_cohort-calc_churn-analysis.sas

* SAS code to create 'COHORT_SUBSET' dataset that includes customer cohorts based on 6 month periods since last purchase
* SAS code to produce a bar-line chart depicting churn percentage by repeat customer status and 6-month cohort
