data {
  int<lower=0> n;
  array[n] int<lower=0> surv;
  array[n] int<lower=0> density;
  int<lower=1> n_pred;
  int<lower=1> n_size;
  array[n] int<lower=1,upper=n_pred> pred_id;
  array[n] int<lower=1,upper=n_size> size_id;
}
parameters {
  matrix[n_pred,n_size] trt_effects_logit;
}
model {
  to_vector(trt_effects_logit) ~ std_normal();

  for (i in 1:n){
    surv[i] ~ binomial_logit(density[i], trt_effects_logit[pred_id[i], size_id[i]]);
  }

}
