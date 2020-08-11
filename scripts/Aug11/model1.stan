// Bayesian analysis to find w


// What to do:
//  (1) Fit theta on a by-subject basis -- probably be best to work on a logit scale 
//  (2) Fit effects on W of each experiment type 

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
    real<lower=0,upper=1> theta; // probability of canceling each item on 1-1 trials
    
    real<lower=0>  subject_scale;
    real subject_w[NSUBJ];
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
    
    theta ~ uniform(0,1); 
    
    // the likelihood here depends on typecode
    for(i in 1:NROWS) {
        real myw  = exp(logw + subject_scale*subject_w[subject[i]]);
        real p; 
        
        if(typecode[i] == 3) { // compute 1-1 accuracy
                       
            // Idea: theta gives a distribution on how many were "cancelled" 
            //       (because theta is the probability of cancelling)
            //       When we compute p, we average over all the number of items that 
            //       could be cancelled
            //       if you "cancel" 1 item on a 4-vs-5,  then it's really a 3-vs-4
            //                       2 items on a 4-vs-5, then it's really a 2-vs-3
            //       if I cancel     k items on an n1-vs-n2 then it's really a (n1-k)-vs-(n2-k)
            
            // Marginalizing out k / collapsed sampler
            // p = P(answering correctly | theta ) = \sum_k P(answering correctly | k) P(k| theta)
            //                                     = \sum_k P(answering correctly, k | theta)
            //                                     = P(answering correctly | theta)
            
            // \sum_k P(answering correctly | k) P(k | theta)
            //                   |                   | 
            //    Weber model on (n1-k)-vs-(n2-k)  binomial(k|theta)
            int N = min(n1[i], n2[i]); // the most I could cancel
            
            p = 0.0;
            for(k in 1:N) { // k is how many I cancel out
                 real mysd = myw*sqrt((n1[i]-k)^2 + (n2[i]-k)^2);
                 real mymu = fabs(n1[i] - n2[i]);
                 
                 real p_correct_given_k = 1.0-exp(normal_lcdf( 0 | mymu, mysd)); 
                 
                 real p_k_given_theta = exp(binomial_lpmf(k|N,theta));
                 
                 p += p_correct_given_k * p_k_given_theta;
            }
            
        }
        else { // for types 1, 2 - do Weber accuracy
        
            real mysd = myw*sqrt(n1[i]^2 + n2[i]^2);
            real mymu = fabs(n1[i] - n2[i]);
                    
            // likelihood: a coin flip with probability p
            p = 1.0-exp(normal_lcdf( 0 | mymu, mysd)); 
        }
  
//           didIlapse ~ bernoulli(l);
//           if(didIlapse) { 
//             ncorrect[i] ~ binomial(ntrials[i], 0.5);
//           }
//           else {          
//             ncorrect[i] ~ binomial(ntrials[i], p);
//           }
          
          
          ncorrect[i] ~ binomial(ntrials[i], p*(1-l) + l*0.5);
//        ncorrect[i] ~ binomial(ntrials[i], p);
    }
    
}
