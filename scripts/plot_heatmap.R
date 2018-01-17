#! /usr/bin/env Rscript


if (!require("optparse")) {
   install.packages("optparse", dependencies = TRUE)
   }
if (!require("gplots")) {
   install.packages("gplots", dependencies = TRUE)
   }
if (!require("RColorBrewer")) {
   install.packages("RColorBrewer", dependencies = TRUE)
   }
library(gplots)
library(RColorBrewer)
suppressPackageStartupMessages(library("optparse"))


###############################################################################
## OPTPARSE
###############################################################################

option_list <- list(
        make_option(c("-f", "--file"), default="",
                help = "File matrix"),
        make_option(c("-o", "--output_path"), default=file.path(getwd(), 'heatmap.pdf'),
                help = "Output path for result files")
)

opt <- parse_args(OptionParser(option_list=option_list))

###############################################################################
## MAIN
##############################################################################


data <- read.table(opt$file, header=TRUE)
rnames <- rownames(data)                    # assign labels in column 1 to "rnames"
mat_data <- data.matrix(data[,2:ncol(data)])  # transform column 2-5 into a matrix
rownames(mat_data) <- rnames

# creates a own color palette from red to green
my_palette <- colorRampPalette(c("firebrick", "greenyellow"))(n = 2)

pdf(opt$output_path)
	heatmap.2(mat_data,
	  main = "", # heat map title
	  density.info="none",  # turns off density plot inside color legend
	  trace="none",         # turns off trace lines inside the heat map
	  col=my_palette,       # use on color palette defined earlier
	  dendrogram="row",     # only draw a row dendrogram
	margins =c(8,9),
	xlab='Proteins',
	ylab='Strains',
	labCol = FALSE,
	  Colv="NA")            # turn off column clustering
	
dev.off()
