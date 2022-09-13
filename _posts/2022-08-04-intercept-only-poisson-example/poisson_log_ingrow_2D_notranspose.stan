// adding 2D random effects
data {
  int<lower=0> n;
  int<lower=0> nplot;
  array[n] int plot_id_num;
  int<lower=0> nspp;
  array[n] int spp_id_num;
  array[n] int abd;
  vector[n] deltaT;
}
parameters {
  real mbar;
  real pbar;
  vector[nplot] p_plot;
  real<lower=0> sd_plot;
  matrix[2,nspp] z_spp;
  cholesky_factor_corr[2] L_Rho_spp;
  vector<lower=0>[2] sigma_spp;
}
transformed parameters{
  matrix[2, nspp] spp_effects;
  spp_effects = diag_pre_multiply(sigma_spp, L_Rho_spp) * z_spp;
}
model {
  vector[n] lambda;
  vector[n] p_j;
  vector[n] m_log;

  // i THINK that the first element is m, the second p

  sigma_spp[1] ~ exponential(1);
  sigma_spp[2] ~ exponential(2);

  mbar ~ normal(1.6, .8);
  pbar ~ normal(0, .5);
  p_plot ~ std_normal();
  sd_plot ~ exponential(1);
  to_vector(z_spp) ~ std_normal();
  L_Rho_spp ~ lkj_corr_cholesky( 2.1 );

  for(i in 1:n){
    m_log[i] = mbar + spp_effects[1, spp_id_num[i]];

    p_j[i] = pbar + p_plot[plot_id_num[i]]*sd_plot  + spp_effects[2, spp_id_num[i]];

  }


  lambda = m_log +
  log1m_exp(deltaT .* log_inv_logit(p_j)) -
  log1m_inv_logit(p_j);

  abd ~ poisson_log(lambda);
}
generated quantities{
  vector[n] p;
  vector[n] m;
  matrix[2,2] Rho_spp;

  Rho_spp = multiply_lower_tri_self_transpose(L_Rho_spp);

  for(i in 1:n){
    m[i] = exp(mbar + spp_effects[1, spp_id_num[i]]);

    p[i] = exp(pbar + p_plot[plot_id_num[i]]*sd_plot  + spp_effects[2 , spp_id_num[i]]);

  }

}

