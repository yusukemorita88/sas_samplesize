*ref: https://www.sas.com/content/dam/SAS/ja_jp/doc/event/sas-user-groups/usergroups2015-b-01.pdf;
ods output output=out;
proc power;
    twosamplefreq test=pchi /* or fm*/
    groupproportions = 
    (.10 .10) (.10 .20)  (.10 .30)  (.10 .40)  (.10 .50)  (.10 .60)  (.10 .70)  (.10 .80)  (.10 .90)
    (.20 .10) (.20 .20)  (.20 .30)  (.20 .40)  (.20 .50)  (.20 .60)  (.20 .70)  (.20 .80)  (.20 .90)
    (.30 .10) (.30 .20)  (.30 .30)  (.30 .40)  (.30 .50)  (.30 .60)  (.30 .70)  (.30 .80)  (.30 .90)
    (.40 .10) (.40 .20)  (.40 .30)  (.40 .40)  (.40 .50)  (.40 .60)  (.40 .70)  (.40 .80)  (.40 .90)
    (.50 .10) (.50 .20)  (.50 .30)  (.50 .40)  (.50 .50)  (.50 .60)  (.50 .70)  (.50 .80)  (.50 .90)
    (.60 .10) (.60 .20)  (.60 .30)  (.60 .40)  (.60 .50)  (.60 .60)  (.60 .70)  (.60 .80)  (.60 .90)
    (.70 .10) (.70 .20)  (.70 .30)  (.70 .40)  (.70 .50)  (.70 .60)  (.70 .70)  (.70 .80)  (.70 .90)
    (.80 .10) (.80 .20)  (.80 .30)  (.80 .40)  (.80 .50)  (.80 .60)  (.80 .70)  (.80 .80)  (.80 .90)
    (.90 .10) (.90 .20)  (.90 .30)  (.90 .40)  (.90 .50)  (.90 .60)  (.90 .70)  (.90 .80)  (.90 .90)
    ntotal = .
    alpha = 0.05
    sides = 2
    power = 0.80 0.90;
run;

proc sort data = out out = out2 nodupkey;
    by NominalPower Proportion1 Proportion2;
run;

proc transpose data = out2 out = out3 prefix=N;
    by NominalPower Proportion1;
    var ntotal;
    id Proportion2;
    idlabel Proportion2;
run;

*ods excel file = ".\two_samole_binomial_superiority_matrix.xlsx";

option missing="-";
proc print data = out3 noobs label;
    var NominalPower Proportion1 N0_:;
    label Proportion1 = "Proportion";
run;

*ods excel close;
