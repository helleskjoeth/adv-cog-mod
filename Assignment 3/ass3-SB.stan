//
//

// The input data is a vector 'y' of length 'N'.
data {
  int <lower = 1> trials; //total number of trials
  vector[trials] int <lower = 1, upper = 8> rating1; //vector of first truat rating
  vector[trials] int < -3, -2, 0, 2, 3> feedback;
  vector[trials] int rating2; 
}



transformed parameters {
  vector[trials] other;
  for (t in 1:trials){
    feedback_temp = sample(feedback,1)
    other[i] = rating1[i] + feedback_temp
      # make sure other's rating does not go out of bound [1-8]
      while (other[i]>8 | other[i]<1){
        feedback_temp = sample(feedback, 1)
        other[i] = rating1[i] + feedback_temp
  }

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.


// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  target += normal_lpmf(rating2 | 0.5* rating1 + 0.5 * other);
  
}

