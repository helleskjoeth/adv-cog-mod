#Ricc code - simple memory agent


memory_agent_f <- function(other_choice, trial) {
  if (trial == 1) {
    memory[trial] = 0.5 
  }
  else {memory[trial] = memory[trial-1] + ((other_choice - memory[trial-1])/trial) #this model has perfect memory
  }
  
}


# Memory is a vector of zero's and ones, and it's a mean of your opponents previous choices (I think).  