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
  // final result vector
  vector[n] y;
  // make a vector to hold the log proportions
  row_vector[2] logprop;
  logprop[1] = log_inv_logit(L);
  logprop[2] = log1m_inv_logit(L);
  // rep into a matrix
  matrix[n, 2] lp_mat = rep_matrix(logprop, n);
  // matrix for the curving part
  matrix[n, 2] logis_mat = append_col(rep_vector(0, n), log_inv_logit(exp(alpha)*x));
  // add them elementwise
  matrix[n, 2] ss = lp_mat + logis_mat;
  // log sum exp the rows

  for(m in 1:n){
    y[m] = log_sum_exp(ss[m]);
  };
}
