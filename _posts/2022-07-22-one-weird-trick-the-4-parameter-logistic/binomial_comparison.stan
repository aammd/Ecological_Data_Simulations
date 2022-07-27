functions {
  real f1 (real a) {
    return exp(a) / (1 + exp(a));
  }
  real f2 (real a) {
    return 1 / (1 + exp(-a));
  }
  real f3 (real a) {
    return 1 / exp(log1p_exp(-a));
  }
  real f4 (real a) {
    return inv_logit(a);
  }
  real f5 (real a) {
    return exp(log_inv_logit(a));
  }
  real f6 (real a) {
    return exp(-log1p_exp(-a));
  }
}
data {
  int<lower=0> N;
  array[N] int y_count;
  int test;
}
parameters {
  real a;
}
model {
  a ~ std_normal();

  real theta;

  profile("meanpart"){
    if (test == 1) theta = f1(a);
    if (test == 2) theta = f2(a);
    if (test == 3) theta = f3(a);
    if (test == 4) theta = f4(a);
    if (test == 5) theta = f5(a);
  }

  y_count ~ binomial(30, theta);
}
