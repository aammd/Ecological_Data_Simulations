data {
  int<lower=0> n;
  array[n] int last_abd;
  array[n] int abd;
  array[n] int<lower=0,upper=1> is_first;
  vector[n] deltaT;
}
parameters {
  real<lower=0> lambda;
  real<lower=0,upper=1> p;
}
model {
  vector[n] mu;

  lambda ~ lognormal(1, 1);
  p ~ beta(70, 100);

  for (i in 1:n){
    if (is_first[i] == 0){
      mu[i] =  last_abd[i] * p^deltaT[i] + lambda * (1 - p^(deltaT[i] + 1)) / (1 - p);
    } else if (is_first[i] == 1){
      mu[i] = lambda/(1 - p);
    }
}
  abd ~ poisson(mu);
}
