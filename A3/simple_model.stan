// simple Bayesian model

data {
  int <lower = 1> trials; // trials = total number of trials 
  array
  [trials] real <lower = 0, upper = 1> rating1; // probability scale
  array[trials] real <lower = 0, upper = 1> other; // probability scale
  array[trials] real rating2; // outcome variable - will be log odds
}

transformed data {
  array[trials] real rating1_logit;
  array[trials] real other_logit;
  rating1_logit = logit(rating1_logit); // log odds
  other_logit = logit(other_logit); // log odds
}  

model {
  target += normal_lpdf(rating2 | 0.5 * to_vector(rating1_logit) + 0.5 * to_vector(other_logit), 1); // outputs log odds 
  //lpdf = log probability density function - log odds
}

