/* Summary statistics of continuous variables
 * grouped by churn
 */

options nolabel;

data _null_; 
call symput ('timenow',put (time(),time.)); 
call symput ('datenow',put (date(),date9.)); 
run;

title "The current time is &timenow and the date is &datenow";
run;

proc means data=MYMIS480.FINALCHURN chartype mean std min median max 
		vardef=df qmethod=os;
	var orders units_ordered units_returned net_units gross_sales discount_amt 
		discount_percent net_sales days_since_order aur aov;
	class churn;
run;

/* Visualizations of pertinent variable distribution
 */

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=MYMIS480.FINALCHURN out=_HistogramTaskData;
	by churn;
run;

proc sgplot data=_HistogramTaskData;
	by churn;
	histogram units_ordered /;
	yaxis max=100 grid;
run;

proc sgplot data=_HistogramTaskData;
	by churn;
	histogram net_units /;
	yaxis max=100 grid;
run;

proc sgplot data=_HistogramTaskData;
	by churn;
	histogram gross_sales /;
	yaxis max=100 grid;
run;

proc sgplot data=_HistogramTaskData;
	by churn;
	histogram discount_amt /;
	yaxis max=100 grid;
run;

proc sgplot data=_HistogramTaskData;
	by churn;
	histogram discount_percent /;
	yaxis max=100 grid;
run;

proc sgplot data=_HistogramTaskData;
	by churn;
	histogram net_sales /;
	yaxis max=100 grid;
run;

proc sgplot data=_HistogramTaskData;
	by churn;
	histogram days_since_order /;
	yaxis max=25 grid;
run;

proc sgplot data=_HistogramTaskData;
	by churn;
	histogram aov /;
	yaxis grid;
run;

proc datasets library=WORK noprint;
	delete _HistogramTaskData;
	run;

/* Orders and units returned bar chart with churned (1) and active (0)
 */

proc sgplot data=MYMIS480.FINALCHURN;
	vbar orders / group=churn groupdisplay=cluster stat=percent;
	yaxis grid;
run;

proc sgplot data=MYMIS480.FINALCHURN;
	vbar units_returned / group=churn groupdisplay=cluster stat=percent;
	yaxis grid;
run;

/* Box plot to best demonstrate difference in AUR, by churn
 */

proc sgplot data=MYMIS480.FINALCHURN;
	vbox aur / category=churn;
	yaxis grid;
run;

/* Mosaic plot to illustrate how customers who churn are most likely
 * only going to buy 1 product type compared to active customers
 */

proc freq data=MYMIS480.FINALCHURN;
	ods select MosaicPlot;
	tables num_product_types*churn / plots=mosaicplot;
run;

/* A series of pie charts to illustrate the different buying and 
 * return patterns between churned and active customers 
 */

proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Repeat Purchasers By Churn Group" / textattrs=(size=14);
		entryfootnote halign=left 
			"Inner pie = active customers; Outer pie = churned customers" / 
			textattrs=(size=12);
		layout region;
		piechart category=repeat_purchaser / group=churn groupgap=2% stat=pct 
			datalabellocation=inside;
		endlayout;
		endgraph;
	end;
run;

proc sgrender template=SASStudio.Pie data=MYMIS480.FINALCHURN;
run;

proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Returners By Churn Group" / textattrs=(size=14);
		entryfootnote halign=left 
			"Inner pie = active customers; Outer pie = churned customers" / 
			textattrs=(size=12);
		layout region;
		piechart category=returner / group=churn groupgap=2% stat=pct 
			datalabellocation=inside;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=MYMIS480.FINALCHURN;
run;


