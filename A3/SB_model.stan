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
  rating1_logit = logit(rating1); // log odds
  other_logit = logit(other); // log odds
  rating2_logit = logit(rating2); // log odds

}

parameters {
  real bias;
  real SD;
}

model {
  // priors
  target += normal_lpdf(SD | 0, 0.1) - normal_lccdf(0 | 0, 0.1);
  target += normal_lpdf(bias | 0, 1);
  
  
  // model 
  target += normal_lpdf(rating2_logit | bias + 0.5 * to_vector(rating1_logit) + 0.5 * to_vector(other_logit), SD); // outputs log odds 
  //lpdf = log probability density function - log odds
}

generated quantities {
  real bias_prior;
  real bias_posterior;
  real log_lik; // to be used for model comparison
  array[trials] real post_preds;
 // real SD_prior;
  
  bias_prior = normal_rng(0,1);
  bias_posterior = bias;
//  SD_prior = normal_rng(0, 0.1);
  
  log_lik =  normal_lpdf(rating2_logit | bias + 0.5 * to_vector(rating1_logit) + 0.5 * to_vector(other_logit), SD);
  post_preds = normal_rng(bias + 0.5 * to_vector(rating1_logit) + 0.5 * to_vector(other_logit), SD);
}


