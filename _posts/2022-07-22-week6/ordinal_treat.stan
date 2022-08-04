data {
  int<lower=0> n;
  array[n] int<lower=0> surv;
  array[n] int<lower=0> density;
  int<lower=1> n_dens;
  int<lower=1> n_pred;
  int<lower=1> n_size;
  array[n] int<lower=1,upper=n_dens> dens_id;
  array[n] int<lower=1,upper=n_pred> pred_id;
  array[n] int<lower=1,upper=n_size> size_id;
}
transformed data{
  // matrix of contrasts for polynomial contrats
  matrix[3, 3] contr = [
    [1.0, -.7071068,  0.4082483],
    [1.0, 0.0      , -0.8164966],
    [1.0,  .7071068,  0.4082483]
    ];

    int n_combn = n_dens * n_pred * n_size;
}
parameters {
  array[n_pred,n_size] vector[n_dens] Poly;
  real<lower=0> trt_sd;
}
model {
  trt_sd ~ exponential(1);

  for (j in 1:n_pred){
    for(k in 1:n_size){
      Poly[j, k] ~ normal(0, trt_sd);
    }
  }

  for (i in 1:n){
    surv[i] ~ binomial_logit(density[i], contr[ dens_id[i],  ] * Poly[ pred_id[i], size_id[i] ] );
  }

}
generated quantities{
  array[n_combn] real pred;
  {
    int h = 1;
    for (i in 1:n_dens){
      for (j in 1:n_pred){
        for (k in 1:n_size){
          pred[h] = contr[i, ] * Poly[j, k];
          h += 1;
        }
      }
    }
  }
}
