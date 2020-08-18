// P(D|M1) P(M1)  proportional to P(M1 | D)
// P(D|M2) P(M2)  proportional to P(M2 | D)

// P(M1|D)/P(M2|D)

data {
    int NROWS; 
    int NSUBJ;
    int n1[NROWS];
    int n2[NROWS];
    int  ntrials[NROWS];
    int  ncorrect[NROWS];
    int  subject[NROWS];
    int  typecode[NROWS]; // 1=Simultaneous, 2=Sequential, 3=1-1
}

transformed data {
}

parameters {
    real logw;
    real overall_theta; // logit probability of canceling each item on 1-1 trials
    
    real<lower=0>  subject_scale;
    real subject_w[NSUBJ];
    
    real subject_theta[NSUBJ];
    real<lower=0> subject_theta_scale;
    
    real expt_W[3];
    real<lower=0> expt_W_scale;
}
    
transformed parameters {
}
    
model { 
    // P(Parameters | Data) is proportional to P(Parameters) P(Data | Parameters)
    // log P(Parameters | Data) = C + log P(Parameters) + log P(Data | Parameters) = target
    //
    // P(w) = 1/w so log P(w) = -log(w)
    target += -logw; // P(w) = 1/w

    subject_scale ~ exponential(1);
    
    subject_w ~ normal(0,1);
    
    overall_theta       ~ normal(0,3); 
    subject_theta       ~ normal(0,1);
    subject_theta_scale ~ exponential(1);
    
    expt_W ~ normal(0,1);
    expt_W_scale ~ exponential(1);
    
    // the likelihood here depends on typecode
    for(i in 1:NROWS) {
        real myw  = exp(logw + expt_W_scale*expt_W[typecode[i]] + subject_scale*subject_w[subject[i]]);
        real t = inv_logit(overall_theta + subject_theta[subject[i]]*subject_theta_scale);
        real p; 
        
        if(typecode[i] == 3) { // compute 1-1 accuracy
            int N = min(n1[i], n2[i]); // the most I could cancel
            
            p = 0.0;
            for(k in 1:N) { // k is how many I cancel out
                 real mysd = myw*sqrt((n1[i]-k)^2 + (n2[i]-k)^2);
                 real mymu = fabs(n1[i] - n2[i]);
                 
                 real p_correct_given_k = 1.0-exp(normal_lcdf( 0 | mymu, mysd)); 
                 
                 real p_k_given_theta = exp(binomial_lpmf(k|N,t));
                 
                 p += p_correct_given_k * p_k_given_theta;
            }
            
        }
        else { // for types 1, 2 - do Weber accuracy
        
            real mysd = myw*sqrt(n1[i]^2 + n2[i]^2);
            real mymu = fabs(n1[i] - n2[i]);
                    
            // likelihood: a coin flip with probability p
            p = 1.0-exp(normal_lcdf( 0 | mymu, mysd)); 
        }
          
          ncorrect[i] ~ binomial(ntrials[i], p);
    }
    
}
