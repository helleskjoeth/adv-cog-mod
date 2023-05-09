
// Weighted Bayesian model

data {
  int <lower = 0> trials; // trials = total number of trials 
  array[trials] real <lower = 0, upper = 1> rating1; // probability scale
  array[trials] real <lower = 0, upper = 1> other; // probability scale
  array[trials] real <lower = 0, upper = 1> rating2; // probability scale
}

transformed data {
  array[trials] real rating1_logit;
  array[trials] real other_logit;
  array[trials] real rating2_logit;
  rating1_logit = logit(rating1); // log odds
  other_logit = logit(other); // log odds
  rating2_logit = logit(rating2); // log odds
}  

parameters {
  real bias;
  real <lower = 0, upper = 1> weight_self;
  real <lower = 0, upper = 1> weight_other; 
}

transformed parameters {
 // array[trials] real w_self;
//  array[trials] real w_other;
  real <lower = 0.5, upper = 1> w_self;
  real <lower = 0.5, upper = 1> w_other;
  w_self = weight_self * 0.5 + 0.5; // transform from [0;1] space to a [0.5;1] space
  w_other = weight_other * 0.5 + 0.5;
}

model {
  // priors
  target += normal_lpdf(bias | 0, 1);
  target += normal_lpdf(w_self | 0.75, 0.1);
  target += normal_lpdf(w_other | 0.75, 0.1);
  
  // model 
  target += normal_lpdf(rating2_logit | bias + w_self * to_vector(rating1_logit) + w_other * to_vector(other_logit), 0.2); // outputs log odds 
  //lpdf = log probability density function - log odds
}

//generated quantities {
//  real bias_prior;
  
//  bias_prior = binomial_rng(0,1);
//} 
