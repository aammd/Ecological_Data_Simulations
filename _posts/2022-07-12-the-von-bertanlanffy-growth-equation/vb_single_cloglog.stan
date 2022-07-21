data {
  int<lower=0> n; // sample size
  vector[n] L;
  vector[n] t;
}
transformed data{
  vector[n] tlog = log(t);
}
parameters {
  real log_Lmax;
  real log_k;
  real log_sigma;
  // real c;
  real a;
}
model {
  log_Lmax ~ normal(5, 1);
  log_sigma ~ normal(0, .5);
  log_k ~ normal(-4, 1);
  // c ~ normal(1, 1);
  a ~ normal(4.5, 1);

  // intermediate variables
  vector[n] log_mu;
  vector[n] common_term;

  // log_mu = log_Lmax + log(inv_cloglog(log_k + tlog + log1m_inv_logit(c)));
  log_mu = log_Lmax + log(inv_cloglog(log_k + log(t - exp(a))));

  // could easily work on the log scale and use log1p_exp here
  common_term = log1p_exp(2 * (log_sigma - log_mu));

  target += lognormal_lpdf( L | log_mu - common_term/2, sqrt(common_term));
}
generated quantities{
}
