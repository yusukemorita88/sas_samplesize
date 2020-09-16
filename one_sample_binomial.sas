*based on the probability that lowerCL of the proportion exceeds the threshold; 
data sim;
    do N = 10 to 30 by 5;
        do TRIAL = 1 to 1000; 
            do SUBJID = 1 to N;
                if ranuni(1234) <= 0.95/*expected proportion*/ then RESPONSE = 0;*success;
                else RESPONSE = 1;*failed;
                output;
            end;
        end;
    end;
run;

proc freq data = sim ;
    by N TRIAL;
    tables RESPONSE/binomial(all);
    ods output binomialcls = out1;
    ods select binomialcls;
run;

data out2;
    set out1;
    if lowerCL >=0.80 /*threshold*/then SUCCESS = 1;
    else SUCCESS = 0;
run;

proc sort data = out2;
    by N TYPE;
run;

proc means data = out2 noprint;
    by N TYPE;
    var SUCCESS;
    output out = out3  n = n mean = success_rate ;
    format SUCCESS;
run;

proc print data = out3 noobs;
run;
