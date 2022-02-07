# 1- install GWDBB package
library(devtools)
install_github('GWCBI/GWDBB')
library(GWDBB)
# 2- load HMP1-II metadata
data("HMP1_II_Metadata")

# 3- See the data: there is mislocation of headers due to space in a clumn header
View(HMP1_II_Metadata)

# 4- fix the headers
colnames(HMP1_II_Metadata) <- c("Person_ID", "VISNO", "Body_area", "Body_site", "SNPRNT",  "Gender", "WMSPhase")

# 5- slect meatadata of interest
my_HMP_metadata <- HMP1_II_Metadata[,c("Body_area", "Body_site", "Gender")]

# 6- write the meatdata in you computer as a tab-delimited file 
write.table( my_HMP_metadata, 'data/my_HMP_metadata.txt', sep = "\t", eol = "\n", na = "", col.names = NA, quote= F, row.names = T)

# 7- load HMP1-II microbial species abundances
data("HMP1_II_Microbial_Species")
HMP1_II_Microbial_Species <- t(HMP1_II_Microbial_Species)
# 8- calculate simailrty between samples based on microbial species abundance
library(vegan)
veg_dist <- as.matrix(vegdist(HMP1_II_Microbial_Species, method="bray"))

# 9- write the  in you computer as a tab-delimited file

write.table( veg_dist, 'data/HMP_disatnce.txt', sep = "\t", eol = "\n", na = "", col.names = NA, quote= F, row.names = T)


#### run community detection method, omeClust ######
# run omeClust from command line
# 1- first you need install omeClust using "$ sudo pip3 install omeClust" 
# 2- Check the version of the tool using "$ omeClust --version" you should see "omeClust 1.1.5" as the result
# 3- run the following command to make sure your installation was successful adn see the OmeClust options "$ omeClust -h"
# 4- run the tool using HMP1-II data and metadata using "$ omeClust -i HMP_disatnce.txt --metadata my_HMP_metadata.txt -o HMP_omeClust"
# 5- discuss the results among your group, bring two interesting biological findings and one question to the main session
