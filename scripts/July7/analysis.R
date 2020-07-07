library(ggplot2)
library(rstan)

d <- read.csv("Tsimane-2012.csv", header=T)

# function: aggregate

plt <- ggplot(d, aes(x=n1, y=ncorrect)) +
        stat_summary(fun.y=mean, geom="point") + 
        stat_summary(fun.data=mean_se, geom="errorbar") +
        theme_bw()
    
# Main psychological claim:
# A number n is represented by Normal(n, w*n)

# Question: 
# suppose I have X = Normal(n1, w*n1) and Y = Normal(n2, w*n2)

# What is the probability that a sample from X will be greater than a sample from Y
# Answer: Think about the distribution X-Y
#           in particular think about P(X-Y>0)

# When X and Y are normal: X-Y is normal, and its variance is var(X)+var(Y), and its mean is mean(X)-mean(Y)

# so, the distribution of differences X-Y is
#   Normal(n1-n2, sqrt(w^2 * n1^2 + w^2 * n2^2))
#   Z = Normal(n1-n2, w*sqrt(n1^2 + n2^2))
# Z is the distribution of differences of samples

# if n1>n2 then P(Z > 0) is the probability that I answer correctly

# To do: use this ^^^ to do a Bayesian data analysis that infers w from the data

d <- subset(d, !(is.na(d$n1) | is.na(d$n2) | is.na(d$ncorrect) | is.na(d$ntrials)))


stan.data <- list(NROWS=nrow(d), n1=d$n1, n2=d$n2, ntrials=d$ntrials, ncorrect=d$ncorrect)

# This is the part that actually runs stan:
fit <- stan(file="model.stan", data=stan.data, iter=5000, chains=2, cores=2)
        
        
