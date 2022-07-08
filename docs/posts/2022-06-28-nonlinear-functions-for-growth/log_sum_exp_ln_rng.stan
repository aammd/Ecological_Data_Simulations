data {
  int<lower=0> n;
  vector[n] x;
}
parameters {
  real L;
  real alpha;
  real U;
  real log_sigma;
}
model {
  L ~ normal(-1, 1);
  alpha ~ normal(-.8, 1.3);
  U ~ normal(0, .5);
  log_sigma ~ normal(-1, .2);
}
generated quantities{
  // make a vector to hold the log prop
  vector[n] log_mu;
  vector[n] common_term;
  vector[n] y_obs;

  for(m in 1:n){
    log_mu[m] = U + log_sum_exp(
      log_inv_logit(L),
      log1m_inv_logit(L) + log_inv_logit(exp(alpha) * x[m])
      );
  };

  // could easily work on the log scale and use log1p_exp here
  common_term = log1p_exp(2 * (log_sigma - log_mu));
  for (i in 1:n){
    y_obs[i] = lognormal_rng(
      log_mu[i] - common_term[i]/2,
      sqrt(common_term[i])
      );
  };
}
