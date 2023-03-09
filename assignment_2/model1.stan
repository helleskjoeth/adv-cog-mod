
// The input data
data {
  int <lower = 1> t; // trial = t
  array[t] int choice;
  array[t] int other;
  array[t] int self;
}

// The parameters accepted by the model.
parameters {
  real bias_win; 
  real bias_lose;
}

transformed parameters {
  vector[t] feedback_win;
  vector[t] feedback_lose;
  for (T in 1:t){
    if (self[T] == other[T] && self[T] == 0) {
      feedback_win[T] = 1;
      feedback_lose[T] = 0;
    }
    else if (self[T] == other[T] && self[T] == 1){
      feedback_win[T] = -1;
      feedback_lose[T] = 0;
    }
    else if (self[T] != other[T] && self[T] == 0) {
      feedback_win[T] = 0; {}
      feedback_lose[T] = -1;
    }
    else if (self[T] != other[T] && self[T] == 1){
      feedback_win[T] = 0;
      feedback_lose[T] = 1;
    }
  }
}
  
  
  //vector[t] feedback_win;
  //vector[t] feedback_lose;
  //for (T in 1:t){
    //if (T == 1) {
    //  feedback[T] = binomial(0,1)
    //  }
    //if (self[T] == other[T] && self[T] == 0) { // win left 
    //  feedback_win[T] = 1;
    //}
    //else if (self[T] == other[T] && [self[T] == 1) { // win right 
    //  feedback_win[T] = -1;
    //}
    //else (self[T] != [other[T]) { // lose
    //  feedback_win[T] = 0;
    //}
    
    //if (self[T] != other[T] && self[T] == 0) { // lose left
    //  feedback_lose[T] = -1;
    //}
    //else if (self[T] != other[T] && self[T] == 1) { // lose right
    //  feedback_lose[T] = 1;
    //} 
    //else (self[T] == other[T]){ // won
    //  feedback_lose[T] = 0;
    //}
  //}
//}

// The model to be estimated.
model {
  // priors
  target += normal_lpdf(bias_win | 0, 1); // prior of bias. lpdf scales the parameter to a log odds scale
  target += normal_lpdf(bias_lose | 0, 1); // prior of bias
  
  // model 
  target += bernoulli_logit_lpmf(choice[T] | bias_win * feedback_win + bias_lose * feedback_lose);
}

// saving stuff from the model 
generated quantities {
  real<lower = 0, upper = 1> bias_win_prior;
  real<lower = 0, upper = 1> bias_lose_prior;
  real<lower = 0, upper = 1> bias_win_posterior;
  real<lower = 0, upper = 1> bias_lose_posterior;
  
  int<lower = 0, upper = t> prior_preds_bias_lose_c0;
  int<lower = 0, upper = t> prior_preds_bias_win_c0;
  int<lower = 0, upper = t> prior_preds_bias_lose_c1;
  int<lower = 0, upper = t> prior_preds_bias_win_c1;
  
  int<lower = 0, upper = t> posterior_preds_bias_lose_c0;
  int<lower = 0, upper = t> posterior_preds_bias_win_c0;
  int<lower = 0, upper = t> posterior_preds_bias_lose_c1;
  int<lower = 0, upper = t> posterior_preds_bias_win_c1;

  
  bias_win_prior = inv_logit(normal_rng(0,1));
//  bias_win_posterior = inv_logit(bias_win); 
  bias_win_posterior = bias_win; 

  bias_lose_prior = inv_logit(normal_rng(0,1));
//  bias_lose_posterior = inv_logit(bias_lose);
  bias_lose_posterior = bias_lose;
  
  prior_preds_LR = binomial_rng(t, (bias_lose_prior * 1 + bias_win_prior * 0))
  prior_preds_LL = binomial_rng(t, (bias_lose_prior * -1 + bias_win_prior * 0))
  prior_preds_WR = binomial_rng(t, (bias_win_prior * -1 + bias_lose_prior * 0))
  prior_preds_WL = binomial_rng(t, (bias_win_prior * 1 + bias_lose_prior * 0))

  post_preds_LR = binomial_rng(t, (bias_lose * 1 + bias_win * 0))
  post_preds_LL = binomial_rng(t, (bias_lose * -1 + bias_win * 0))
  post_preds_WR = binomial_rng(t, (bias_lose * 0 + bias_win * -1))
  post_preds_WL = binomial_rng(t, (bias_lose * 0 + bias_win * 1))

}
