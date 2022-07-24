data {
  int<lower=0> n; // sample size
  vector[n] L2;
  vector[n] L1;
  real<lower=0> dt;
}
parameters {
  real Lmax;
  real<lower=0> k;
  real log_sigma;
}
model {
  Lmax ~ lognormal(5, 1);
  log_sigma ~ normal(2, .5);
  k ~ exponential(.2);

  // intermediate variables
  vector[n] log_mu;
  vector[n] common_term;

  log_mu = log(Lmax - (Lmax-L1)*exp(-k * dt));

  // could easily work on the log scale and use log1p_exp here
  common_term = log1p_exp(2 * (log_sigma - log_mu));

  target += lognormal_lpdf( L2 | log_mu - common_term/2, sqrt(common_term));
}
generated quantities{
}
