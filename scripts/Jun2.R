# Notes on logs:
# Negative because log(x)<0 for x<1
# log(a*b) = log(a) + log(b)
# log(a/b) = log(a) - log(b)
# NOT TRUE THAT log(a+b) = log(a)+log(b)

#                P(H1)     P(H2)    P(H3)
log.prior <- log(c(1.0/3.0, 1.0/3.0, 1.0/3.0))


# Second piece of Bayesian inference:
#   Likelihood - how well any hypothesis explains the data (technically, what probability does each hypothesis assign to the data)

# data = H,H,T = { H:2, T:1 } -- two heads and one tail
nH <- 2
nT <- 10000

#   P(data | H1) - what probability does H1 assign to the data
log.likelihood <- c(dbinom(nH, nH+nT, 0.5, log=TRUE), # H1
                    dbinom(nH, nH+nT, 0.75, log=TRUE), # H2
                    dbinom(nH, nH+nT, 0.25, log=TRUE)) # H3
                
# Use Bayes rule to compute posteriors:
#posterior = prior*likelihood / sum(prior*likelihood)
#log.posterior = log(prior*likelihood / sum(prior*likelihood))
#              = log(prior)+log(likelihood) - log(sum(prior*likelihood))
#             IS NOT EQUAL TO log(prior)+log(likelihood) - sum(log(prior) + log(likelihood))
log.posterior = log.prior + log.likelihood

# log posterior is equal to log(prior)+log(likelihood)-logsumexp(log.prior+log.likelihood)

#log(sum(prior*likelihood)) = logsumexp(log.prior+log.likelihood)

# logsumexp(x) = log(sum(exp(x)))
# i.e. logsumexp adds together probabilities when those probabilities are represented in log space
