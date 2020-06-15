
# Rejection sampler

xes <- seq(0,10,.1)

# defined an arbitrary function
f <- function(x) {
    exp(x**1.5 - 3*x)
}

samples <- NULL
for(i in 1:100000) {

    # pick a random x,y location in big rectangle
    # (big enough to contain all of f)
    x <- sample(xes,1)
    y <- runif(1,0,6)
    
    # Keep x,y if it falls on a bar
    if( y < f(x) ) {
        samples <- c(samples, x)
    }
}

# Look at distribution:
hist(samples, breaks=xes)
