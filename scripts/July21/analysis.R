library(ggplot2)
library(rstan)

d <- read.csv("Tsimane-2012.csv", header=T)
d <- subset(d, !(is.na(d$n1) | is.na(d$n2) | is.na(d$ncorrect) | is.na(d$ntrials)))

# convert subject numbers to starting from zero
d$subject <- as.numeric(as.factor(d$subject))

stan.data <- list(NROWS=nrow(d), NSUBJ=max(d$subject), n1=d$n1, n2=d$n2, ntrials=d$ntrials, ncorrect=d$ncorrect, subject=d$subject, math=d$math)

# This is the part that actually runs stan:
fit <- stan(file="model2.stan", data=stan.data, iter=5000, chains=2, cores=2)
        
        
