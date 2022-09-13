rr <- rnorm(50000, 0, 1)
sd(exp(rr*sr))

sr <- 2
hist(rr*sr)
hist(exp(rr*sr))

sqrt((exp(sr^2) - 1)*exp(sr^2))

sd(rr*sr)


sd(rlnorm(50000))

sqrt((exp(1) - 1)*exp(1))

hist(1/(exp(rr*sr)))
sd(1/(exp(rr*sr)))
mean(1/(exp(rr*sr)))

curve(dlnorm(x, 0, 1), xlim = c(0, 20))

plot(density(rlnorm(5e5)), xlim = c(0, 20))
curve(dlnorm(x, 0, 1), xlim = c(0, 20), add = TRUE)

plot(density(1/(rlnorm(5e5))), xlim = c(0, 20))
curve(dlnorm(x, 0, 1), xlim = c(0, 20), add = TRUE)



curve(dlnorm(x, 0, 1), xlim = c(0, 20))


# mean depends only on variance
mean(1/rlnorm(5e5))
exp(.5)
mean(1/rlnorm(5e5, sdlog = 1.5))
exp((1.5^2)/2)


curve(1 - .25*(x - 1)^2*(exp(.6^2)-1), xlim = c(0, 12))


curve(exp(x) - 1)



mean_exp <- function(m, l, r, t, s){
  m - (m - l) * exp(-r*t +  s^2/2)*(1 - (t*(t-1)/2)*exp(s^2*(t-1)/2)*(exp(s^2)-1))
}


curve(mean_exp(m = 90, l = 20, r = .02, t = x, s = .3), xlim = c(0, 40))
curve(mean_exp(m = 90, l = 20, r = .2, t = x, s = .3), xlim = c(0, 40))
curve(mean_exp(m = 90, l = 20, r = .02, t = x, s = 1.3), xlim = c(0, 40))
curve(mean_exp(m = 90, l = 20, r = .002, t = x, s = 1.3), xlim = c(0, 12))

curve(mean_exp(m = 90, l = 10, r = .002, t = x, s = .09), xlim = c(0, 12))


# exponential decay with random variation:

library(tidyverse)

approx_2nd <- function(M, s, a){
  function(t){
    A <- exp(a + .5*s^2)
    M * exp(-A*t) * (1 + A^2 * (.5*t^2) * (exp(s^2) - 1))
  }
}

curve(approx_2nd(1, .4, -2)(x), xlim = c(1,20))


n_indiv <- 50
sd_lnscale <- 1.5
ln_ri <- rnorm(n_indiv, mean = 0, sd = sd_lnscale)
ln_rbar <- -4
M0 <- 200

# add normal errors
decay <- expand_grid(id = 1:n_indiv, t = 0:50) |>
  mutate(r = exp(ln_rbar + ln_ri[id]),
         mass = M0*exp(-r*t),
         obs = rnorm(n = length(mass), mean = mass, sd = 1))

# average of all at each time t
mean_decay <- decay |>
  group_by(t) |>
  summarize(mean_avg = mean(mass))

decay |>
  ggplot(aes(x = t, y = mass, group = id)) +
  geom_line() +
  geom_line(aes(x = t, y = mean_avg), inherit.aes = FALSE, data = mean_decay, col = "red", size = 4) +
  stat_function(fun = function(t) M0*exp(-t*exp(ln_rbar)), inherit.aes = FALSE, col = "blue", size = 3) +
  stat_function(fun = function(x) approx_2nd(M = M0, s = sd_lnscale, a = ln_rbar)(x),
                inherit.aes = FALSE, col = "green", size = 2)


decay |>
  ggplot(aes(x = t, y = mass, group = id)) +
  geom_line() +
  geom_line(aes(x = t, y = mean_avg), inherit.aes = FALSE, data = mean_decay, col = "red", size = 4) +
  stat_function(fun = function(t) M0*exp(-t*exp(ln_rbar)), inherit.aes = FALSE, col = "blue", size = 3) +
  stat_function(fun = function(t, s = 1) M0 * exp(-t*exp(ln_rbar + (s^2)/2)) * (1 + .5*(t^2) * exp(2*ln_rbar + s^2) * (exp(s^2) - 1)),
                inherit.aes = FALSE, col = "green", size = 2)


approx_2nd_notlnorm <- function(M, s, a){
  function(t){
    M * exp(-exp(a)*t) * (1 + exp(2*a) * (.5*t^2) * s^2)
  }
}

curve(approx_2nd_notlnorm(30, 2, 1.2)(x), xlim = c(0, 30))

decay |>
  ggplot(aes(x = t, y = mass, group = id)) +
  geom_line() +
  geom_line(aes(x = t, y = mean_avg), inherit.aes = FALSE, data = mean_decay, col = "red", size = 4) +
  stat_function(fun = function(t) M0*exp(-t*exp(ln_rbar)), inherit.aes = FALSE, col = "blue", size = 3) +
  stat_function(fun = function(x) approx_2nd_notlnorm(M = M0, s = sd_lnscale, a = ln_rbar)(x),
                inherit.aes = FALSE, col = "green", size = 2)

