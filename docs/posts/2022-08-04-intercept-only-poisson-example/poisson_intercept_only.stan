data {
  int<lower=0> n;
  int<lower=0> nspp;
  int<lower=0> nplot;
  int<lower=0> nyear;
  array[n] int<lower=1,upper=nspp> spp_id;
  array[n] int<lower=1,upper=nplot> plot_id;
  array[n] int<lower=1,upper=nyear> year_id;
  array[n] int<lower=0> recruits;
  vector[n] log_area;
  vector[n] log_deltayear;
}
parameters {
  real beta0;
  vector[nspp] betaspp;
  vector[nplot] betaplot;
  vector[nyear] betayear;
  vector<lower=0>[3] sigmas;
}
model {

  sigmas ~ exponential(.5);
  beta0 ~ normal(0, 1);

  betaspp ~ normal(0, sigmas[1]);
  betaplot ~ normal(0, sigmas[2]);
  betayear ~ normal(0, sigmas[3]);

  recruits ~ poisson_log(beta0 + betaspp[spp_id] + betaplot[plot_id] + betayear[year_id] + log_area + log_deltayear);
}
