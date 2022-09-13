
data {
  int<lower=0> N;
  vector[N] obs_size;
  vector[N] time;
}
parameters {
  real<lower=0> r;
  real<lower=0> sigma_obs;
  real<lower=0> sigma_Lo;
  real<lower=0> Lmax;
  real<lower=0> mu_Lo;
}
model {
  vector[N] mu_obs;
  vector[N] var_growth;

  mu_obs = mu_Lo * exp(-r * time) + Lmax * (1 - exp(-r * time));

  var_growth = exp(-2*r*time)*sigma_Lo^2;

  obs_size ~ normal(mu_obs, sqrt(var_growth + sigma_obs^2));

  sigma_obs ~ lognormal(0, .5);
  sigma_Lo ~ lognormal(0, .5);
  r ~ lognormal(-2.5, .2);
  Lmax ~ lognormal(4.2, .5);
  mu_Lo ~ lognormal(2.7, .6);
}

