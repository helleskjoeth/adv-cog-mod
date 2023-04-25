// simple Bayesian model

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
  rating1_logit = logit(rating1_logit); // log odds
  other_logit = logit(other_logit); // log odds
  rating2_logit = logit(rating2_logit); // log odds

}  

parameters {
  real bias;
}

model {
  // priors
  target += normal_lpdf(bias | 0, 1);
  
  // model 
  target += inv_logit(normal_lpdf(rating2_logit | bias + 0.5 * to_vector(rating1_logit) + 0.5 * to_vector(other_logit), 0.2)); // outputs log odds 
  //lpdf = log probability density function - log odds
}

//generated quantities {
//  real bias_prior;
  
//  bias_prior = binomial_rng(0,1);
//}
