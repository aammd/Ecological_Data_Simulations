data {
  int<lower=0> n; // sample size
  vector[n] L2;
  vector[n] L1;
  real<lower=0> dt;
}
transformed data{
  vector[n] log_L1 = log(L1);
}
parameters {
  // real log_Lmax;
  real<lower=0> k;
  real log_sigma;
}
model {
  // log_Lmax ~ normal(5, 1);
  // log_sigma ~ normal(2, .5);
  k ~ exponential(.2);

  // intermediate variables
  vector[n] log_mu;
  vector[n] common_term;

  log_mu = 5.3 + log1m_exp(log(exp(5.3) - L1) - 5.3 - k);
  print(log_mu[60]);
  // could easily work on the log scale and use log1p_exp here
  common_term = log1p_exp(2 * (2.3 - log_mu));
  print(common_term[60]);
  target += normal_lpdf( L2 | log_mu - common_term/2, sqrt(common_term));
}
generated quantities{
}
