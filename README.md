# Feedback modulation scripts for dataprocessing

Data preprocessing was done in Matlab.

```plot_parts.m``` imports raw data and plots contact force and and a binary contact indicator.

```gen_data.m``` builds the long format csv file for the transparency check

```force_model.m``` calculates the alpha, beta and gamma values and writes those values as well as STI_min and STI_max to a config file for ROS

```bounce_eval_model.m``` calculates the cumulative distance from the mean value for each bounce and writes this to a long form csv file

Bayesian models are used to compare conditions in the setup. ```Bayesian_model_dist_from_mean.R``` contains the model for the distance from the mean value for each contact. ```Bayesian_model_transparency.R``` contains the ncontacts and time on task models. 
