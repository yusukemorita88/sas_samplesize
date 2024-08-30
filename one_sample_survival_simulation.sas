*https://nshi.jp/contents/js/onesurvyr/;

/* no censor */
data lifedata;
    call streaminit(2020);

    do trial = 1 to 1000;
        hr = -log(0.75) / 6; /* -log(S(time)) / time = hazard rate */
        censor = 0;
        do usubjid = 1 to 41;
           t = round((1/hr) * rand("Exponential"), 0.01);
           output;
        end;
    end;

run;


ods listing close;

proc lifetest data = lifedata plots = none outsurv=kmest timelist=(0 to 12 by 1) reduceout conftype=LOGLOG alpha=0.05;
    by trial;
    time t * censor(1);
run;

ods listing;

data results;
    set kmest;
    where timelist in (6, 7);

    if SDF_LCL > 0.5 then success = 1;
    else if not missing(SDF_LCL) then success = 0;
run;

proc means data = results n mean;
    class timelist;
    var success survival t;
run;
