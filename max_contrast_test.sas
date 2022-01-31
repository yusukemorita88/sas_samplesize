proc iml ;
    %include '/home/u#########/sub_mvt.sas'; *specify your path;
  
    alpha=0.025 ;
    variance=1 ;
    contrast={-3 -1 1 3,
              -5 -1 3 3,
              -3 -3 1 5} ;
    expect={0 0 0 0} ;
    n1=1000 ;
    n_alloc={1 1 1 1} ;
    switch=1 ;
    eps1=0.0001 ;
    abseps=0.0001 ;
    run estpower(switch,alpha,n1,eps1,abseps,expect,variance,contrast,n_alloc,n,power,crival) ;
    alpha = 1 - probnorm(CriVal);
    call symputx("alpha_max", alpha);
    print N CriVal Power alpha;
run ;

proc power;
    onewayanova groupmeans = 0 | 5 | 10 | 20
    sides  = 1
    stddev = 22
    alpha  = &alpha_max.  /* = 1 - probnorm(critical_value) */
    ntotal =.
    power = 0.80
    contrast = (-3 -1 1 3)  (-5 -1 3 3)  (-3 -3 1 5);
run;
