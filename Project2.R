## Tumor size vs Patient Age Project
## load the dataset and required packages
library(Biobase)
library(breastCancerMAINZ)
data(mainz)
clinical_data <- pData(mainz)
mainz
## create a plots folder if necessary
dir.create("plots", showWarnings = FALSE)
## look at the clinical data in the dataset
clinical_data <- pData(mainz)
dim(clinical_data)
head(clinical_data)
## look at whether age and tumor size are contained in the dataset
summary(clinical_data$age)
summary(clinical_data$size)
## look for missing values
sum(is.na(clinical_data$age))
sum(is.na(clinical_data$size))
## examine the structure of the variable
str(clinical_data$age)
str(clinical_data$size)
## look at age range of patients
range(clinical_data$age)
## look at the tumor size range
range(clinical_data$size)
## start creating the scatter plot of tumor size vs age
## load ggplot2
library(ggplot2)
## make the graph
## create a scatter plot of tumor size versus patient age
age_size_plot <- ggplot(
  clinical_data,
  aes(x = age, y = size)
) +
  geom_point(
    alpha = 0.65,
    size = 2
  ) +
  geom_smooth(
    method = "lm",
    se = TRUE
  ) +
  labs(
    title = "Patient Age and Tumor Size",
    subtitle = "MAINZ breast cancer cohort (n = 200)",
    x = "Patient age (years)",
    y = "Tumor size (cm)"
  ) +
  theme_classic(base_size = 12) +
  theme(
    plot.title = element_text(
      face = "bold",
      size = 15,
      hjust = 0.5
    ),
    plot.subtitle = element_text(
      size = 11,
      hjust = 0.5
    ),
    plot.title.position = "plot"
  )
## display the plot
print(age_size_plot)
## save the plot to the folder names 'plots'
ggsave(
  filename = "plots/Age_vs_Tumor_Size.png",
  plot = age_size_plot,
  width = 8,
  height = 6,
  units = "in",
  dpi = 600
)
## look at the relationship between patient age and tumor size
## Pearson's correlation
## calculate the Pearson's correlation between patient age and tumor size
pearson_correlation <- cor(
  clinical_data$age,
  clinical_data$size,
  method = "pearson"
)
## display the correlation coefficient
print(pearson_correlation)
## start the subsampling 
## start the sampling from the same point every time
set.seed(123)
## choose the sample sizes
## these values were chosen as they double each time
sample_sizes <- c(20, 40, 80, 160)
## number of times to repeat the sampling
## 1000 is sufficient to have a lot of repeats but won't take too long 
n_repeats <- 1000
## create an empty data frame to store the results
subsample_results <- data.frame()
## repeat the analysis for each sample size
for (n in sample_sizes) {
  ## create a place to store the 1,000 correlations
  correlations <- numeric(n_repeats)
  ## repeat the random sampling 1,000 times
  for (i in 1:n_repeats) {
    ## randomly select patients without replacing them
    sampled_rows <- sample(
      seq_len(nrow(clinical_data)),
      size = n,
      replace = FALSE
    )
    ## calculate the Pearson's correlation for this sample
    correlations[i] <- cor(
      clinical_data$age[sampled_rows],
      clinical_data$size[sampled_rows],
      method = "pearson"
    )
  }
  ## add these results to the results data frame created
  subsample_results <- rbind(
    subsample_results,
    data.frame(
      sample_size = n,
      correlation = correlations
    )
  )
}
## review the results from the subsampling
head(subsample_results)
## check the dimensions of the results. we'll need theese for the graph 
dim(subsample_results)
## prepare the results from the subsampling for plotting by creating a factor.
## we can use this in the plot
subsample_results$sample_size <- factor(
  subsample_results$sample_size,
  levels = c(20, 40, 80, 160)
)
## create a boxplot using a color gradient. make sure sample size is a category
subsample_results$sample_size <- factor(
  subsample_results$sample_size,
  levels = c(20, 40, 80, 160)
)
## calculate the standard deviation of the correlation estimates for 
## each sample size
## we will display these
correlation_variability <- aggregate(
  correlation ~ sample_size,
  data = subsample_results,
  FUN = sd
)
## make sure sample size uses the same factor levels in the SD data frame 
## as before
correlation_variability$sample_size <- factor(
  correlation_variability$sample_size,
  levels = c(20, 40, 80, 160)
)
## create a boxplot showing the distribution of correlation estimates
subsampling_plot <- ggplot(
  subsample_results,
  aes(
    x = sample_size,
    y = correlation,
    fill = sample_size
  )
) +
  ## add the boxplots
  geom_boxplot(
    width = 0.6,
    alpha = 0.85,
    colour = "black",
    linewidth = 0.7
  ) +
  ## add the SD above each boxplot
  geom_text(
    data = correlation_variability,
    aes(
      x = sample_size,
      y = 0.72,
      label = paste0("SD = ", round(correlation, 3))
    ),
    inherit.aes = FALSE,
    size = 3.5
  ) +
  ## add the correlation from the full cohort as a reference line
  geom_hline(
    yintercept = pearson_correlation,
    linetype = "dashed",
    colour = "black",
    linewidth = 0.8
  ) +
  ## use a light blue gradient for increasing sample sizes
  scale_fill_manual(
    values = c(
      "20" = "#EAF4FB",
      "40" = "#D2E8F5",
      "80" = "#B5D9EE",
      "160" = "#8FC5E3"
    )
  ) +
  ## add titles and axis labels
  labs(
    title = "Effect of Sample Size on Pearson Correlation",
    subtitle = "1,000 random subsamples at each sample size",
    x = "Number of patients (individuals)",
    y = "Pearson correlation coefficient (r)"
  ) +
  ## format the graph
  theme_classic(base_size = 12) +
  theme(
    plot.title = element_text(
      face = "bold",
      size = 15,
      hjust = 0.5
    ),
    plot.subtitle = element_text(
      size = 11,
      hjust = 0.5
    ),
    plot.title.position = "plot",
    legend.position = "none"
  )
## display the graph
print(subsampling_plot)
## save the  graph to the folder named 'plots'
ggsave(
  filename = "plots/Subsampling_Pearson_Correlation.png",
  plot = subsampling_plot,
  width = 8,
  height = 6,
  units = "in",
  dpi = 600
)
