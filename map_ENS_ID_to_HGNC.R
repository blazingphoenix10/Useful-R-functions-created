# Author: B P Kailash
# GitHub profile: blazingphoenix10
# Date: 14th May 2020

# Creating the mapping file ------------------------------------------------

# The following mapping file is got from https://m.ensembl.org/info/data/biomart/index.html

hgnc_mapping <- read.delim(paste(path_data,"martquery_0322100222_371.txt",
                                 sep = ""),stringsAsFactors = FALSE, sep = "\t")
hgnc <- hgnc_mapping[,c(2,4)]
mapping_exists <- which(hgnc[,2] != "")
hgnc <- hgnc[mapping_exists,]
stopifnot(hgnc[,2] != "")
multiple_mapping_ens  <- which(!duplicated(hgnc[,1]))
multiple_mapping_hgnc <- which(duplicated(hgnc[,2]))
hgnc_no_dup <- hgnc[multiple_mapping_ens, ]
stopifnot(length(which(duplicated(hgnc_no_dup[,1]))) == 0)
# I am retaining multiple mapping to HGNC symbols.

# NOTE duplicated identifies the second time a particular value re-appears
# IT doesn't show both the first time and the second time it appears
# hgnc has many - many mapping.

map <- match(ens_ids,hgnc_no_dup[,1])
genes_mapped <- hgnc_no_dup[map,2]
ens_ids_no_mapping <- ens_ids[which(is.na(genes_mapped))]

# I use https://www.biotools.fr/human/ensembl_symbol_converter
# to find the human gene symbols for the above ENS ids with no mapping
# then those mappings are manually appended to the exising mapping file to create
# the combined mapping file, which is also uploaded on GitHub

combined_mapping_file <- read.csv("biomart_biotools_combined_mapping_file.csv",
                                  stringsAsFactors = FALSE)

# The function ------------------------------------------------------------

find_genes_mapped <- function(ens_ids, combined_mapping_file){
  combined_mapping_file <- combined_mapping_file[,c("Gene.stable.ID","HGNC.symbol")]
  mapping_exists <- which(combined_mapping_file[,2] != "")
  combined_mapping_file <- combined_mapping_file[mapping_exists, ]
  genes_mapped <- combined_mapping_file[,2][match(ens_ids, combined_mapping_file[,1])]
  length(which(is.na(genes_mapped)))
  return(genes_mapped)
}