proc power;
    onesamplefreq test=z method=normal 
    nullproportion=0.80 
    proportion=0.95 
    sides=2 
    ntotal=.
    alpha=0.05 
    power=0.8;
run;

proc power;
    onesamplefreq test=EXACT 
    nullproportion=0.25 
    proportion=0.70
    sides=1
    ntotal=1 to 20
    alpha=0.025 
    power=. ;
run;
