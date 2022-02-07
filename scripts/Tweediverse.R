
install.packages('devtools')
library(devtools)
devtools::install_github("himelmallick/Tweedieverse")
library(Tweedieverse)

setwd("~/Dropbox/Workshop/ICSA_2021/ICSA_2021_Workshop")

metadata <- read.table(
  'data/sample_info.txt',
  sep = '\t',
  header = TRUE,
  fill = FALSE,
  comment.char = "" ,
  check.names = FALSE,
  row.names = 1
)

data <- read.table(
  'data/metabolites.txt',
  sep = '\t',
  header = TRUE,
  fill = FALSE,
  comment.char = "" ,
  check.names = FALSE,
  row.names = 1
)

# Filter data
sub_metadata <- metadata[metadata$Site == "Portal" & metadata$Time == "Month 3",]
sub_metadata <- sub_metadata[c("Group"), drop = FALSE]
sub_data <-  data[match(rownames(sub_metadata), rownames(data)),]

Tweedieverse::Tweedieverse(sub_data, 
                           sub_metadata, 
                           'analysis/Tweedieverse_output',
                           abd_threshold = 0,
                           prev_threshold = 0.1, 
                           max_significance = 0.1,
                           plot_heatmap = T,
                           plot_scatter = T,
                           standardize = F,
                           reference='Group,Weight Matched'
)
dev.off()
