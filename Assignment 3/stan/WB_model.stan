
// weighted Bayesian model

data {
  int <lower = 1> trials; // trials = total number of trials 
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
  real weight_self;
  real weight_other;
  real <lower = 0> SD;
}

//transformed parameters {
 // array[trials] real w_self;
 //  array[trials] real w_other;
 // real <lower = 0.5, upper = 1> w_self;
 // real <lower = 0.5, upper = 1> w_other;
 // w_self = weight_self * 0.5 + 0.5; // transform from [0;1] space to a [0.5;1] space
 // w_other = weight_other * 0.5 + 0.5; 
//}
 
model {
  // priors
  target += exponential_lpdf(SD | 10);
  target += normal_lpdf(bias | 0, 1);
  //target += normal_lpdf(w_self | 0.75, 0.1);
  target += normal_lpdf(weight_self | 0, 1);
  //target += normal_lpdf(w_other | 0.75, 0.1);
  target += normal_lpdf(weight_other | 0, 1);

  // model - outputs log odds
  // target += normal_lpdf(rating2_logit | bias + w_self * to_vector(rating1_logit) + w_other * to_vector(other_logit), SD);
  for (n in 1:trials){
    target += normal_lpdf(rating2_logit[n] | (bias + weight_self * rating1_logit[n] + weight_other * other_logit[n]), SD);
  }
}

generated quantities {
  real bias_prior;
  real bias_posterior;
  real w_self_prior;
  //real w_self_posterior;
  real w_other_prior;
  //real w_other_posterior;
  array[trials] real log_lik; // to be used for model comparison
  array[trials] real post_preds;
  real SD_prior;
  real SD_post;

  bias_prior = normal_rng(0,1);
  w_self_prior = normal_rng(0.75, 0.1);
  w_other_prior = normal_rng(0.75, 0.1);
  SD_prior = exponential_rng(10);
  SD_post = SD;


  bias_posterior = bias;
  //w_self_posterior = w_self;
  //w_other_posterior = w_other;

  for (t in 1:trials){
    log_lik[t] = normal_lpdf(rating2_logit | bias + weight_self * to_vector(rating1_logit) + weight_other * to_vector(other_logit), SD);
    }
  post_preds = normal_rng(bias + weight_self * to_vector(rating1_logit) + weight_other * to_vector(other_logit), SD);
}

