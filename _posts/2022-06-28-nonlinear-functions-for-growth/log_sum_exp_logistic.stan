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
  // make a vector to hold the log prop
  vector[n] y;
  for(m in 1:n){
    y[m] = log_sum_exp(
                      log_inv_logit(L),
                      log1m_inv_logit(L) + log_inv_logit(exp(alpha) * x[m])
                      );
  };
}
