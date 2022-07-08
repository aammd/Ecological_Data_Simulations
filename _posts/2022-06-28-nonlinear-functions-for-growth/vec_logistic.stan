data {
  int<lower=0> n;
  vector[n] x;
}
parameters {
  real L;
  real alpha;
}
model {
  L ~ normal(-1, 1);
  alpha ~ normal(-.8, 1.3);
}
generated quantities{
  vector[n] y;
  y = inv_logit(L) + (1-inv_logit(L)) * inv_logit(exp(alpha) * x);
}
