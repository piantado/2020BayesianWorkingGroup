data {
    int NROWS; 
    real x[NROWS];
}

transformed data {
}

parameters {
    real h;    
    real<lower=0> s;
}
    
transformed parameters {
}
    
model { 
    
    // normal prior on mean
    h ~ normal(0,10);
    
    // exponential prior for sd
    s ~ exponential(10.0);    
    
    for(i in 1:NROWS) {
        x[i] ~ normal(h,s);
    }
    
}
