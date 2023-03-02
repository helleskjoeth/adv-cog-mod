//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// win stay 

// The input data is a vector 'y' of length 'N'.

// 
data {
  int <lower = 1> t; // trial = t
  array[t] int choice;
  vector[t] feedback;
}

// The parameters accepted by the model.
parameters {
  real bias_win; 
  real bias_lose;
}

transformed parameters {
  real bias;
  bias = bias_win + bias_lose;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  target += normal_lpdf(bias_win | 0, 1); // prior of bias. lpdf scales the parameter to a log odds scale
  target += normal_lpdf(bias_lose | 0, 1); // prior of bias
  
  target += bernoulli_logit_lpmf(choice | bias * feedback);// model 
  
}