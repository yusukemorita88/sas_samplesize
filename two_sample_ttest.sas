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
