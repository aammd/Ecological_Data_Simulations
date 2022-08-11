data {
  int<lower=0> n;
  array[n] int abd;
  vector[n] deltaT;
}
parameters {
  real<lower=0> m;
  real<lower=0,upper=1> p;
}
model {
  vector[n] lambda;

  m ~ lognormal(1.6, .8);
  p ~ beta(2, 2);

  lambda = m*(1 - p^deltaT)/(1 - p);

  abd ~ poisson(lambda);
}
