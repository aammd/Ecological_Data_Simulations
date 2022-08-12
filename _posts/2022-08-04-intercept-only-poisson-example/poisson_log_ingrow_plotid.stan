data {
  int<lower=0> n;
  int<lower=0> nplot;
  array[n] int abd;
  array[n] int plot_id_num;
  vector[n] deltaT;
}
parameters {
  real m_log;
  real p_logit;
  vector[nplot] p_plot;
  real<lower=0> sd_plot;
}
model {
  vector[n] lambda;
  vector[n] p_j;

  m_log ~ normal(1.6, .8);
  p_logit ~ normal(0, .5);
  p_plot ~ std_normal();
  sd_plot ~ exponential(1);

  p_j = p_logit + p_plot[plot_id_num]*sd_plot;

  lambda = m_log +
  log1m_exp(deltaT .* log_inv_logit(p_j)) -
  log1m_inv_logit(p_j);

  abd ~ poisson_log(lambda);
}
generated quantities{
  real m;
  real p;

  m = exp(m_log);
  p = inv_logit(p_logit);
}
