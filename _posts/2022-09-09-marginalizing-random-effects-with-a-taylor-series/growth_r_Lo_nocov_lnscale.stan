
data {
  int<lower=0> N;
  vector[N] obs_size;
  vector[N] time;
}
parameters {
  real<lower=0> r;
  real<lower=0> sigma_obs;
  real<lower=0> sigma_Lo;
  real<lower=0> sigma_r;
  real ln_Lmax;
  real logit_Lo;
}
model {
  vector[N] ln_mu_obs;
  vector[N] var_growth;

  ln_mu_obs = ln_Lmax + log1m_exp(log_inv_logit(logit_Lo) - r * time + log1p(.5 * square(sigma_r) * square(time)));

  var_growth = exp(-2*r*time + log_inv_logit(logit_Lo) + ln_Lmax) * square(sigma_r) .* square(time) + exp(-2*r*time) * square(sigma_Lo);

  obs_size ~ normal(exp(ln_mu_obs), sqrt(var_growth + square(sigma_obs)));

  sigma_obs ~ exponential(3);
  sigma_Lo ~ exponential(1);
  sigma_r ~ exponential(1);
  r ~ lognormal(-2.5, .2);
  ln_Lmax ~ normal(4.2, .5);
  logit_Lo ~ normal(-1, .3);
}
generated quantities{
  real Lmax;
  real Lo;

  Lmax = exp(ln_Lmax);

  Lo = (1 - inv_logit(logit_Lo))*Lmax;

}

