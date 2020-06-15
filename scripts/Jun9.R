# What happens when we let there be more hypotheses
# e.g. what if we had a coin weight in [0,1]

logsumexp <- function(x) {
    m <- max(x)
    m + log(sum(exp(x-m))) 
}
# m + log(sum(exp(x-m))) 
# log(exp(m)) + log(sum(exp(x-m)))
# log(exp(m) sum(exp(x-m))) 
# log(sum(exp(m) exp(x-m)))
# log(sum(exp(x)))

h <- seq(0, 1, 0.01)

# uniform prior on h
#log.prior <-  rep(-log(length(h)), length(h)) # log(1/length(h))
log.prior <- -50*h # unnormalized
log.prior <- log.prior - logsumexp(log.prior) # normalize the prior
# exp(log.prior) = exp(log.prior - logsumexp(log.prior))
#                  exp(log.prior)/exp(logsumexp(log.prior))
#                  exp(log.prior)/sum(exp(log.prior))
#                      prior / sum(prior)

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
# P(H|DATA) = P(DATA|H) P(H) / P(DATA)
# log P(H|DATA) = log P(DATA|H) + log P(H) - log P(DATA)

#                log P(H)   log(DATA|H)      log(sum_H P(H) P(DATA|H))
log.posterior = log.prior+log.likelihood - logsumexp(log.prior+log.likelihood)

plot(h, exp(log.posterior), type="l")
lines(h, exp(weak.prior), col=4)
lines(h, exp(with.uniform), col=2)
