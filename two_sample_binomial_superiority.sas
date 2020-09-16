proc power;
    twosamplefreq test=pchi /* or fm*/
    groupproportions = (.15 .25)
    nullproportiondiff = .03
    ntotal = .
    power = 0.80 0.90;
run;
