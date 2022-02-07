###################
# Clean workspace #
###################

rm(list=ls(all=TRUE))

#############################
# Install and Load Packages #
#############################

reqpkg = c("SuperLearner", "tidyverse", "randomForest", "caret", "devtools", "ROCR", "ggplot2", "reshape2")

# # Install all required packages
# for (i in reqpkg) {
#   print(i)
#   install.packages(i)
# }

# Load all required packages and show version
for (i in reqpkg) {
  print(i)
  print(packageVersion(i))
  library(i, quietly = TRUE, verbose = FALSE, warn.conflicts = FALSE, character.only = TRUE)
}

#############################################################
# Load IntegratedLearner source code (directly from GitHub) #
#############################################################

devtools::source_url("https://github.com/himelmallick/IntegratedLearner/blob/master/scripts/IntegratedLearner_CV.R?raw=TRUE")

#################
# Download Data #
#################

# Load dataset 
load(url("https://github.com/himelmallick/IntegratedLearner/blob/master/data/PRISM.RData?raw=true"))

# Extract individual components 
feature_table<-pcl$feature_table
sample_metadata<-pcl$sample_metadata
feature_metadata<-pcl$feature_metadata
rm(pcl)

# Explore data dimensions
head(feature_table[c(1:3, 9169:9171), 1:5])
head(sample_metadata[c(1:3, 153:155),])
head(feature_metadata[c(1:3, 9169:9171), ])

# How many layers and how many features per layer?
table(feature_metadata$featureType)

# Distribution of outcome (1: IBD, 0: nonIBD)
table(sample_metadata$Y)

# Sanity check
all(rownames(feature_table)==rownames(feature_metadata)) # TRUE
all(colnames(feature_table)==rownames(sample_metadata)) # TRUE

##########################################################################
# Run IntegratedLearner using Random Forest (Expected Time: 4-5 Minutes) #
##########################################################################

fit<-run_integrated_learner_CV(feature_table = feature_table,
                               sample_metadata = sample_metadata, 
                               feature_metadata = feature_metadata,
                               folds = 5,
                               base_learner = 'SL.randomForest',
                               meta_learner = 'SL.nnls.auc',
                               family = binomial(),
                               run_stacked = TRUE,
                               run_concat = TRUE)


#####################
# Visualize results #
#####################

plot.obj <- plot.learner(fit)

#######################
# Variable importance #
#######################

# Metabolites 
VIMP_metabolite<-as.data.frame(randomForest::importance(fit$model_fits$model_layers$metabolites))
VIMP_metabolite<-rownames_to_column(VIMP_metabolite, 'ID')
VIMP_metabolite<-VIMP_metabolite[order(VIMP_metabolite$MeanDecreaseGini, decreasing = TRUE),]
VIMP_metabolite$type<-'Metabolites'

# Microbiome
VIMP_species<-as.data.frame(randomForest::importance(fit$model_fits$model_layers$species))
VIMP_species<-rownames_to_column(VIMP_species, 'ID')
VIMP_species<-VIMP_species[order(VIMP_species$MeanDecreaseGini, decreasing = TRUE),]
VIMP_species$type<-'Species'


# Plot Top 20
VIMP<-as.data.frame(rbind.data.frame(VIMP_metabolite[1:20,],VIMP_species[1:20,]))
VIMP %>% 
  arrange(MeanDecreaseGini) %>% 
  mutate(ID = str_replace_all(ID, fixed("_"), " ")) %>% 
  ggplot(aes(reorder(ID, -MeanDecreaseGini), MeanDecreaseGini)) +
  facet_wrap(.~ type, scale = 'free') + 
  geom_bar(stat = "identity", fill = "lightsalmon") + 
  theme_bw() + 
  coord_flip() + 
  theme (strip.background = element_blank()) + 
  ylab('Variable importance scores') + 
  xlab('') +
  ggtitle('Most informative multi-omics features for predicting IBD status')
  

