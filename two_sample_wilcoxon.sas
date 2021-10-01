proc power;
    twosamplewilcoxon
    vardist("PLACEBO") = ordinal ((-3 -2 -1 0 1 2 3) : (0 0 0 0.80 0.10 0.05 0.05))
    vardist("ACTIVE")  = ordinal ((-3 -2 -1 0 1 2 3) : (0 0 0 0.05 0.40 0.45 0.10))
    variables = "PLACEBO" | "ACTIVE"
    sides = 2
    alpha = 0.05
    power = 0.8
    ntotal = .;
run;
