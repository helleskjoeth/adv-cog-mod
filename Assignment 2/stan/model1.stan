
// The input data
data {
  int <lower = 1> t; // t = number of trials
  array[t] int choice; # data contains an array of length = trials for choice (on last trial)
  array[t] int other; # data contains an array of length = trials for the opponent's choice (on current trial)
  array[t] int self; # data contains an array of length = trials for the player's choice (on current trial)
}

// The parameters accepted by the model.
parameters {
  real bias_win; 
  real bias_lose;
}

transformed parameters {
  vector[t] feedback_win; # initialize a vector of length = trials for feedback on win
  vector[t] feedback_lose; # initialize a vector of length = trials for feedback on loss

  for (T in 1:t){ # for each trial determine feedback
    if (self[T] == other[T] && self[T] == 0) { # given a win on left hand
      feedback_win[T] = 1; # feedback is 1. Thus, in the model, the choice is given by bias_win*1 = bias_win, and the choice should be closer to 1 (right hand)
      feedback_lose[T] = 0; # feedback is zero, so the bias_lose becomes 0 in the model (it is not relevant given a win)
    }
    else if (self[T] == other[T] && self[T] == 1){ # given a win on right hand
      feedback_win[T] = -1; # feedback is -1. Thus, in the model, the choice is given by bias_win*-1 = -bias_win and the choice should be closer to 0 (left hand)
      feedback_lose[T] = 0; # feedback is zero, so the bias_lose becomes 0 in the model 
    }
    else if (self[T] != other[T] && self[T] == 0) { # given a loss on left hand
      feedback_win[T] = 0; # feedback is zero, so the bias_win becomes 0 in the model (it is not relevant given a loss)
      feedback_lose[T] = -1;
    }
    else if (self[T] != other[T] && self[T] == 1){ # given a loss on right hand
      feedback_win[T] = 0; # feedback is zero, so the bias_win becomes 0 in the model
      feedback_lose[T] = 1;
    }
  }
}

// The model to be estimated.
model {
  target += normal_lpdf(bias_win | 0, 1); // prior of bias. lpdf scales the parameter to a log odds scale
  target += normal_lpdf(bias_lose | 0, 1); // prior of bias
  
  target += bernoulli_logit_lpmf(choice | bias_lose * feedback_lose + bias_win * feedback_win);
  
}


generated quantities {
  real bias_win_prior;
  real bias_lose_prior;
  real<lower = 0, upper = 1> bias_win_posterior;
  real<lower = 0, upper = 1> bias_lose_posterior;
  
  int<lower = 0, upper = t> prior_preds_LR;
  int<lower = 0, upper = t> prior_preds_LL;
  int<lower = 0, upper = t> prior_preds_WR;
  int<lower = 0, upper = t> prior_preds_WL;
  
  int<lower = 0, upper = t> post_preds_LR;
  int<lower = 0, upper = t> post_preds_LL;
  int<lower = 0, upper = t> post_preds_WR;
  int<lower = 0, upper = t> post_preds_WL;

  
  bias_win_prior = normal_rng(0,1);
  bias_win_posterior = inv_logit(bias_win);
  
  bias_lose_prior = normal_rng(0,1);
  bias_lose_posterior = inv_logit(bias_lose);
  
  prior_preds_LR = binomial_rng(t, inv_logit(bias_lose_prior * 1 + bias_win_prior * 0));
  prior_preds_LL = binomial_rng(t, inv_logit(bias_lose_prior * -1 + bias_win_prior * 0));
  prior_preds_WR = binomial_rng(t, inv_logit(bias_win_prior * -1 + bias_lose_prior * 0));
  prior_preds_WL = binomial_rng(t, inv_logit(bias_win_prior * 1 + bias_lose_prior * 0));

  post_preds_LR = binomial_rng(t, inv_logit(bias_lose * 1 + bias_win * 0));
  post_preds_LL = binomial_rng(t, inv_logit(bias_lose * -1 + bias_win * 0));
  post_preds_WR = binomial_rng(t, inv_logit(bias_lose * 0 + bias_win * -1));
  post_preds_WL = binomial_rng(t, inv_logit(bias_lose * 0 + bias_win * 1));
}
