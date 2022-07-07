data {
  int<lower=2> K;
  int<lower=0> N;
  array[K] real breaks;
  array[K] int<lower=0> y;
}
parameters {
  real mu;
  real<lower=0> sigma;
}
transformed parameters{
  vector[K] theta;
  theta[1] = normal_lcdf(breaks[1] | mu, sigma);
  for (k in 2:K) {
    theta[k] = log_diff_exp(
          normal_lcdf(breaks[k  ] | mu, sigma),
          normal_lcdf(breaks[k-1] | mu, sigma)
      );
  }
  vector[K] theta_norm = theta - log_sum_exp(theta);
  // like this? or with multinomial_logit?
}
model {
  mu ~ std_normal();
  sigma ~ exponential(1);
  y ~ multinomial(exp(theta));
}
