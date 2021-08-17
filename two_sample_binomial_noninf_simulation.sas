*ref: https://www.sas.com/content/dam/SAS/ja_jp/doc/event/sas-user-groups/usergroups2015-b-01.pdf;
proc power;
    twosamplefreq test=fm 
    groupproportions=(0.86 0.86) 
    groupweights=(2 1)
    NULLPDIFF=-0.2
    alpha=0.025
    sides=U 
    power=0.8 0.9
    ntotal=.;
run;

*Simulation;
data sim;
    call streaminit(20210817);
    do Ntotal = 138, 180 ;    
        do p1 = 0.66, 0.86;
            do p2 = 0.86;
                do trial = 1 to 10000;
                    do subjid = 1 to Ntotal;
                        * 2 : 1 allocation;
                        if mod(subjid, 3) in (1, 2) then do;
                            trtpn = 1;
                            response = ( rand('UNIFORM') > p1 );* Event Yes:0  No:1 ; 
                            output;
                        end;
                        else do;
                            trtpn = 9;
                            response = ( rand('UNIFORM') > p2 ); 
                            output; 
                        end;
                    end;
                end;
            end;
        end;
    end;
run;

/*
*data check;
proc sql ;
    select distinct trtpn, count(*) as N, mean(response=0) as mean
    from sim
    group by trtpn;
quit;
*/

*analyze each trial;
ods listing close;

proc freq data = sim ;
    by Ntotal  p1 p2 trial;
    * non-inferiority margin ************************;
    tables trtpn*response/riskdiff(noninf margin=0.2 method=mn) alpha = 0.025 ;
    ods select RiskDiffCol1 PdiffNoninf ;
    ods output RiskDiffCol1 = diff1 PdiffNoninf = cl1 ;
run;

ods listing;

data cl1x;
    set cl1;
    * non-inferiority margin ************************;
    if -0.2 < LowerCL then SUCCESS = 1;
    else SUCCESS = 0;
run;

proc means data = cl1x noprint;
    by Ntotal p1 p2;
    var SUCCESS;
    output out = res1(drop=_:) n = repeat mean = probability1;
run;

proc print noobs;
run;
