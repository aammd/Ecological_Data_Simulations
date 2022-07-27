data {
  int<lower=0> N;
  vector[N] x_vals;
  array[N] int y_count;
}
parameters {
  real m;
  real u;
  real log_alpha;
  // real beta;
}
model {
  m ~ normal(.69, .1);
  u ~ normal(2.3, .1);
  log_alpha ~ normal(0, .1);

  vector[N] log_mu;

  profile("meanpart"){
    log_mu = log(exp(m) + (exp(u) - exp(m)) * inv_logit(exp(log_alpha) * x_vals));
  }

  y_count ~ poisson_log(log_mu);
}
generated quantities{
  vector[N] log_mu;
  log_mu = log(exp(m) + (exp(u) - exp(m)) ./ (1 + exp(-exp(log_alpha) * (x_vals))));
}
