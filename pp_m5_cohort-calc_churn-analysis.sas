/* Created days since last purchase cohorts to
 * see if there were any noteworthy trends. The only
 * thing that stood out was that people who churn 
 * actually tend to churn within the first 6 months
 */

data COHORT_SUBSET;
	set mymis480.finalchurn;
	cohort=round((days_since_order/182), 1);
	count=1;
run;

/* Bar-line chart to visualize each customer cohort created
 * and see when people are churning in the customer life-cycle
 */

data _null_; 
call symput ('timenow',put (time(),time.)); 
call symput ('datenow',put (date(),date9.)); 
run;

title "The current time is &timenow and the date is &datenow";
run;

/* Compute axis ranges */
proc means data=WORK.COHORT_SUBSET noprint;
	class cohort repeat_purchaser / order=data;
	var count churn;
	output out=_BarLine_(where=(_type_ > 2)) sum(count)=resp1 mean(churn)=resp2;
run;

/* Compute response min and max values (include 0 in computations) */
data _null_;
	retain respmin 0 respmax 0;
	retain respmin1 0 respmax1 0 respmin2 0 respmax2 0;
	set _BarLine_ end=last;
	respmin1=min(respmin1, resp1);
	respmin2=min(respmin2, resp2);
	respmax1=max(respmax1, resp1);
	respmax2=max(respmax2, resp2);

	if last then
		do;
			call symputx ("respmin1", respmin1);
			call symputx ("respmax1", respmax1);
			call symputx ("respmin2", respmin2);
			call symputx ("respmax2", respmax2);
			call symputx ("respmin", min(respmin1, respmin2));
			call symputx ("respmax", max(respmax1, respmax2));
		end;
run;

/* Define a macro for offset */
%macro offset ();
	%if %sysevalf(&respmin eq 0) %then
		%do;
			offsetmin=0 %end;

	%if %sysevalf(&respmax eq 0) %then
		%do;
			offsetmax=0 %end;
%mend offset;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.COHORT_SUBSET nocycleattrs;
	title height=14pt 
		"Customer Churn Percentage by 6 Month Cohort and Repeat Purchase Status";
	footnote2 justify=left height=12pt "Each cohort represents 6 month periods since last purchase. Repeat purchaser status: 0 = first-time customer, 1= repeat-customer";
	vbar cohort / response=count group=repeat_purchaser groupdisplay=cluster 
		stat=sum;
	vline cohort / response=churn group=repeat_purchaser stat=mean y2axis;
	yaxis grid min=&respmin1 max=&respmax1 %offset();
	y2axis min=&respmin2 max=&respmax2 %offset();
	keylegend / location=outside;
run;