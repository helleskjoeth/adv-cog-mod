data {
  int<lower=1> ntrials; // number of trials
  int<lower=1> nfeatures; // number of predefined relevant features
  array[ntrials] int<lower=0, upper=1> cat_one; // true responses on a trial by trial basis
  array[ntrials] int<lower=0, upper=1> choices; // decisions on a trial by trial basis
  array[ntrials, nfeatures] real obs; // stimuli as vectors of features
  real<lower=0, upper=1> bias; // initial bias for category one over two
  
  // priors
  vector [nfeatures] w_prior_values; // concentration parameters for dirichlet distribution <Lower=1>
  array[2] real c_prior_values; // mean and variance for logit-normal distribution
}

transformed data {
  array[ntrials] int<lower=0, upper=1> cat_zero; // dummy variable for category 0 over category 1
  array[sum(cat_one)] int<lower=1, upper=ntrials> cat_one_idx; // array of which stimuli are category 1
  array[ntrials-sum(cat_one)] int<lower=1, upper=ntrials> cat_zero_idx; // array of which stimuli are category 0
  
  int idx_one = 1; // Initializing an index counter
  int idx_zero = 1;
  for (i in 1:ntrials){
    cat_zero[i] = abs(cat_one[i]-1);
    
    if (cat_one[i]==1){
      cat_one_idx[idx_one] = i;
      idx_one +=1;
    } else {
      cat_zero_idx[idx_zero] = i;
      idx_zero += 1;
    }
  }
}

parameters {
  simplex[nfeatures] w; // simplex means sum(w)=1
  real logit_c;
}

transformed parameters {
  // parameter c
  real<lower=0, upper=2> c = inv_logit(logit_c)*2; // times 2 as is bounded between 0 and 2

  // parameter r (probability of response = category 1)
  array[ntrials] real<lower=0.0001, upper=0.9999> r;
  array[ntrials] real rr;

  for (i in 1: ntrials) {
    
    // calculate distance from obs to all exemplars
    array[(i-1)] real exemplar_sim;
    for (e in 1: (i-1)){
      array[nfeatures] real tmp_dist;
      for (j in 1: nfeatures) {
        tmp_dist[j] = w[j]*abs(obs[e, j] - obs[i, j]);
      }
      exemplar_sim[e] = exp(-c * sum(tmp_dist));
    }
  
    if (sum(cat_one[:(i-1)]) == 0 || sum(cat_zero[:(i-1)]) == 0){ // if there are no examplars in one of the categories
      r[i] = 0.5;
    } else {
      // calculate similarity
      array[2] real similarities;
      array[sum(cat_one[:(i-1)])] int tmp_idx_one = cat_one_idx[:sum(cat_one[:(i-1)])];
      array[sum(cat_zero[:(i-1)])] int tmp_idx_zero = cat_zero_idx[:sum(cat_zero[:(i-1)])];
    
      similarities[1] = sum(exemplar_sim[tmp_idx_one]);
      similarities[2] = sum(exemplar_sim[tmp_idx_zero]);

     // calculate r[i]
     rr[i] = (bias*similarities[1]) / (bias*similarities[1] + (1-bias)*similarities[2]);
    
     // to make the sampling work
     if (rr[i] > 0.9999){
        r[i] = 0.9999;
      } else if (rr[i] < 0.0001) {
       r[i] = 0.0001;
      } else if (rr[i] > 0.0001 && rr[i] < 0.9999){
        r[i] = rr[i];
      } else {
        r[i] = 0.5;
      }
    }
  }
}



model {
  // Priors
  target += dirichlet_lpdf(w | w_prior_values);
  target += normal_lpdf(logit_c | c_prior_values[1], c_prior_values[2]);
  
  // Decision Data
  target += bernoulli_lpmf(choices | r);
}

generated quantities {
    simplex[nfeatures] w_prior;
    simplex[nfeatures] w_posterior;
    real logit_c_prior;
    real logit_c_posterior;
    array[ntrials] real post_preds;
  
    
    // post_preds = bernoulli_rng(choices | r);
}

