
# Beliefs = probability distributions

# H - space of hypotheses
# P(H) - prior - beliefs before I see data (distribution on H)
# P(D|H) - likelihood - distribution on *data* - how well each H matches some observed data D

# P(H|D) - posterior - beliefs should I have about H *after* seeing data D (distribution on H)

# Bayes rule
# P(H|D) = P(H) P(D|H) / P(D)

# P(D) = sum of H of P(D|H)P(H) -- hard when H is infinite

# log P(H|D) = log P(H) + log P(D|H) - log P(D)
# log P(H|D) = log P(H) + log P(D|H) - "some constant"

# Samplers - instead of explicitly writing out all H, we deal with some collection of samples xi ~ P(H|D)

# The BIG MIRACLE - you can sample from P(H|D) without knowing P(D)

# Metropolis algorithm (Metropolis-Hastings)

#############################################

# Let's do Bayesian inference for a mean of some distribution

# H - all numbers (-inf,+inf)

# P(H) ~ Gaussian(0,10)

# Observations D:
D <- c(3.2, 5.6, 3.1)

# Likelihood P(D|H) ~ Gaussian centered on H with SD=1
log.posterior <- function(d,h) {
    # log prior                      sum(log likelihood | h for each data point)
    dnorm(h,mean=0,sd=10,log=TRUE) + sum(dnorm(d,mean=h,sd=10,log=TRUE))
}

# write a sampler for P(H|D)
samples <- NULL
h <- rnorm(1,mean=0,sd=10) # star h from the prior
for(i in 1:100000) {
    # Standing on h
    # Propose some new h'
    # If P(h'|D) > P(h|D), then always accept
    # or accept anyways with probability P(h'|D)/P(h|D)
    # otherwise, stay on h
    
    hprime <- rnorm(1,mean=h,sd=1) # create a proposal
    h.posterior      <- log.posterior(D,h)
    hprime.posterior <- log.posterior(D,hprime)
    
    if( hprime.posterior > h.posterior | 
        runif(1) < exp(hprime.posterior-h.posterior)) {
        # accept h' as the new h
        h <- hprime
    }
    # otherwise keep h 
    
    # keep track of all samples
    samples <- c(samples, h)    
}
# Samples should be drawn according to P(H|D)
hist(samples, breaks=seq(-20,20,.1))

# An important idea: detailed balance
# two regions A and B
# M(A->B) - probability of this algorithm moving from A to B
# IN(A) - probability that this algorithm is in region A
# IN(A) M(A->B) = IN(B) M(B->A)

# Time spent in A is proportional to P(A|D)

## Techniques that are important

# "burn in" - tossing the first samples
# Multiple runs (multiple chains)
# Diagnostics 


## Goal to do before next time:
## Modify the Metropolis code above to infer hypotheses which are both means AND standard deviations

# H - (-inf,+inf) for a mean AND some (0,+inf) for a SD
# samples - won't be an array, it'll be two columns (one for mean, one for SD)
# when you propose, you can flip a coin to decide whether to propose to the mean or the SD
# assume some prior on SD (e.g. ~ Exponential(1))
# never accept negative proposals to SD
