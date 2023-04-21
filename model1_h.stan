
// The input data
data {
  int <lower = 1> t; // trial = t
  array[t] int choice; 
  array[t] int other;
  array[t] int self;
}

// The parameters to be estimated by the model.
parameters {
  real bias_win; 
  real bias_lose;
}



transformed parameters {
  vector[t] feedback_win;
  vector[t] feedback_lose;
  for (T in 1:t){ // wins shift lose stay strategy, right = 1, left = 0
    if (self[T] == other[T] && self[T] == 0) { //if the agent won and chose left
      feedback_win[T] = 1; // win left pulls toward right
      feedback_lose[T] = 0; // won, therefore irrelevant for lose feedback
    }
    else if (self[T] == other[T] && self[T] == 1){ //if the agent won and chose right
      feedback_win[T] = -1; // win right pulls toward left
      feedback_lose[T] = 0; // won, therefore irrelevant for lose feedback
    }
    else if (self[T] != other[T] && self[T] == 0) { // if the agent lost and chose left
      feedback_win[T] = 0; // lost, therefore irrelevant for win feedback
      feedback_lose[T] = -1;// lose left pulls toward left
    }
    else if (self[T] != other[T] && self[T] == 1){// if the agent loses and chose right 
      feedback_win[T] = 0; // lost, therefore irrelevant for win feedback
      feedback_lose[T] = 1; // lose right pulls toward right
    }
  }
}

// The model to be estimated.
model {
  // priors
  target += normal_lpdf(bias_win | 0, 1); // prior of bias when winning. lpdf scales the parameter to a log odds scale
  target += normal_lpdf(bias_lose | 0, 1); // prior of bias when losing
  // model 
  //for (T in 1:t){
  target += bernoulli_logit_lpmf(choice | bias_win * feedback_win + bias_lose * feedback_lose);// model that predicts the next choice based on
  //the feedback from previous trial and the given bias for whether the agent won or lost. 
  //}
}

// saving stuff from the model to use for testing the model and making sanity checks
generated quantities {
  real bias_win_prior; // 
  real bias_lose_prior;
  real<lower = 0, upper = 1> bias_win_posterior;
  real<lower = 0, upper = 1> bias_lose_posterior;
 
 //LR= lost-right, LL= lost-left, WR = won-right, WL = won-left 
 
  int<lower = 0, upper = t> prior_preds_LR;
  int<lower = 0, upper = t> prior_preds_LL;
  int<lower = 0, upper = t> prior_preds_WR;
  int<lower = 0, upper = t> prior_preds_WL;
  
  int<lower = 0, upper = t> post_preds_LR;
  int<lower = 0, upper = t> post_preds_LL;
  int<lower = 0, upper = t> post_preds_WR;
  int<lower = 0, upper = t> post_preds_WL;

  
  bias_win_prior = normal_rng(0,1); // log-odds scale
  bias_win_posterior = inv_logit(bias_win); //probability space

  bias_lose_prior = normal_rng(0,1); // log-odds scale
  bias_lose_posterior = inv_logit(bias_lose); // probability space


  prior_preds_LR = binomial_rng(t, inv_logit(bias_lose_prior * 1 + bias_win_prior * 0)); //drawing random binomial on trial t with the bias_lose prior to predict choice based on prior
  prior_preds_LL = binomial_rng(t, inv_logit(bias_lose_prior * -1 + bias_win_prior * 0)); // same as above ^
  prior_preds_WR = binomial_rng(t, inv_logit(bias_win_prior * -1 + bias_lose_prior * 0)); //drawing random binomial on trial t with the bias_win prior to predict choice based on prior
  prior_preds_WL = binomial_rng(t, inv_logit(bias_win_prior * 1 + bias_lose_prior * 0)); // ^

  post_preds_LR = binomial_rng(t, inv_logit(bias_lose * 1 + bias_win * 0)); //drawing random binomial on trial t with the true bias_lose make a posterior prediction
  post_preds_LL = binomial_rng(t, inv_logit(bias_lose * -1 + bias_win * 0)); // ^
  post_preds_WR = binomial_rng(t, inv_logit(bias_lose * 0 + bias_win * -1)); //drawing random binomial on trial t with the true bias_win make a posterior prediction
  post_preds_WL = binomial_rng(t, inv_logit(bias_lose * 0 + bias_win * 1)); // ^

  }