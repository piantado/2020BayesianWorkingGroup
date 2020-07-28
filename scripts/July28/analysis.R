library(ggplot2)
library(rstan)

d <- read.csv("data.csv", header=T)

stan.data <- list(NROWS=nrow(d), NSUBJ=max(d$id), NITEMS=max(d$which_item), correct=d$correct, which_subject=d$id, which_item=d$which_item)

# This is the part that actually runs stan:
fit <- stan(file="model.stan", data=stan.data, iter=1000, chains=2, cores=2)
        
        
