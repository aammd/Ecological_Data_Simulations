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
  real<lower=0> m_sd;
  real<lower=0> f_sd;
  real<lower=0> a_sd;
  real log_sigma;
   //noncentered
  vector[S] z_m;
  vector[S] z_f;
  vector[S] z_a;
}
transformed parameters{
  vector[S] sp_m;
  vector[S] sp_f;
  vector[S] sp_a;
  sp_m = m_bar + z_m*m_sd;
  sp_f = f_bar + z_f*f_sd;
  sp_a = a_bar + z_a*a_sd;
}
model {
  m_bar ~ normal(.69, .15);
  f_bar ~ normal(2.3, .1);
  a_bar ~ normal(0, .1);
  m_sd ~ exponential(10);
  f_sd ~ exponential(10);
  a_sd ~ exponential(1);
  log_sigma ~ normal(-.7, .1);
  z_m ~ std_normal();
  z_f ~ std_normal();
  z_a ~ std_normal();


  // model
  // make a vector to hold the log prop
  vector[N] log_mu;
  vector[N] ll;

  ll = x_vals .* exp(sp_a[sp]) * (-1.0);

  log_mu = sp_m[sp] + log1p_exp(sp_f[sp] - log1p_exp(ll));


  vector[N] common_term;
  common_term = log1p_exp(2 * (log_sigma - log_mu));

  y_meas ~ lognormal(log_mu - common_term/2, sqrt(common_term));
}
generated quantities{
  vector[N] post_log_mu;
  vector[N] ll = x_vals .* exp(sp_a[sp]) * (-1.0);

  post_log_mu = sp_m[sp] + log1p_exp(sp_f[sp] - log1p_exp(ll));
}
