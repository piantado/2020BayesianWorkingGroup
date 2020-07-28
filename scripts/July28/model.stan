
data {
    int NROWS; 
    int NSUBJ;
    int NITEMS;
    
    int which_item[NROWS];
    int which_subject[NROWS];
    int correct[NROWS];
}

transformed data {
}

parameters {
    // subject effects
    real theta[NSUBJ]; 
    
    // item effect
    real b[NITEMS]; // intercepts
    real<lower=0> a[NITEMS]; // slopes
}
    
transformed parameters {
}
    
model { 
    // priors
    theta ~ normal(0,1); 
    b     ~ normal(0,1);
    a     ~ cauchy(0,1); // uniform? exponential? 
    
    // likelihood
    for(i in 1:NROWS) {
        real p = 1.0 / (1 + exp(-a[which_item[i]]*(theta[which_subject[i]] - b[which_item[i]]) ));
        
        // 1 / (1 + exp(-a(-b)))
        // 1 / (1 + exp(-(-1)*a(-(-1)*b))) = 1 / (1 + exp(-a(-b)))
        
        
        correct[i] ~ bernoulli(p);        
    }
    
}
