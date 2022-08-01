data {
  int<lower=0> N;
  int<lower=0> S;
  array[N] int<lower=1,upper=S> sp;
  vector[N] x_vals;
  vector[N] y_meas;
}
parameters {
  real m_bar;
  real l_bar;
  real a_bar;
  vector<lower=0>[3] sds;
  real log_sigma;
   //noncentered
  matrix[S, 3] z;
}
transformed parameters{
  matrix[S, 3] adj;
  adj = diag_post_multiply(z, sds);
}
model {
  m_bar ~ normal(4, .5);
  l_bar ~ normal(-2.3, .5);
  a_bar ~ normal(0, .5);
  sds ~ exponential(5);
  log_sigma ~ normal(-.7, .2);
  to_vector(z) ~ std_normal();


  // model
  // make a vector to hold the log prop
  vector[N] log_mu;

  vector[N] m_sp = m_bar + adj[sp,1];
  vector[N] l_sp = l_bar + adj[sp,2];
  vector[N] X_sp = x_vals .* exp(a_bar + adj[sp, 3]);

  log_mu = m_sp + log_inv_logit( l_sp ) + log1p(inv_logit( X_sp ) .* exp( -l_sp ));


  vector[N] common_term;
  common_term = log1p_exp(2 * (log_sigma - log_mu));

  profile("likelihood"){
    y_meas ~ lognormal(log_mu - common_term/2, sqrt(common_term));
  }
}
generated quantities{
  // vector[S] sp_m;
  // vector[S] sp_f;
  // vector[S] sp_a;
  // sp_m = m_bar + z_m*m_sd;
  // sp_f = f_bar + z_f*f_sd;
  // sp_a = a_bar + z_a*a_sd;
  // vector[N] post_log_mu;
  // vector[N] ll = x_vals .* exp(sp_a[sp]) * (-1.0);
  //
  // post_log_mu = sp_m[sp] + log1p_exp(sp_f[sp] - log1p_exp(ll));
}
