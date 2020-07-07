// Very super simple regression model
// y = b0 + b1*x

data {
    int NROWS; 
    real x[NROWS];
    real y[NROWS];
}

transformed data {
}

parameters {
    real b0;
    real b1;
    real<lower=0> s;
}
    
transformed parameters {
}
    
model { 
    
    // normal prior
    b0 ~ normal(0,10);
    b1 ~ normal(0,10);
    
    s ~ exponential(1);
    
    for(i in 1:NROWS) {
        y[i] ~ normal(b0+b1*x[i],s);
    }
    
}
