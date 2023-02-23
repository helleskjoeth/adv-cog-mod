// win stay 

// The input data is a vector 'y' of length 'N'.

// 
data {
  int <lower = 1> t; // trial = t
  array[t] int choice;
  array [t] int feedback;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real <lower = 0, upper = 1> bias; // overflødigt? spørg Ric!
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  target += normal_lpdf(bias | 0,1) // prior of bias
  target += bernoulli_logit_lpmf(choice | bias * feedback)// model 
  
}

