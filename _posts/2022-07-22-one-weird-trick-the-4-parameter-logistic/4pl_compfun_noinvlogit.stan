data {
  int<lower=0> N;
  matrix[N,2] x;
  vector[N] y_obs;
}
parameters {
  real m;
  real f;
  // real log_alpha;
  // real beta;
  vector[2] b;
  real log_sigma;
}
model {
  m ~ normal(-1, 1);
  f ~ normal(7, 1);
  // log_alpha ~ normal(0, 1);
  // beta ~ normal(0, 1);
  b[1] ~ std_normal();
  b[2] ~ uniform(-5, 0);
  log_sigma ~ normal(0, 1);

  // model
  // make a vector to hold the log prop
  vector[N] log_mu;
  vector[N] common_term;

  // \\ profile here -- what is the slow part!? better way to get logistic coefs? matrix multiplication instead, using transpars?

  vector[N] ll = x * b;

  log_mu = m + log1p_exp(f - log1p_exp(ll));

  // could easily work on the log scale and use log1p_exp here
  common_term = log1p_exp(2 * (log_sigma - log_mu));

  target += lognormal_lpdf( y_obs | log_mu - common_term/2, sqrt(common_term));
}
generated quantities{
  // make a vector to hold the log prop
  vector[N] log_mu;
  // vector[N] common_term;
  // vector[N] y_gen;

  // calculate average
  vector[N] ll = x * b;

  log_mu = m + log1p_exp(f - log1p_exp(ll));

  // // calculate the parameters of the lognormal
  // common_term = log1p_exp(2 * (log_sigma - log_mu));
  // for (i in 1:N){
  //   y_gen[i] = lognormal_rng(
  //     log_mu[i] - common_term[i]/2,
  //     sqrt(common_term[i])
  //     );
  // };
}
