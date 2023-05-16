Here are all the files and code that have been created and used for assignment 4

### Structure of the experiment:

- the stimuli are conceptualized as 5 dimensional vectors of 0s and 1s (5 features, binary values)
- there are 32 possible stimuli, all 32 stimuli are presented in randomized order, in three iterations (stimuli 1-32 in random order, stimuli 1-32 in a new random order, stimuli 1-32 in a new random order).
- the stimuli are categorized along two dimensions: danger (0-1) and nutrition (0-1). Feel free to simplify your life and only consider one dimension (but kudos for considering both).
- the association between feature and category varies over session. 
- - In the first session: danger depends on the alien having spots AND eyes on stalks (feature 1 AND feature 2 both being 1); nutrition depends on arms being up (feature 4 being 1).
- - In the second session: danger depends on arms being up (feature 4 being 1); nutrition depends on at least two amongst eyes on stalks, slim legs, and spots (at least 2 out of feature 1, 2 and 3 being 1)
- - In the third session: danger depends on arms up and green color (feature 4 and 5 being both 1); nutrition depends on at least two amongst eyes on stalks, slim legs, spots, or green color (at least 2 amongst feature 1, 2, 3, 5 being 1)
- The experiment also contrasted dyads (condition 1) with individuals (condition 2), but that's less relevant for the simulation.
