*ref: https://www.sas.com/content/dam/SAS/ja_jp/doc/event/sas-user-groups/usergroups2015-b-01.pdf;
proc power;
    twosamplefreq test=pchi /* or fm*/
    groupproportions = (.15 .25)
    nullproportiondiff = .03
    ntotal = .
    power = 0.80 0.90;
run;
