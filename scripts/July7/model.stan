// Bayesian analysis to find w

data {
    int NROWS; 
    real n1[NROWS];
    real n2[NROWS];
    int  ntrials[NROWS];
    int  ncorrect[NROWS];
}

transformed data {
}

parameters {
    real<lower=0> w;
}
    
transformed parameters {
}
    
model { 
    
    // see steve's boring paper
    w ~ exponential(1);
    
    // the likelihood
    for(i in 1:NROWS) {
        real mysd = w*sqrt(n1[i]^2 + n2[i]^2);
        real mymu = fabs(n1[i] - n2[i]);
        
        // this gives P(Z<0): exp(normal_lcdf( 0 | mymu, mysd))
        real p = 1.0-exp(normal_lcdf( 0 | mymu, mysd)); // P(Z>0) - what is the probability that the difference is positive
        // NOTE: p also equals the probabliity I answer correctly
        
        // likelihood: a coin flip with probability p
        ncorrect[i] ~ binomial(ntrials[i], p);
    }
    
}
