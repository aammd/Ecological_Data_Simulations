data {
  int<lower=0> N;
  int<lower=0> S;
  array[N] int<lower=1,upper=S> sp;
  vector[N] x_vals;
  vector[N] y_meas;
}
parameters {
  real m_bar;
  real f_bar;
  real a_bar;
  vector<lower=0>[3] sds;
  real log_sigma;
   //noncentered
  matrix[S, 3] z;
}
transformed parameters{
  matrix[S, 3] adj;
  profile("post_multiply"){
    adj = diag_post_multiply(z, sds);
  }
}
model {
  m_bar ~ normal(.69, .15);
  f_bar ~ normal(2.3, .1);
  a_bar ~ normal(0, .1);
  sds[1] ~ exponential(10);
  sds[2] ~ exponential(10);
  sds[3] ~ exponential(1);
  log_sigma ~ normal(-.7, .1);
  to_vector(z) ~ std_normal();


  // model
  // make a vector to hold the log prop
  vector[N] log_mu;
  vector[N] ll;

  profile("logitpart"){
    ll = x_vals .* exp(a_bar + adj[sp,3]) * (-1.0);
  }

  vector[N] f = f_bar + adj[sp,2];
  vector[N] m = m_bar + adj[sp,1];

  profile("meanpart"){
    log_mu = m_bar + adj[sp,1] + log1p_exp(f_bar + adj[sp,2] - log1p_exp(ll));
  }

  profile("likelihood"){

    vector[N] common_term;
    common_term = log1p_exp(2 * (log_sigma - log_mu));

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
