library(readr)
library(dplyr)
library(tidyverse)
library(rstanarm)
library(mascutils)
library(gridExtra)
library(devtools)
library(knitr)
library(mascutils)
library(bayr)
library(naniar)
library(brms)

data <- read_csv("C:\\Users\\admin\\pacof\\data\\Feedback modulation\\FB_modulation_code\\auto_gen_hard_soft_data_long.csv", 
                 col_names = c("participant", "condition", "delay", "tot", "ncontacts"))

##
data <- data %>% replace_with_na(replace = list(tot = 999999))
data <- data %>% replace_with_na(replace = list(ncontacts = 999999))
data <- data %>% mutate(tot_norm = tot/1000)

      #########################
      ###                   ###
      ###   Time on task    ###
      ###                   ###
      #########################


tot__RANDel_RANCondition_RANParticipant <-  brm(tot_norm ~ (1|delay) +(1|condition) +(1|participant),
                                                data = data,
                                                family=exgaussian(),
                                                control = list(adapt_delta = 0.99),
                                                cores = 4, backend = "cmdstanr", threads = threading(4))

## coefs
coefs_tot__RANDel_RANCondition_RANParticipant = coef(posterior(tot__RANDel_RANCondition_RANParticipant), interval=0.9)
coefs_tot__RANDel_RANCondition_RANParticipant$n = c(1:28)
coefs_tot__RANDel_RANCondition_RANParticipant

## coefs norm delay condition
coefs_norm_tot__RANDel_RANCondition_RANParticipant_del <- 
  slice(dplyr::select(coefs_tot__RANDel_RANCondition_RANParticipant, center, lower, upper), 6:9)+ 
  coefs_tot__RANDel_RANCondition_RANParticipant$center[1]

coefs_norm_tot__RANDel_RANCondition_RANParticipant_del$labels_ = c("0ms", "150ms", "300ms", "black")


## plot delay condition
ggplot(coefs_norm_tot__RANDel_RANCondition_RANParticipant_del, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Delay condition",limits=coefs_norm_tot__RANDel_RANCondition_RANParticipant_del$labels_)+
  scale_y_continuous("Time on Task")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ToT_RANDel_RANCondition_RANParticipant_del_small.pdf", 
       width = 2.8, height = 1.9, units = "in")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ToT_RANDel_RANCondition_RANParticipant_del_large.pdf",
       width = 4.9, height = 3.3, units = "in")

## coefs norm modulation condition
coefs_norm_tot__RANDel_RANCondition_RANParticipant_cond <- 
  slice(dplyr::select(coefs_tot__RANDel_RANCondition_RANParticipant, center, lower, upper), 2:5)+ 
  coefs_tot__RANDel_RANCondition_RANParticipant$center[1]

coefs_norm_tot__RANDel_RANCondition_RANParticipant_cond$labels_ = c("raw", "average", "low pass", "scale")

## plot modulation condition
ggplot(coefs_norm_tot__RANDel_RANCondition_RANParticipant_cond, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",limits=coefs_norm_tot__RANDel_RANCondition_RANParticipant_cond$labels_)+
  scale_y_continuous("Time on Task")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ToT_RANDel_RANCondition_RANParticipant_cond_small.pdf",
       width = 2.8, height = 1.9, units = "in")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ToT_RANDel_RANCondition_RANParticipant_cond_large.pdf",
       width = 4.9, height = 3.3, units = "in")

## coefs norm participant effects
coefs_norm_tot__RANDel_RANCondition_RANParticipant_part <- 
  slice(dplyr::select(coefs_tot__RANDel_RANCondition_RANParticipant, center, lower, upper), 10:28)+ 
  coefs_tot__RANDel_RANCondition_RANParticipant$center[1]

coefs_norm_tot__RANDel_RANCondition_RANParticipant_part$labels_ = as.character(c(3:21))

## plot participant effects
ggplot(coefs_norm_tot__RANDel_RANCondition_RANParticipant_part, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Participant",limits=coefs_norm_tot__RANDel_RANCondition_RANParticipant_part$labels_)+
  scale_y_continuous("Time on Task")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ToT_RANDel_RANCondition_RANParticipant_part_small.pdf",
       width = 2.8, height = 1.9, units = "in")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ToT_RANDel_RANCondition_RANParticipant_part_large.pdf",
       width = 4.9, height = 3.3, units = "in")

      #####################
      ###               ###
      ###   ncontacts   ###
      ###               ###
      #####################

ncontacts__RANDel_RANCondition_RANParticipant <-  brm(ncontacts ~ 1 + (1|delay) +(1|condition) + (1|participant),
                                                      data = data,
                                                      family=poisson(),
                                                      control = list(adapt_delta = 0.99),
                                                      cores = 4, backend = "cmdstanr", threads = threading(4))
## coefs
coefs_ncontacts__RANDel_RANCondition_RANParticipant = coef(posterior(ncontacts__RANDel_RANCondition_RANParticipant), interval=0.9, mean.func = exp )
coefs_ncontacts__RANDel_RANCondition_RANParticipant$n = c(1:28)
coefs_ncontacts__RANDel_RANCondition_RANParticipant

## coefs norm delay condition
coefs_norm_ncontacts__RANDel_RANCondition_RANParticipant_del <- 
  slice(dplyr::select(coefs_ncontacts__RANDel_RANCondition_RANParticipant, center, lower, upper), 6:9)+
  coefs_ncontacts__RANDel_RANCondition_RANParticipant$center[1]

coefs_norm_ncontacts__RANDel_RANCondition_RANParticipant_del$labels_ = c("0ms", "150ms", "300ms", "black")

## plot delay condition
ggplot(coefs_norm_ncontacts__RANDel_RANCondition_RANParticipant_del, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Delay condition",limits=coefs_norm_ncontacts__RANDel_RANCondition_RANParticipant_del$labels_)+
  scale_y_continuous("Number of contacts")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ncontacts_RANDel_RANCondition_RANParticipant_del_poisson_small.pdf",
       width = 2.8, height = 1.9, units = "in")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ncontacts_RANDel_RANCondition_RANParticipant_del_poisson_large.pdf",
       width = 4.9, height = 3.3, units = "in")


## coefs norm delay condition condition
coefs_ncontacts__RANDel_RANCondition_RANParticipant

coefs_norm_nconctacts__RANDel_RANCondition_RANParticipant_cond <- 
  slice(dplyr::select(coefs_ncontacts__RANDel_RANCondition_RANParticipant, center, lower, upper), 2:5)+ 
  coefs_ncontacts__RANDel_RANCondition_RANParticipant$center[1]

coefs_norm_nconctacts__RANDel_RANCondition_RANParticipant_cond$labels_ = c("raw", "average", "low pass", "scale")

coefs_norm_nconctacts__RANDel_RANCondition_RANParticipant_cond

## plot delay condition condition
ggplot(coefs_norm_nconctacts__RANDel_RANCondition_RANParticipant_cond, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",limits=coefs_norm_nconctacts__RANDel_RANCondition_RANParticipant_cond$labels_)+
  scale_y_continuous("Number of contacts")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ncontacts_RANDel_RANCondition_RANParticipant_cond_poisson_small.pdf",
       width = 2.8, height = 1.9, units = "in")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ncontacts_RANDel_RANCondition_RANParticipant_cond_poisson_large.pdf",
       width = 4.9, height = 3.3, units = "in")


## coefs norm participant effects
coefs_norm_nconctacts__RANDel_RANCondition_RANParticipant_part <- 
  slice(dplyr::select(coefs_ncontacts__RANDel_RANCondition_RANParticipant, center, lower, upper), 10:28)+ 5.3 #(dplyr::select(coefs,center),1)

coefs_norm_nconctacts__RANDel_RANCondition_RANParticipant_part$labels_ = as.character(c(3:21))

coefs_norm_nconctacts__RANDel_RANCondition_RANParticipant_part

## plot norm participant effects
ggplot(coefs_norm_nconctacts__RANDel_RANCondition_RANParticipant_part, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",limits=coefs_norm_nconctacts__RANDel_RANCondition_RANParticipant_part$labels_)+
  scale_y_continuous("Number of contacts")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ncontacts_RANDel_RANCondition_RANParticipant_part_poisson_small.pdf",
       width = 2.8, height = 1.9, units = "in")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ncontacts_RANDel_RANCondition_RANParticipant_part_poisson_large.pdf",
       width = 4.9, height = 3.3, units = "in")
