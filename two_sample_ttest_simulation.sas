*ods output fixedelements = elems output=outds;
proc power;
    twosamplemeans test = diff
    meandiff = 3
    stddev = 3, 4, 5
    alpha = 0.05
    power = 0.8
    ntotal = . 
    groupweights=(1, 1)
    ;
run;

*Simulation;
data sim;
    call streaminit(20210715);
    do NperGroup = 17 to 17 by 2;
        do trial = 1 to 1000;
            do subjid = 1 to NperGroup;
                trtpn = 1;*active;
                response = rand('NORMAL', 3, 3);*mean, sd;
                output;
                trtpn = 9;*placebo;
                response = rand('NORMAL', 0, 3);*mean, sd;; 
                output; 
            end;
        end;
    end;
run;

*data check;
proc sql ;
    select distinct trtpn, mean(response) as mean
    from sim
    group by trtpn;
quit;

*analyze each trial;
ods trace off;
ods listing close;

proc ttest data = sim ;
    by NperGroup trial;
    class trtpn;
    var response;
    ods select ttests conflimits;
    ods output ttests=ttests conflimits=cis;
run;

ods listing;

data results;
    merge
        ttests(where=(Method="Pooled"))
        cis(where=(Method="Pooled"))
    ;
    by NperGroup trial;
    if probt < 0.05 then SUCCESS = 1;
    else SUCCESS = 0;
run;

proc means data = results ;
    by NperGroup;
    var SUCCESS;
    output out = simres(drop=_:) n = repeat mean = probability1;
run;
