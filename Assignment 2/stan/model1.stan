
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
  vector[t] feedback;
  for (T in 1:t){
    //if (T == 1) {
    //  feedback[T] = binomial(0,1)
    //  }
    //if (T < t) {
    if (self[T] == other[T]) {
      feedback[T] = 1;
      }
    else {
      feedback[T] = 0;
     // }
    }
  }
}

// The model to be estimated.
model {
  target += normal_lpdf(bias_win | 0, 1); // prior of bias. lpdf scales the parameter to a log odds scale
  target += normal_lpdf(bias_lose | 0, 1); // prior of bias
  
  for (T in 2:t){
    if (feedback[T-1] == 1) {
      target += bernoulli_logit_lpmf(choice[T] | bias_win * feedback);
    }
    else {
      target += bernoulli_logit_lpmf(choice[T] | bias_lose * feedback);
    }
  }
}