*ref: https://www.sas.com/content/dam/SAS/ja_jp/doc/event/sas-user-groups/usergroups2015-b-01.pdf;
ods output output=out;
proc power;
    onesamplefreq test=z method=normal 
    nullproportion=0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 
    proportion=0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90
    sides=2 
    ntotal=.
    alpha=0.05 
    power=0.8 0.9;
run;

proc sort data = out out = out2 nodupkey;
    where nullproportion < proportion;
    by NominalPower nullproportion proportion;
run;

proc transpose data = out2 out = out3 prefix=N;
    by NominalPower nullproportion;
    var ntotal;
    id proportion;
    idlabel proportion;
run;

*ods excel file = ".\one_sample_binomial_matrix.xlsx";

title1 "One Sample Binomial Total N";
option missing="-";
proc print data = out3 noobs label;
    var NominalPower nullproportion N0_:;
run;

*ods excel close;
