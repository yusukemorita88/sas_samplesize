proc power;
    onesamplefreq test=z method=normal 
    nullproportion=0.80 
    proportion=0.95 
    sides=2 
    ntotal=.
    alpha=0.05 
    power=0.8;
run;
