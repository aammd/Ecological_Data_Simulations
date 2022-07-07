data {
  int<lower=2> K;
  int<lower=0> N;
  array[K] real breaks;
  array[N] int<lower=1, upper=K> y;
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
}
model {
  mu ~ std_normal();
  sigma ~ exponential(1);
  y ~ categorical(exp(theta_norm));
}
