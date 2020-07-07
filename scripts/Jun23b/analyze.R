library(rstan)

d <- data.frame(x=c(1,   2,   3,   4), 
                y=c(1.3, 4.5, 4.4, 5.5))
                
# translate between stan's variables names and the data's
stan.data <- list(NROWS=nrow(d), x=d$x, y=d$y) 

# This is the part that actually runs stan:
fit <- stan(file="model.stan", data=stan.data, iter=5000, chains=2, cores=1)

# traceplot(fit)
# hist(extract(fit, "h")$h)

# For next time: run on a real dataset, plot the joint distribution of b0,b1
