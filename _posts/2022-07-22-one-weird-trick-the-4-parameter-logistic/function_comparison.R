
function_compare_f_to_u <- cmdstanr::cmdstan_model("_posts/2022-07-22-one-weird-trick-the-4-parameter-logistic/spinkney_test.stan")

m <- rnorm(1, log(2), sd = .1)
f <- rnorm(1, log(10), sd = .1)
a <- rnorm(1, 0, .1)
b <- 0
x_vals <- runif(50, -6, 12)
y_mean <- m + log1p(exp(f - log1p(exp(-exp(a)*(x_vals - b)))))

plot(x_vals, exp(y_mean))

y_count <- rpois(length(y_mean), exp(y_mean))

plot(x_vals, y_count)

compare_results <- vector(mode = "list", length = 6L)

for(i in 1:6){
  compare_results[[i]] <- function_compare$sample(data = list(
    x_vals=x_vals,
    y_count = y_count,
    N = length(y_count),
    test = i), parallel_chains = 4, chains = 4, refresh = 0)
}

profile_results <- compare_results |>
  lapply(function(x) x$profiles()) |>
  lapply(do.call, what = rbind) |>
  setNames(nm = paste0("f", 1:6))

library(tidyverse)

plot_profile_results <- function(profres){

  time <- profres |>
    bind_rows(.id = "Function") |>
    ggplot(aes(x = Function,y = total_time)) + geom_point()
  time_by_diff <- profres |>
    bind_rows(.id = "Function") |>
    ggplot(aes(x = Function,y = total_time/autodiff_calls)) + geom_point()

    time + time_by_diff

}





function_compare_f_to_u <- cmdstanr::cmdstan_model("_posts/2022-07-22-one-weird-trick-the-4-parameter-logistic/spinkney_test_f_to_u.stan")

compare_results_fu <- vector(mode = "list", length = 7L)

for(i in 1:7){
  print(i)
  compare_results_fu[[i]] <- purrr::safely(function_compare_f_to_u$sample)(data = list(
    x_vals=x_vals,
    y_count = y_count,
    N = length(y_count),
    test = i), parallel_chains = 4, chains = 4, refresh = 0)#, init = 0)
}

profile_results_fu <- compare_results_fu |>
  lapply(function(x) x$profiles()) |>
  lapply(do.call, what = rbind) |>
  setNames(nm = paste0("f", 1:6))

library(tidyverse)
library(patchwork)

time <- profile_results_fu |>
  bind_rows(.id = "Function") |>
  ggplot(aes(x = Function,y = total_time)) + geom_point()
time_by_diff <- profile_results_fu |>
  bind_rows(.id = "Function") |>
  ggplot(aes(x = Function,y = total_time/autodiff_calls)) + geom_point()
time + time_by_diff


## just the binomial



binomial_compare <- cmdstanr::cmdstan_model("_posts/2022-07-22-one-weird-trick-the-4-parameter-logistic/binomial_comparison.stan")


y_count <- rbinom(42, size = 30, prob = .4)


compare_results_bin <- vector(mode = "list", length = 6L)

for(i in 1:6){
  compare_results_bin[[i]] <- binomial_compare$sample(data = list(
    y_count = y_count,
    N = length(y_count),
    test = i), parallel_chains = 4, chains = 4, refresh = 0)
}


compare_results_bin



profile_results_bin <- compare_results_bin[1:5] |>
  lapply(function(x) x$profiles()) |>
  lapply(do.call, what = rbind) |>
  setNames(nm = paste0("f", 1:5))

library(tidyverse)
library(patchwork)

time <- profile_results_bin |>
  bind_rows(.id = "Function") |>
  ggplot(aes(x = Function,y = total_time)) + geom_point()
time_by_diff <- profile_results_bin |>
  bind_rows(.id = "Function") |>
  ggplot(aes(x = Function,y = total_time/autodiff_calls)) + geom_point()
time + time_by_diff



### test a function

upper <- 40
lower_prop_logit <- -2

curve(
  exp(log(upper) + plogis(lower_prop_logit, log.p = TRUE) + log1p(exp( -lower_prop_logit + plogis(x, log.p = TRUE)   ))),
  xlim = c(-5,5), ylim = c(0, upper))


function_compare_f_to_u$sample(data = list(
  x_vals=x_vals,
  y_count = y_count,
  N = length(y_count),
  test = 7), parallel_chains = 1, chains = 1, refresh = 0, init = 0)
.




# factor out max and prop -------------------------------------------------



max_and_prop <- cmdstanr::cmdstan_model("_posts/2022-07-22-one-weird-trick-the-4-parameter-logistic/factor_out_max_and_prop.stan")

upper

upper <- rnorm(1, log(2), sd = .1)
prop <- rnorm(1, log(10), sd = .1)
a <- rnorm(1, 0, .1)
b <- 0
x_vals <- runif(50, -6, 12)
y_mean <- m + log1p(exp(f - log1p(exp(-exp(a)*(x_vals - b)))))

plot(x_vals, exp(y_mean))

y_count <- rpois(length(y_mean), exp(y_mean))

plot(x_vals, y_count)

sampy <- max_and_prop$sample(data = list(
  x_vals=x_vals,
  y_count = y_count,
  N = length(y_count)),
  parallel_chains = 4, chains = 4, refresh = 0, init = 0)

sampy$profiles()

sampy$summary()

library(tidybayes)
model_mean <- gather_rvars(sampy, mu[i])
model_mean |>
    ungroup() |>
    mutate(x = x_vals[i]) |>
    ggplot(aes(x = x, dist = .value)) +
    stat_dist_lineribbon() +
    geom_point(aes(x = x_vals, y = y_count), inherit.aes = FALSE,
               data = data.frame(x_vals, y_count))
