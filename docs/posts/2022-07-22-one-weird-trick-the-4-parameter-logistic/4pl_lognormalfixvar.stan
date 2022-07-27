data {
  int<lower=0> N;
  vector[N] x_vals;
  vector[N] y_meas;
}
parameters {
  real m;
  real f;
  real log_alpha;
  real log_sigma;
}
model {
  m ~ normal(.69, .1);
  f ~ normal(2.3, .1);
  log_alpha ~ normal(0, .1);
  log_sigma ~ normal(-.7, .1);

  // model
  // make a vector to hold the log prop
  vector[N] log_mu;
  vector[N] ll = x_vals * exp(log_alpha) * (-1.0);

  log_mu = m + log1p_exp(f - log1p_exp(ll));


  vector[N] common_term;
  common_term = log1p_exp(2 * (log_sigma - log_mu));

  y_meas ~ lognormal(log_mu - common_term/2, sqrt(common_term));
}
generated quantities{
  vector[N] post_log_mu;
  vector[N] ll = x_vals * exp(log_alpha) * (-1.0);
  post_log_mu = m + log1p_exp(f - log1p_exp(ll));
}
