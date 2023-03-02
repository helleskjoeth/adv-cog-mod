// The input data is a vector 'y' of length 'N'.
data {
  int <lower = 1> t; //trial
  array[t] int choice;
  vector[t] feedback; //fb from previous trial 
}

// The parameters accepted by the model. 
parameters {
  real  bias_win;
  real  bias_lose;
  }

// The model to be estimated. We model the output


transformed parameters {
  
  real bias;
  bias = bias_win + bias_lose; // make in R so that if feedback = win, then bias_lose = 0 and vice versa
  }

model {
  target += normal_lpdf (bias_win| 0,1); // bias_win prior
  target += normal_lpdf (bias_lose| 0,1); // bias_lose prior
  target += bernoulli_logit_lpmf (choice | bias * feedback); //model
}