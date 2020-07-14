// Bayesian analysis to find w

data {
    int NROWS; 
    int NSUBJ;
    real n1[NROWS];
    real n2[NROWS];
    int  ntrials[NROWS];
    int  ncorrect[NROWS];
    int  subject[NROWS];
}

transformed data {
}

parameters {
    real<lower=0> w;
    
    real<lower=0>  subject_sd;
    real           subject_w[NSUBJ];
}
    
transformed parameters {
}
    
model { 
    
    w ~ exponential(1);
    subject_sd ~ exponential(1);
    
    for(s in 1:NSUBJ) {
         subject_w[s] ~ normal(0,subject_sd);
    }
    
    // the likelihood
    for(i in 1:NROWS) {
        // Note in this format, the subject effects are multiplicative
        // exp(log(w) + log(exp(subject_w[subject[i]])) = exp(log(w*exp(subject_w[subject[i]]))) 
        //                                               = w * exp(subject_w[subject[i]])
        real logw = log(w) + subject_w[subject[i]];

        real mysd = exp(logw)*sqrt(n1[i]^2 + n2[i]^2);
        real mymu = fabs(n1[i] - n2[i]);
                
        // likelihood: a coin flip with probability p
        real p = 1.0-exp(normal_lcdf( 0 | mymu, mysd)); 
        ncorrect[i] ~ binomial(ntrials[i], p);
    }
    
}
