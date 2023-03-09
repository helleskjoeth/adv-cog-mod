
data {
  int <lower = 1> trials; 
  array[trials] int choice;
  array[trials] int other;
  array[trials] int self;
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
  target += normal_lpdf(rule_following | 0, 1); // prior of bias
  
  target += bernoulli_logit_lpmf(choice | rule_following*feedback);
}

generated quantities {
  real<lower = 0, upper = 1> rule_following_prior;
  real<lower = 0, upper = 1> rule_following_posterior;
  
  rule_following_prior = inv_logit(normal_rng(0,1));
  rule_following_posterior = inv_logit(rule_following);
}
