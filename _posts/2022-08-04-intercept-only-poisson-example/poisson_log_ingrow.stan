data {
  int<lower=0> n;
  array[n] int abd;
  vector[n] deltaT;
}
parameters {
  real m_log;
  real p_logit;
}
model {
  vector[n] lambda;

  m_log ~ normal(1.6, .8);
  p_logit ~ normal(0, .5);

  lambda = m_log + log1m_exp(deltaT * log_inv_logit(p_logit)) - log1m_inv_logit(p_logit);

  abd ~ poisson_log(lambda);
}
generated quantities{
  real m;
  real p;

  m = exp(m_log);
  p = inv_logit(p_logit);
}
