# What happens when we let there be more hypotheses
# e.g. what if we had a coin weight in [0,1]

# log(a/b) = log(a) - log(b)

h <- seq(0, 1, 0.01)

# uniform prior on h
log.prior <-  rep(-log(length(h)), length(h)) # log(1/length(h))

# data = H,H,T = { H:2, T:1 } -- two heads and one tail
nH <- 1
nT <- 2

#   P(data | H1) - what probability does H1 assign to the data
log.likelihood <- rep(NA, length(h))
for(i in 1:length(h)) {
    log.likelihood[i] <- dbinom(nH, nH+nT, h[i], log=TRUE)
    # or see sapply
}
                
# Use Bayes rule to compute posteriors:
log.posterior = log.prior + log.likelihood

plot(h, log.likelihood)

plot(h, log.posterior)

plot(h, exp(log.posterior))

# Let's make a plot of prior and posterior 
# prior(h) is proportional to 1/h
# prior(h) is proportional to exp(-h)
# prior(h) is proportional to 1/(1-h)
