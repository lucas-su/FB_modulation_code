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

##

dist_from_mean <- read_csv("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dist_from_mean_model.csv", 
                           col_names = c('part','dist','cond'))
labels_cond=c("raw", "average", "low pass", "scale")
labels_part <- as.character(c(3:21))

## 
lm_P_C <-  stan_lmer(dist ~ 1 + (1|part) + (1|cond),
                      data = dist_from_mean )

coefs_P_C <- coef(posterior(lm_P_C), interval=0.9)

coefs_P_C

coefs_norm_P_C_part <- slice(dplyr::select(coefs_P_C, center, lower, upper), 2:20)+  1.84 #(dplyr::select(coefs,center),1)
coefs_norm_P_C_cond <- slice(dplyr::select(coefs_P_C, center, lower, upper), 21:24)+  1.84 #(dplyr::select(coefs,center),1)

coefs_norm_P_C_cond$labels_ = c("raw", "average", "low pass", "scale")
coefs_norm_P_C_part$labels_ <- as.character(c(3:21))



ggplot(coefs_norm_P_C_part, aes(labels_, center)) +        # ggplot2 plot with 90% credibility limits
  geom_point() +
  geom_errorbar(aes(ymin = lower, ymax = upper))+
  scale_x_discrete("Participant", limits=coefs_norm_P_C_part$labels_)+
  scale_y_continuous("Deviation from mean", breaks=c(1:6))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_P_C_part.pdf")

ggplot(coefs_norm_P_C_cond, aes(labels_, center)) +        # ggplot2 plot with 90% credibility limits
  geom_point() +
  scale_x_discrete("Condition", limits = coefs_norm_P_C_cond$labels_)+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_P_C_cond.pdf")

##

lm_C <-  stan_lmer(dist ~ 1+ (1|cond),
                      data = dist_from_mean )

coefs_C <- coef(posterior(lm_C), interval=0.9)

coefs_C

coefs_norm_C_cond <- slice(dplyr::select(coefs_C, center, lower, upper), 2:5)+ 1.98 #(dplyr::select(coefs,center),1)

coefs_norm_C_cond$labels_ = c("raw", "average", "low pass", "scale")

ggplot(coefs_norm_C_cond, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",limits=coefs_norm_C_cond$labels_)+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean__model_C_cond.pdf")


## without outliers (conclusions don't change)

dist_from_mean_outliers_removed <- subset(x= dist_from_mean,
                                          part != 9 &
                                            part != 14)

m_P_C_No_out <-  stan_lmer(dist ~ 1 + (1|part) + (1|cond),
                    data = dist_from_mean_outliers_removed  )

coefs_P_C_No_out <- coef(posterior(m_P_C_No_out), interval=0.9)

coefs_P_C_No_out

coefs_norm_P_C_No_out_part <- slice(dplyr::select(coefs_P_C_No_out, center, lower, upper), 2:18)+  1.7661906 #(dplyr::select(coefs,center),1)
coefs_norm_P_C_No_out_part$labels_ = as.character(c(3,4,5,6,7,8,9,10,12,13,14,15,17,18,19,20,21))

ggplot(coefs_norm_P_C_No_out_part, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",labels=coefs_norm_P_C_No_out_part$labels_)+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_P_C_No_out_part.pdf")

coefs_norm_P_C_No_out_cond <- slice(dplyr::select(coefs_P_C_No_out, center, lower, upper), 19:22)+  1.7661906 #(dplyr::select(coefs,center),1)

coefs_norm_P_C_No_out_cond$labels_=c("raw", "average", "low pass", "scale")

ggplot(coefs_norm_P_C_No_out_cond, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",limits=coefs_norm_P_C_No_out_cond$labels_)+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_P_C_No_out_cond.pdf")
