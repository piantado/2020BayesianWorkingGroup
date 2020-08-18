library(ggplot2)
library(rstan)

d <- read.csv("alldata.csv", header=T)

stan.data <- list(NROWS=nrow(d), 
                  NSUBJ=max(d$SubjCode), 
                  n1=d$n1, 
                  n2=d$n2, 
                  ntrials=rep(1,nrow(d)), 
                  ncorrect=d$Accuracy, 
                  subject=d$SubjCode, 
                  typecode=d$TypeCode)

# This is the part that actually runs stan:
fit <- stan(file="model1.stan", data=stan.data, iter=1000, chains=2, cores=2) #, control=list(adapt_delta=0.99) )
        
        
