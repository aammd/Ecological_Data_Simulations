ln_a <- function(log_mu, log_sigma){
  common_term <- log1p(exp(2 * (log_sigma - log_mu)))
  log_mu - common_term
}

ln_b <- function(log_mu, log_sigma){
  common_term <- log1p(exp(2 * (log_sigma - log_mu)))
  sqrt(common_term)
}
