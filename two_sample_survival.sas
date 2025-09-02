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

*pattern 2;
ods output output = out;

proc power;
    twosamplesurvival test = logrank
    curve("Control=0.01") = (6):(0.01) /* (time):(S(t)) */
    curve("Active=0.10") = (6):(0.10)
    curve("Active=0.15") = (6):(0.15)
    curve("Active=0.20") = (6):(0.20)
    curve("Active=0.25") = (6):(0.25) 
    curve("Active=0.30") = (6):(0.30)
    curve("Active=0.35") = (6):(0.35) 
    groupsurvival = 
        ("Control=0.01" "Active=0.10")
        ("Control=0.01" "Active=0.15") 
        ("Control=0.01" "Active=0.20") 
        ("Control=0.01" "Active=0.25")
        ("Control=0.01" "Active=0.30")
        ("Control=0.01" "Active=0.30") 
        ("Control=0.01" "Active=0.35") 

    groupweights =(1, 1)
    accrualtime = 0
    followuptime = 6 9 12
    ntotal = .
    power = 0.80 0.90;
run;


proc sort data = out out = out2;
    by nominalpower index;
run;

