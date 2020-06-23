data {
    int NROWS; 
    real x[NROWS];
}

transformed data {
}

parameters {
    real h;    
}
    
transformed parameters {
}
    
model { 
    
    // normal prior
    h ~ normal(0,10);
    
    for(i in 1:NROWS) {
        x[i] ~ normal(h,10);
    }
    
}
