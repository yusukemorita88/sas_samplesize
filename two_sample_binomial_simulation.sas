proc power;
    twosamplefreq test= pchi /*or fm*/
    groupproportions = (.05 .45)
    ntotal = .
    alpha = 0.05
    sides = 2
    power = 0.80 0.90;
run;

*Simulation;
data sim;
    call streaminit(20210608);
    do NperGroup = 18 to 23 by 5;
        do trial = 1 to 1000;
            do subjid = 1 to NperGroup;
                trtpn = 1;
                response = ( rand('UNIFORM') > 0.45 );* Event Yes:0  No:1 ; 
                output;
                trtpn = 9;
                response = ( rand('UNIFORM') > 0.05 ); 
                output; 
            end;
        end;
    end;
run;

*data check;
proc sql ;
    select distinct trtpn, mean(response=0) as mean
    from sim
    group by trtpn;
quit;

*analyze each trial;
ods listing close;

proc freq data = sim ;
    by NperGroup trial;
    tables trtpn*response/riskdiff(cl=newcombe) fisher;
    ods select RiskDiffCol1 PdiffCLs FishersExact;
    ods output RiskDiffCol1 = diff1 PdiffCLs = cl1 FishersExact = fish1;
run;

ods listing;

data fish1x;
    set fish1;
    where Name1 = "XP2_FISH";
    if nValue1 < 0.05 then SUCCESS = 1;
    else SUCCESS = 0;
run;

proc means data = fish1x noprint;
    by NperGroup;
    var SUCCESS;
    output out = res1(drop=_:) n = repeat mean = probability1;
run;
