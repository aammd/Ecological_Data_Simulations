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
model {
  mu ~ std_normal();
  sigma ~ exponential(1);

  vector[K] theta;
  theta[1] = normal_lcdf(breaks[1] | mu, sigma);
  for (k in 2:K) {
    theta[k] = log_sum_exp(
          normal_lcdf(breaks[k  ] | mu, sigma),
       -1*normal_lcdf(breaks[k-1] | mu, sigma)
      );
  }
  y ~ categorical(exp(theta));
}
