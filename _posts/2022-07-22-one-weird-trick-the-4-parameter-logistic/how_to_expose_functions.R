func <- "functions {
  real f1 (real m, real u, real log_alpha, real x) {
    return log(exp(m) + (exp(u) - exp(m)) * inv_logit(exp(log_alpha) * x));
  }

    real f2 (real m, real u, real log_alpha, real x) {
    return log(exp(m) + (exp(u) - exp(m)) ./ (1 + exp(-exp(log_alpha) * (x))));
  }

    real f3 (real m, real u, real log_alpha, real x) {
     real f = log( (exp(u) - exp(m)) / exp(m) );

    return m + log1p(exp(f) * inv_logit(exp(log_alpha) * x));
  }

    real f4 (real m, real u, real log_alpha, real x) {
      real f = log( (exp(u) - exp(m)) / exp(m) );
    return m + log1p_exp(f - log1p_exp(-exp(log_alpha) * x));
  }

    real f5 (real m, real u, real log_alpha, real x) {
      real f = log( (exp(u) - exp(m)) / exp(m) );
    return m + log1p_exp(f + log_inv_logit(exp(log_alpha) * x));
  }

  real f7 (real m, real u, real log_alpha, real x) {
    return m + log_inv_logit(u) + log1p_exp(log_inv_logit(exp(log_alpha) * x) - u);
  }

}"

stanfile <- cmdstanr::write_stan_file(code = func)

source("https://raw.githubusercontent.com/rok-cesnovar/misc/master/expose-cmdstanr-functions/expose_cmdstanr_functions.R")


f <- expose_cmdstanr_functions(stanfile)


L <- 0.5567503
U <- 2.359621
log_alpha <- -1.304145
x <- -0.006315413

f$f1(m = log(L), u = U, log_alpha = log_alpha, x = x)

f$f2(m = log(L), u = U, log_alpha = log_alpha, x = x)

f$f3(m = log(L), u = U, log_alpha = log_alpha, x = x)

f$f4(m = log(L), u = U, log_alpha = log_alpha, x = x)

f$f5(m = log(L), u = U, log_alpha = log_alpha, x = x)


xx <- seq(from = -5, to = 5, length.out = 50)
yy <- sapply(xx, function(s) f$f7(log(40), -2, 0, s))
plot(xx, exp(yy), type = "b")


