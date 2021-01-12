%let intrasubjectCV = 0.5;*macro vaiable for the intra-subject CV;
%let sigma2=%sysfunc(log(1+&intrasubjectCV.**2));* macro variable for the within-subject variance;
%let std_derived=%sysevalf((&sigma2/2)**0.5); * macro variable for the derived common standard deviation;
%let log_pt_8=%sysfunc(log(0.8)); * macro variable for log(0.8);
%let log_1_pt_25=%sysfunc(log(1.25)); * macro variable for log(1.25);
%let log_true_gmr=%sysfunc(log(0.95)); * macro variable for log(0.95);

proc power;
    twosamplemeans test=equiv_diff alpha=0.05
    lower=&log_pt_8. upper=&log_1_pt_25. std=&std_derived.
    meandiff=&log_true_gmr.
    ntotal=.
    power =0.8;
run;

/*another sample*/
proc power;
    pairedmeans test = equiv_ratio dist = lognormal 
    meanratio = 0.95
    alpha     = 0.05 
    cv        = 0.5
    corr      = 0
    lower     = 0.8
    upper     = 1.25
    npairs    = .
    power     =0.8;
run;
