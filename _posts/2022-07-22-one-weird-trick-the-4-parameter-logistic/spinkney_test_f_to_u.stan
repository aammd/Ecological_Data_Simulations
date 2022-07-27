functions {
  vector f1 (real m, real u, real log_alpha, vector x) {
    return log(exp(m) + (exp(u) - exp(m)) * inv_logit(exp(log_alpha) * x));
  }

  vector f2 (real m, real u, real log_alpha, vector x) {
    return log(exp(m) + (exp(u) - exp(m)) ./ (1 + exp(-exp(log_alpha) * (x))));
  }

  vector f3 (real m, real u, real log_alpha, vector x) {
    // real f = log( (exp(u) - exp(m)) / exp(m) );
    return m + log1p(exp(u) * inv_logit(exp(log_alpha) * x));
  }

  vector f4 (real m, real u, real log_alpha, vector x) {
    // real f = log( (exp(u) - exp(m)) / exp(m) );
    return m + log1p_exp(u - log1p_exp(-exp(log_alpha) * x));
  }

  vector f5 (real m, real u, real log_alpha, vector x) {
    // real f = log( (exp(u) - exp(m)) / exp(m) );
    return m + log1p_exp(u + log_inv_logit(exp(log_alpha) * x));
  }

  vector f6 (real m, real u, real log_alpha, vector x) {
    // real a = log_diff_exp(u, m);
    return log(exp(log_inv_logit(exp(log_alpha) * x) + u) + exp(m));
  }

  vector f7 (real m, real u, real log_alpha, vector x) {
    // real a = log_diff_exp(u, m);
    return m + log_inv_logit(u) + log1p(inv_logit(exp(log_alpha) * x)*exp(-u));
  }
}
data {
  int<lower=0> N;
  vector[N] x_vals;
  array[N] int y_count;
  int test;
}
parameters {
  real m;
  real u;
  real log_alpha;
}
model {

  if (test < 7){
    m ~ normal(.69, .1);
    u ~ normal(2.3, .1);
    log_alpha ~ normal(0, .1);
  }

  if (test == 7){
    m ~ normal(3, .2);
    u ~ normal(-1.4, .2);
    log_alpha ~ normal(0, .5);
  }

    vector[N] log_mu;

  profile("meanpart"){
    if (test == 1) log_mu = f1(m, u, log_alpha, x_vals);
    if (test == 2) log_mu = f2(m, u, log_alpha, x_vals);
    if (test == 3) log_mu = f3(m, u, log_alpha, x_vals);
    if (test == 4) log_mu = f4(m, u, log_alpha, x_vals);
    if (test == 5) log_mu = f5(m, u, log_alpha, x_vals);
    if (test == 6) log_mu = f6(m, u, log_alpha, x_vals);
    if (test == 6) log_mu = f7(m, u, log_alpha, x_vals);
  }

  y_count ~ poisson_log(log_mu);
}
