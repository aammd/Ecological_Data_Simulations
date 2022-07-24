data {
  int<lower=0> n; // sample size
  vector[n] L;
  real<lower=0> time;
}
parameters {
  real log_Lmax;
  real<lower=0> k;
  real log_sigma;
}
model {
  log_Lmax ~ normal(5, 1);
  log_sigma ~ normal(0, .5);
  k ~ exponential(.2);

  // intermediate variables
  vector[n] log_mu;
  vector[n] common_term;

  log_mu = log_Lmax + log1m_exp(log_diff_exp(log_Lmax, log_L1) - log_Lmax - k * dt);

  // could easily work on the log scale and use log1p_exp here
  common_term = log1p_exp(2 * (log_sigma - log_mu));

  target += lognormal_lpdf( L2 | log_mu - common_term/2, sqrt(common_term));
}
generated quantities{
}
