data {
  int<lower=0> n;
  vector[n] x;
}
parameters {
  real<lower=0, upper=1> L;
  real alpha;
}
model {
  L ~ beta(5, 14);
  alpha ~ normal(-.8, 1.3);
}
generated quantities{
  vector[n] y;
  for(m in 1:n){
    y[m] = log_mix(L, 0, log_inv_logit(exp(alpha) * x[m]));
  };
}
