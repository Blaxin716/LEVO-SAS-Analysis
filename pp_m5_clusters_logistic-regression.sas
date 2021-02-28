/* VARCLUS procedure used to identify potential variables to use
 * in binary logistic regression
 */

data _null_; 
call symput ('timenow',put (time(),time.)); 
call symput ('datenow',put (date(),date9.)); 
run;

title "The current time is &timenow and the date is &datenow";
run;

proc varclus data=MYMIS480.FINALCHURN hierarchy plots;
	var orders units_ordered units_returned net_units gross_sales discount_amt 
		discount_percent net_sales num_product_types days_since_order aur aov 
		repeat_purchaser returner churn;
run;

/* Logistic regression on 5 variables, from the 4 determined clusters,
 * with a forward selection to remove anything insignificatn based on 
 * 95% confidence level
 */

proc logistic data=MYMIS480.FINALCHURN;
	class returner / param=glm;
	model churn(event='1')=returner units_ordered units_returned discount_percent 
		net_sales / link=logit selection=forward slentry=0.05 hierarchy=single 
		technique=fisher;
run;