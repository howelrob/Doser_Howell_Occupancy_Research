# 06b_summary.R: script to summarize the results and generate basic figures included 
#                in the manuscript. 
# Author: Jeffrey W. Doser
rm(list = ls())
library(ggplot2)
library(dplyr)
library(viridis)
library(ggthemes)
library(patchwork)

# Simulation Study 1 Spatial Model ----------------------------------------
# Loads an object called summary_df
load("results/summary_sim_1_results.rda")

# Average values within each combination
avg_by_scenario <- summary_df %>%
  group_by(prevalence, sp_decay, n_plot, design, neighbors) %>%
  summarize(bias = mean(bias), 
            coverage = mean(coverage), 
            ci_width = mean(ci_width)) %>%
  ungroup()

# Figure 2 ----------------------------
fig_2_df <- summary_df %>%
  group_by(prevalence, sp_decay, n_plot, design, neighbors) %>%
  summarize(avg_bias = mean(bias), 
            low_bias = quantile(bias, 0.025), 
            high_bias = quantile(bias, 0.975),
            avg_coverage = mean(coverage), 
            low_coverage = quantile(coverage, 0.025), 
            high_coverage = quantile(coverage, 0.975),
            avg_ci_width = mean(ci_width), 
            low_ci_width = quantile(ci_width, 0.025), 
            high_ci_width = quantile(ci_width, 0.975)) %>%
  ungroup()

# Prevalence
prev_fig_df <- fig_2_df %>%
  group_by(prevalence) %>%
  summarize(avg_bias = mean(avg_bias), 
            low_bias = mean(low_bias), 
            high_bias = mean(high_bias), 
            avg_coverage = mean(avg_coverage), 
            low_coverage = mean(low_coverage), 
            high_coverage = mean(high_coverage), 
            avg_ci_width = mean(avg_ci_width), 
            low_ci_width = mean(low_ci_width), 
            high_ci_width = mean(high_ci_width)) %>% 
  mutate(prevalence = round(plogis(prevalence), 2))
prev_fig_bias <- ggplot(data = prev_fig_df, aes(x = factor(prevalence), y = avg_bias)) + 
  geom_point() + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt") + 
  theme_bw(base_size = 18) + 
  theme(text = element_text(family="LM Roman 10")) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Average Occupancy Probability", y = "Bias", title = "(a)")
prev_fig_coverage <- ggplot(data = prev_fig_df, aes(x = factor(prevalence), y = avg_coverage)) + 
  geom_point() + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt") + 
  theme_bw(base_size = 18) + 
  theme(text = element_text(family="LM Roman 10")) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Average Occupancy Probability", y = "Coverage", title = "(b)")
prev_fig_ci_width <- ggplot(data = prev_fig_df, aes(x = factor(prevalence), y = avg_ci_width)) + 
  geom_point() + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt") + 
  theme_bw(base_size = 18) + 
  theme(text = element_text(family="LM Roman 10")) + 
  labs(x = "Average Occupancy Probability", y = "95% CI Width", title = "(c)")

# Figure 3 ----------------------------
# NOTE: hardcoded
design_levels <- c("random", "grid", "h_line", "v_line", "box4", "box16", 
                   "mod_pref", "heavy_pref")
design_names <- c("Simple Random", "Systematic", "Horizontal Transects", "Vertical Transects", 
                  "Small Arrays", "Large Arrays", "Moderate Preferential", 
                  "Heavy Preferential")
fig_1a <- avg_by_scenario %>%
  group_by(design, n_plot) %>% 
  summarize(bias = mean(bias)) %>% 
  mutate(design = factor(as.character(design), levels = design_levels, 
                         labels = design_names)) %>%  
  ggplot(aes(x = n_plot, y = bias, col = design)) + 
    geom_line() +
    geom_point() + 
    geom_hline(yintercept = 0, linetype = 2, col = "black") + 
    scale_x_continuous(breaks = sort(unique(avg_by_scenario$n_plot)), 
                       labels = sort(unique(avg_by_scenario$n_plot))) + 
    theme_bw(base_size = 18) + 
    scale_color_colorblind() + 
    labs(x = "Number of Plots", y = "Bias (Estimated - True)", color = "Design", 
         title = "(a) Bias") +
    theme(text = element_text(family="LM Roman 10"))
fig_1b <- avg_by_scenario %>%
  group_by(design, n_plot) %>% 
  summarize(coverage = mean(coverage)) %>% 
  mutate(design = factor(as.character(design), levels = design_levels, 
                         labels = design_names)) %>%  
  ggplot(aes(x = n_plot, y = coverage, col = design)) + 
    geom_line() +
    geom_point() + 
    geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
    scale_x_continuous(breaks = sort(unique(avg_by_scenario$n_plot)), 
                       labels = sort(unique(avg_by_scenario$n_plot))) + 
    theme_bw(base_size = 18) + 
    scale_color_colorblind() + 
    labs(x = "Number of Plots", y = "Coverage Rate", color = "Design", 
         title = "(b) Coverage") +
    theme(text = element_text(family="LM Roman 10"))
fig_1c <- avg_by_scenario %>%
  group_by(design, n_plot) %>% 
  summarize(ci_width = mean(ci_width)) %>% 
  mutate(design = factor(as.character(design), levels = design_levels, 
                         labels = design_names)) %>%  
  ggplot(aes(x = n_plot, y = ci_width, col = design)) + 
    geom_line() +
    geom_point() + 
    theme_bw(base_size = 18) + 
    scale_color_colorblind() + 
    scale_x_continuous(breaks = sort(unique(avg_by_scenario$n_plot)), 
                       labels = sort(unique(avg_by_scenario$n_plot))) + 
    labs(x = "Number of Plots", y = "95% CI Width", color = "Design", 
         title = "(c) 95% CI width") +
    theme(text = element_text(family="LM Roman 10"))
fig_1 <- fig_1a + fig_1b + fig_1c + plot_layout(guides = "collect")
ggsave(file = 'figures/Figure-3.png', width = 15, height = 5, units = 'in',
       bg = 'white')

