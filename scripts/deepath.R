
# details at https://github.com/omicsEye/deepath

# Install devtools
install.packages('devtools')
library(devtools)

# Install the Bioconuctor dependencies
install.packages('BiocManager'); library('BiocManager');


# Install the CRAN dependencies:
install.packages(c('future', 'downloader', 'reader', 'backports', 'gsEasy','pscl','pbapply','car','nlme','dplyr','vegan','chemometrics','ggplot2','pheatmap','cplm','hash','logging','data.table'), repos='http://cran.r-project.org')

# Install deepath library from GitHub
devtools::install_github('omicsEye/deepath', force = TRUE)

# load deepath library
library(deepath)

setwd("~/Downloads/Workshop-main")

# read effect size values from Tweediverse output 
Tweediverse_results <- read.delim(
  "analysis/Tweedieverse_output/all_results.tsv",
  sep = '\t',
  header = T,
  fill = F,
  comment.char = "" ,
  check.names = F,
  #row.names = NA
)
score_data_filtered <- Tweediverse_results[Tweediverse_results$metadata=="Group" & Tweediverse_results$value=="RYGB" ,]
row.names(score_data_filtered)=score_data_filtered$feature

mapper_file <- read.delim('data/pathway_metabolite_map.tsv', 
                          sep = '\t',
                          header = T,
                          fill = F,
                          comment.char = "" ,
                          check.names = F,
                          #row.names = NA
)


deepath_result <- deepath::deepath(
  input_data = score_data_filtered,
  output = "analysis/deepath_output",
  score_col = 'coef',
  pval_threshold = 0.05,
  fdr_threshold = NA,
  Pathway.Subject = NA,#'Metabolic',
  do_plot = TRUE,
  mapper_file = mapper_file,
  method = "ks",
  min_member = 2,
  pathway_col = "SUB_PATHWAY",
  feature_col = "Metabolite")

