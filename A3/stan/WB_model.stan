
// weighted Bayesian model

data {
  int <lower = 1> trials; // trials = total number of trials 
  array[trials] real <lower = 0, upper = 1> rating1; // probability scale
  array[trials] real <lower = 0, upper = 1> other; // probability scale
  //array[trials] real <lower = 0, upper = 1> rating2; // probability scale
  vector[trials] rating2; // 1-8 scale
}

transformed data {
  array[trials] real rating1_logit;
  array[trials] real other_logit;
  //array[trials] real rating2_logit;
  vector[trials] rating2_logit;
  rating1_logit = logit(rating1); // log odds
  other_logit = logit(other); // log odds
  rating2_logit = logit(rating2/9); // log odds
}  

parameters {
  real bias;
  real weight_self;
  real weight_other;
  real <lower = 0> SD;
}

transformed parameters {
//array[trials] real w_self;
//array[trials] real w_other;
real w_self;
real w_other;
w_self = weight_self * 0.5 + 0.5; // transform from [0;1] space to a [0.5;1] space
w_other = weight_other * 0.5 + 0.5;
}
 
model {
  // priors
  target += exponential_lpdf(SD | 10);
  target += normal_lpdf(bias | 0, 1);
  target += normal_lpdf(w_self | 0.75, 0.1);
  //target += normal_lpdf(weight_self | 0, 1);
  target += normal_lpdf(w_other | 0.75, 0.1);
  //target += normal_lpdf(weight_other | 0, 1);
  
  // target += normal_lpdf(rating2_logit | bias + w_self * to_vector(rating1_logit) + w_other * to_vector(other_logit), SD);
  target += normal_lpdf(rating2_logit | (bias + w_self * to_vector(rating1_logit) + w_other * to_vector(other_logit)), SD);
}

generated quantities {
  real bias_prior;
  real SD_prior;
  real w_self_prior;
  real w_other_prior;
  array[trials] real log_lik;
  array[trials] real post_preds;

  bias_prior = normal_rng(0,1);
  SD_prior = exponential_rng(10);
  w_self_prior = normal_rng(0.75, 0.1);
  w_other_prior = normal_rng(0.75, 0.1);

  
  for (t in 1:trials){
    log_lik[t] = normal_lpdf(rating2_logit[t] | bias + w_self * to_vector(rating1_logit)[t] + w_other * to_vector(other_logit)[t], SD);
  }
  
 // post_preds = normal_rng(bias + w_self * to_vector(rating1_logit) + w_other * to_vector(other_logit), SD);
  for (t in 1:trials){
    post_preds[t] = normal_rng(bias + 0.5 * to_vector(rating1_logit)[t] + 0.5 * to_vector(other_logit)[t], SD);
  }
}

