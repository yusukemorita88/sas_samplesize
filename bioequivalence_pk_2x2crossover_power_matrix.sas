%macro bioeq_power_matrix(dsout);

    data &dsout;
        length ntotal gmr iscv power 8.;
        delete;
    run;

    %do ntotal = 24 %to 48 %by 6;
        %do gmr = 950 %to 1000 %by 25;
            %do iscv = 20 %to 50 %by 5;
                %let intrasubjectCV = %sysevalf(&iscv./100);*macro vaiable for the intra-subject CV;
                %let sigma2=%sysfunc(log(1+&intrasubjectCV.**2));* macro variable for the within-subject variance;
                %let std_derived=%sysevalf((&sigma2/2)**0.5); * macro variable for the derived common standard deviation;
                %let log_pt_8=%sysfunc(log(0.8)); * macro variable for log(0.8);
                %let log_1_pt_25=%sysfunc(log(1.25)); * macro variable for log(1.25);
                %let log_true_gmr=%sysfunc(log(%sysevalf(&gmr./1000))); * macro variable for log(0.95);

                ods output output = _out1;
                proc power;
                    twosamplemeans test=equiv_diff alpha=0.05
                    lower=&log_pt_8. upper=&log_1_pt_25. std=&std_derived.
                    meandiff=&log_true_gmr.
                    ntotal= &ntotal.
                    power =.;
                run;

                data _out2;
                    set _out1;
                    gmr = &gmr./1000;
                    iscv = &iscv./100;
                run;

                proc append data = _out2 base = &dsout. force;
                run;

            %end;
        %end;
    %end;

%mend;

%bioeq_power_matrix(dsout=outds);

proc sort data = outds;
    by gmr iscv ntotal;
run;

proc transpose data = outds out = outds2(drop=_:) prefix=N;
    by gmr iscv;
    var power;
    id ntotal;
    format power 8.3;
run;

*ods pdf file = ".\PowerMatrixPK-BE.pdf";

title1 "Power Matrix for PK-Bioequivalence Trial";
proc report data = outds2;
    columns (gmr iscv ("power" n24 n30 n36 n42 n48));
    define gmr /order "True GMR" format=8.3;
    define iscv /order "Intra-subject CV" format=8.2;
    define n24/"N = 24";
    define n30/"N = 30";
    define n36/"N = 36";
    define n42/"N = 42";
    define n48/"N = 48";

run;
quit;

*ods pdf close;
