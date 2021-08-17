*ref: https://www.sas.com/content/dam/SAS/ja_jp/doc/event/sas-user-groups/usergroups2015-b-01.pdf;
proc power;
    twosamplefreq test=fm 
    groupproportions=(0.908 0.943) 
    groupweights=(1 1)
    nullproportiondiff=-0.1 
    alpha=0.025 
    sides=U * U: p1 - p2 > nullPdiff, L: p1 - p2 < nullPdiff;  
    power=0.8 
    ntotal=.;
run;
