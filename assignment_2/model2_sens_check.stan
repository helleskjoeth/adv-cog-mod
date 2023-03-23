// stan model with only one bias from astrid_branch
data {
  int <lower = 1> trials; 
  array[trials] int choice;
  array[trials] int other;
  array[trials] int self;
  real prior_mean_RF;
  real <lower = 0> prior_sd_RF;
}


parameters {
  real rule_following;
}

transformed parameters {
  vector[trials] feedback;
  for (t in 1:trials){
    if (self[t] == other[t] && self[t] == 0 || self[t] != other[t] && self[t] == 1) {
      feedback[t] = 1;
     }
    else if (self[t] == other[t] && self[t] == 1 || self[t] != other[t] && self[t] == 0){
      feedback[t] = -1;
    }
  }
}

model {
  target += normal_lpdf(rule_following | prior_mean_RF, prior_sd_RF); // prior of bias
  
  target += bernoulli_logit_lpmf(choice | rule_following * feedback);
}

generated quantities {
  real rule_following_prior;
  real <lower = 0, upper = 1> rule_following_posterior;
  
  int<lower = 0, upper = trials> prior_preds_LR;
  int<lower = 0, upper = trials> prior_preds_LL;
  int<lower = 0, upper = trials> prior_preds_WR;
  int<lower = 0, upper = trials> prior_preds_WL;
  
  int<lower = 0, upper = trials> post_preds_LR;
  int<lower = 0, upper = trials> post_preds_LL;
  int<lower = 0, upper = trials> post_preds_WR;
  int<lower = 0, upper = trials> post_preds_WL;
  
  rule_following_prior = normal_rng(prior_mean_RF, prior_sd_RF);
  rule_following_posterior = inv_logit(rule_following); 
  
  prior_preds_LR = binomial_rng(trials, inv_logit(rule_following_prior * 1));
  prior_preds_LL = binomial_rng(trials, inv_logit(rule_following_prior * -1));
  prior_preds_WR = binomial_rng(trials, inv_logit(rule_following_prior * -1));
  prior_preds_WL = binomial_rng(trials, inv_logit(rule_following_prior * 1));

  post_preds_LR = binomial_rng(trials, inv_logit(rule_following * 1));
  post_preds_LL = binomial_rng(trials, inv_logit(rule_following * -1));
  post_preds_WR = binomial_rng(trials, inv_logit(rule_following * -1));
  post_preds_WL = binomial_rng(trials, inv_logit(rule_following * 1));
}
