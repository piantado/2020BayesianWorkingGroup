// Bayesian analysis to find w

data {
    int NROWS; 
    int NSUBJ;
    real n1[NROWS];
    real n2[NROWS];
    int  ntrials[NROWS];
    int  ncorrect[NROWS];
    int  subject[NROWS];
    real math[NROWS];
}

transformed data {
}

parameters {
    real logw; 
    
    real<lower=0>  subject_scale;
    real           subject_w[NSUBJ];
    
    real beta_math;
}
    
transformed parameters {
}
    
model { 
    
    
    // different prior: 1/w
    // P(x) = 1/x
    // integrate P(x) from 0,\infinity = \infinity
    // log(1/x) = -log(x)
    target += -logw; // this is the same as P(w) = 1/w prior
    // "target" is internally defined by stan as the log posterior
    
    subject_scale ~ exponential(1);
    
    beta_math ~ normal(0,10);
    
    for(s in 1:NSUBJ) {
         subject_w[s] ~ normal(0,1); 
    }
    
    // the likelihood
    for(i in 1:NROWS) {
        real myw = logw + subject_w[subject[i]]*subject_scale + beta_math*math[i];
        
        real mysd = exp(myw)*sqrt(n1[i]^2 + n2[i]^2);
        real mymu = fabs(n1[i] - n2[i]);
                
        // likelihood: a coin flip with probability p
        real p = 1.0-exp(normal_lcdf( 0 | mymu, mysd)); 
        ncorrect[i] ~ binomial(ntrials[i], p);
    }
    
}
