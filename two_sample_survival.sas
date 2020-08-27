proc power;
    twosamplesurvival test = logrank
    curve("Control") = (14):(0.5) /* (time):(S(t)) */
    curve("Active") = (10):(0.5)
    groupsurvival = "Control" | "Active"
    groupweights = (1, 1)
    accrualtime = 180
    followuptime = 28
    ntotal = .
    power = 0.80;
run;
