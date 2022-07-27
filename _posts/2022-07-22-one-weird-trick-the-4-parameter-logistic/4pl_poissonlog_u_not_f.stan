data {
  int<lower=0> N;
  vector[N] x_vals;
  array[N] int y_count;
}
parameters {
  real m;
  real d;
  real log_alpha;
  // real beta;
}
model {
  m ~ normal(.69, .1);
  d ~ normal(2.3, .1);
  log_alpha ~ normal(0, .1);

  // model
  // make a vector to hold the log prop
  vector[N] log_mu;

  profile("meanpart"){
    log_mu = m + log1p_exp(d - m - log1p_exp(-exp(log_alpha) * x_vals));
  }

  y_count ~ poisson_log(log_mu);
}
