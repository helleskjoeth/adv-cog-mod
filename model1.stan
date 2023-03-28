
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
      feedback_win[T] = 0;
      feedback_lose[T] = -1;
    }
    else if (self[T] != other[T] && self[T] == 1){
      feedback_win[T] = 0;
      feedback_lose[T] = 1;
    }
  }
}



// The model to be estimated.
model {
  target += normal_lpdf(bias_win | 0, 1); // prior of bias. lpdf scales the parameter to a log odds scale
  target += normal_lpdf(bias_lose | 0, 1); // prior of bias
  
  target += bernoulli_logit_lpmf(choice | bias_lose*feedback_lose + bias_win*feedback_win);
  
}


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
  bias_win_posterior = bias_win; 
  bias_lose_prior = inv_logit(normal_rng(0,1));
  bias_lose_posterior = bias_lose;
  
  
  
  prior_preds_LR = binomial_rng(t, (bias_lose_prior * 1 + bias_win_prior * 0))

  prior_preds_LL = binomial_rng(t, (bias_lose_prior * -1 + bias_win_prior * 0))

 

  prior_preds_WR = binomial_rng(t, inv_logit(bias_win_prior * -1 + bias_lose_prior * 0))

  prior_preds_WL = binomial_rng(t, inv_logit(bias_win_prior * 1 + bias_lose_prior * 0))
  
  
  
  
  for (T in 2:t) {
    // if choice is 0 and the agent loses
    if(choice[T] == 0 && feedback[T-1] == 0) {
      prior_preds_bias_lose_c0 = binomial_rng(t, bias_lose_prior);
      posterior_preds_bias_lose_c0 = binomial_rng(t, inv_logit(bias_lose));
    }
  
    // if choice is 0 and the agent wins
    if(choice[T] == 0 && feedback[T-1] == 1) {
      prior_preds_bias_win_c0 = binomial_rng(t, (1-bias_win_prior));
      posterior_preds_bias_win_c0 = binomial_rng(t, inv_logit(1-bias_win));
    }
  
    // if choice is 1 and the agent loses
    if(choice[T] == 1 && feedback[T-1] == 0) {
      prior_preds_bias_lose_c1 = binomial_rng(t, bias_lose_prior);
      posterior_preds_bias_lose_c1 = binomial_rng(t, inv_logit(bias_lose));
    }
  
    // if choice is 1 and the agent wins
    if(choice[T] == 1 && feedback[T-1] == 1) {
      prior_preds_bias_win_c1 = binomial_rng(t, (1-bias_win_prior));
      posterior_preds_bias_win_c1 = binomial_rng(t, inv_logit(1-bias_win));
      }
    }
  }