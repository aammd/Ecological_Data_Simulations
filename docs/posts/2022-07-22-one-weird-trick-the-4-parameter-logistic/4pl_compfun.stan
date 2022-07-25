data {
  int<lower=0> N;
  vector[N] x;
  vector[N] y_obs;
}
parameters {
  real m;
  real f;
  real alpha;
  real beta;
  real log_sigma;
}
model {
  m ~ normal(-1, 1);
  f ~ normal(-2, .5);
  alpha ~ normal(0, .2);
  beta ~ normal(-1, .2);
  log_sigma ~ normal(-1, .2);
//
//   // model
//   // make a vector to hold the log prop
//   vector[N] log_mu;
//   vector[N] common_term;
//
//   log_mu = m + log1p_exp(f + log_inv_logit(alpha * (x - beta)));
//
//   // could easily work on the log scale and use log1p_exp here
//   common_term = log1p_exp(2 * (log_sigma - log_mu));
//
//   target += lognormal_lpdf( y_obs | log_mu - common_term/2, sqrt(common_term));
}
generated quantities{
  // make a vector to hold the log prop
  vector[N] log_mu;
  vector[N] common_term;
  vector[N] y_gen;

  // calculate average
  log_mu = m + log1p_exp(f + log_inv_logit(alpha * (x - beta)));

  // calculate the parameters of the lognormal
  common_term = log1p_exp(2 * (log_sigma - log_mu));
  for (i in 1:N){
    y_gen[i] = lognormal_rng(
      log_mu[i] - common_term[i]/2,
      sqrt(common_term[i])
      );
  };
}
