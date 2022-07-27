functions {
  vector logscale (real m, real u, real log_alpha, vector x) {
    return m + log_inv_logit(u) + log1p_exp(log_inv_logit(exp(log_alpha) * x) - u);
  }
  vector only_log1p (real m, real u, real log_alpha, vector x) {
    return m + log_inv_logit(u) + log1p(inv_logit(exp(log_alpha) * x) * exp(u));
  }
  vector direct_log_1_p (real m, real u, real log_alpha, vector x) {
    return m + log_inv_logit(u) + log(1 + inv_logit(exp(log_alpha) * x) * u);
  }
}
data {
  int<lower=0> N;
  vector[N] x_vals;
  array[N] int y_count;
}
parameters {
  real m;
  real u;
  real log_alpha;
}
model {
  m ~ normal(3, .5);
  u ~ normal(-1.4, .2);
  log_alpha ~ normal(0, .5);

  vector[N] log_mu;


  profile("meanpart"){
    log_mu = logscale(m, u, log_alpha, x_vals);
  }

  y_count ~ poisson_log(log_mu);
}
generated quantities{
  vector[N] mu;
  mu = exp(logscale(m, u, log_alpha, x_vals));
}
