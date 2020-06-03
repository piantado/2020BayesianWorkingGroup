
# Coin flipping example
# observe some sequence H,T
# Hypotheses: 
#   H1: P(heads) = 0.5
#   H2: P(heads) = 0.75
#   H3: P(heads) = 0.25

# MAIN ASSUMPTION: Our beliefs about H1,H2,H3 are going to be captured by a probability distribution
# P(H1) + P(H2) + P(H3) = 1

# Bayesian inference - tell us what to believe when we see data
# Combine two sources of information:
#   Priors - what you believe before you see data
#            (so priors are a distribution on hypotheses)
# One prior
#   P(H1) = P(H2) = P(H3) = 1/3
#   P(H1) = 0.9, and P(H2) = P(H3) = 0.05

#   P(H1) = v, and P(H2) = P(H3) = (1-v)/2


#           P(H1)     P(H2)    P(H3)
prior <- c(1.0/3.0, 1.0/3.0, 1.0/3.0)



# Second piece of Bayesian inference:
#   Likelihood - how well any hypothesis explains the data (technically, what probability does each hypothesis assign to the data)

# data = H,H,T = { H:2, T:1 } -- two heads and one tail
nH <- 2
nT <- 1

#   P(data | H1) - what probability does H1 assign to the data
likelihood <- c(dbinom(nH, nH+nT, 0.5), # H1
                dbinom(nH, nH+nT, 0.75), # H2
                dbinom(nH, nH+nT, 0.25)) # H3
                
# dbinom(nH, nH+nT, 0.75) -> 0.75*0.75*(1-.75)
# HHT HTH THH

# Bayes rule says this:
# P(H1 | data) is proportional to P(data | H1) P(H1)
# posterior                       likelihood   prior

# P(A|B) = P(A,B) / P(B)
# P(A,B) = P(A|B) P(B)
# P(B,A) = P(B|A) P(A)
# Put together (2) and (3): 
# P(A|B) P(B) = P(B|A) P(A)
# P(B|A) is proportional to P(A|B) P(B) 
# P(H1 | data) is proportional to P(data | H1) P(H1)

# P(H1 | data) = P(data | H1) P(H1) / P(data)

# Use Bayes rule to compute posteriors:

posterior = prior*likelihood / sum(prior*likelihood)
# P(data) = sum(prior*likelihood)


# Dutch book arguments

# What is P(data)
# definition of marginal probability
# P(A) = sum over b P(A|B=b) P(b)
# P(data) = sum over H of P(data | H) P(H)



