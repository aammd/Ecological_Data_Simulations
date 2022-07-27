data {
  int<lower=0> N;
  vector[N] x_vals;
  array[N] int y_count;
}
parameters {
  real m;
  real f;
  real log_alpha;
  // real beta;
}
model {
  m ~ normal(.69, .1);
  f ~ normal(2.3, .1);
  log_alpha ~ normal(0, .1);

  vector[N] log_mu;


  profile("meanpart"){
    log_mu = m + log1p_exp(f - log1p_exp(-exp(log_alpha) * x_vals));
  }

  y_count ~ poisson_log(log_mu);
}
// generated quantities{
//   vector[N] log_mu;
//   vector[N] ll = x_vals * exp(log_alpha) * (-1.0);
//   log_mu = m + log1p_exp(f - log1p_exp(ll));
// }
