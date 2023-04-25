# Advanced Cognitive Modeling
This repository contains code for assignments submitted to the course Advanced Cognitive Modeling in the spring semester of 2023.
Contributing students are: 
* Helle Skjøth Sørensen
* Astrid Nørgaard Fonager
* David Trøst Fjendbo
* Sigrid Agersnap Bom Nielsen

## Assignment Descriptions

### ASSIGMENT 1
In this assignment you have to create: i) a document (e.g. doc, word, etc), and ii) a
github repository.

In the document you need to
* describe 2 possible strategies to play the Matching Pennies Game.
* include a discussion as to whether they include "cognitive constraints", that is, for instance, a
discussion of memory limits and their impact on the strategy, or other important cognitive
science driven considerations.
* report the formalization of these strategies, that is, a diagram and/or lines of code
implementing the strategy.
* include plots of how the strategies fare against each other (or other baselines), according to
the instructions for the class in Week 3, and a very brief discussion of what the plots allow you
to understand.
* include a link to the github repository

The github repository has to be linked in the document, and has to include all the code
for the strategy implementation, simulation of agents playing with those strategies and
visualization of the plots.


### ASSIGNMENT 2
In the assignment you need to produce a text (+ plots) document (linked to a github repo) in which you:
* describe the models you are working on (you can re-use text from assignment 1, if relevant, it is no plagiarism!)
* showcase a commented version of the stan model (what does each line do?)
* describe a process of parameter recovery (why are you doing it?, how are you doing it?)
* discuss the results: how many trials should be used at least to properly recover the parameters? What’s the role of priors? Add relevant plot(s).


### ASSIGNMENT 3
In assignment 3 you have to analyze real world data using Bayesian models of cognition. You can apply the models we discussed during the lectures, but you need to adjust them to reflect the specific setup.

The data comes from the social conformity experiment (https://pubmed.ncbi.nlm.nih.gov/30700729/), where cogsci students (in dataset 1) and schizophrenia patients + controls (dataset 2) combine their own intuition of trustworthiness of given faces to social information.

Your task is to:
* implement 2 models (at least): simple Bayes vs weighted Bayes. N.B. you'll need to adapt from what we have done in class.
* simulate data from the model to assess whether the models can be fit. N.B. model and parameter recovery are optional.
* fit them to one dataset (don't forget to explore the data first!)
* check model quality
* do model comparison
* report (v minimal description of research question, v minimal description of data, description of models, model quality checks, report of results)
* [optional]: parameter/model recovery
