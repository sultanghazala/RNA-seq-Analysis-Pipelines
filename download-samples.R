# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "archs4_gene_human_v2.1.2.h5"
extracted_expression_file = "GSE30017_expression_matrix.tsv"
url = "https://s3.dev.maayanlab.cloud/archs4/archs4_gene_human_v2.1.2.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM742939","GSM742942","GSM742946","GSM742947","GSM742943","GSM742944","GSM742951","GSM742940","GSM742950","GSM742941","GSM742948","GSM742952","GSM742937","GSM742949","GSM742938","GSM742945","")

# Retrieve information from compressed data
samples = h5read(destination_file, "meta/samples/geo_accession")
genes = h5read(destination_file, "meta/genes/gene_symbol")

# Identify columns to be extracted
sample_locations = which(samples %in% samp)

# extract gene expression from compressed data
expression = t(h5read(destination_file, "data/expression", index=list(sample_locations, 1:length(genes))))
H5close()
rownames(expression) = genes
colnames(expression) = samples[sample_locations]

# Print file
write.table(expression, file=extracted_expression_file, sep="\t", quote=FALSE, col.names=NA)
print(paste0("Expression file was created at ", getwd(), "/", extracted_expression_file))

