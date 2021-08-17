proc power;
    twosamplefreq test=fm 
    groupproportions=(0.908 0.943) 
    nullproportiondiff=-0.1 
    alpha=0.025 
    sides=U 
    power=0.8 
    ntotal=.;
run;
