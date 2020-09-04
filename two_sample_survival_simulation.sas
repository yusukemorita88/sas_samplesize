/*
proc power;
    twosamplesurvival test = logrank
    curve("Control") = (10):(0.5)
    curve("Active") = (5):(0.5)
    groupsurvival = "Control" | "Active"
    groupweights = (1, 1)
    accrualtime = 100
    followuptime = 30
    ntotal = .
    power = 0.80;
run;
*/

/* no censor */
data lifedata;
    call streaminit(2020);

    do trial = 1 to 1000;
        strata = 1;
        hr = -log(0.5) / 5; /* median-time to hazard rate*/
        censor = 0;
        do usubjid = 1 to 36;
           day = round((1/hr) * rand("Exponential"),1.);
           output;
        end;

        strata = 2;
        hr = -log(0.5) / 10; /* median-time to hazard rate*/
        censor = 0;
        do usubjid = 1 to 36;
           day = round((1/hr) * rand("Exponential"),1.);
           output;
        end;
    end;

run;

ods listing close;

proc lifetest data = lifedata plots = none ;
    by trial;
    strata strata;
    time day * censor(1);
    ods output homtests = logrank;
run;

ods listing;

data results;
    set logrank;
    by trial;
    if first.trial;*log-rank test result;
    
    if ProbChiSq =< 0.05 then success = 1;
    else if 0.05 < ProbChiSq then success = 0;
run;

proc means data = results n mean;
    var success;
run;
