
data {
  int<lower=0> N;
  vector[N] obs_size;
  vector[N] time;
}
parameters {
  real<lower=0> r;
  real<lower=0> sigma_obs;
  real<lower=0> sigma_Lo;
  real ln_Lmax;
  real logit_Lo;
}
model {
  vector[N] ln_mu_obs;
  vector[N] var_growth;

  ln_mu_obs = ln_Lmax + log1m_exp(log_inv_logit(logit_Lo) - r * time);

  var_growth = exp(-2*r*time)*sigma_Lo^2;

  obs_size ~ normal(exp(ln_mu_obs), sqrt(var_growth + sigma_obs^2));

  sigma_obs ~ exponential(3);
  sigma_Lo ~ exponential(1);
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

