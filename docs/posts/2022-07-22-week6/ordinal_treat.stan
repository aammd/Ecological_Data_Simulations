data {
  int<lower=0> n;
  array[n] int<lower=0> surv;
  array[n] int<lower=0> density;
  int<lower=1> n_dens;
  int<lower=1> n_pred;
  int<lower=1> n_size;
  array[n] int<lower=1,upper=n_pred> pred_id;
  array[n] int<lower=1,upper=n_size> size_id;
}
transformed data{
  // matrix of contrasts for polynomial contrats
  matrix[3, 3] contr = [
    [1.0, -.7071068,  0.4082483],
    [1.0, 0.0      , -0.8164966],
    [1.0,  .7071068,  0.4082483],
  ]
}
parameters {
  array[n_pred,n_size] vector[n_dens] Poly;
  real trt_mean;
  real<lower=0> trt_sd;
}
model {
  trt_sd ~ exponential(1);
  trt_mean ~ std_normal();
  to_vector(trt_effects_logit) ~ normal(0, trt_sd);

  for (i in 1:n){
    surv[i] ~ binomial_logit(density[i],
              trt_mean + contr[pred_id[i],]*Poly[pred_id[i], size_id[i]]);
  }

}
