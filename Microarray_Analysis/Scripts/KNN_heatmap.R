# Create a tiff.
plot.new()
# tiff(
#   filename = file.path("Results","KNN_train_heatmap.tiff"),
#   width = 1024, height = 1024, pointsize = 28
# )

tiff(
  filename = file.path("Results","KNN_train_heatmap.tiff"),
  width = 6.5, height = 4.5, unit = "in",
  pointsize = 12, res = 300
)

heatmap.2( as.matrix(
  knn_df %>%
    as.data.frame() %>%
    tibble::column_to_rownames(., "Sample" )%>%
    .[,grepl("^ENSG",colnames(.))]
) %>% t(),
distfun = dist,
# Colv = predd,
Rowv = TRUE,
labRow = as.character(knn_gene_symbols),
ColSideColors = ifelse(knn_df$Location == "AIUP", "blue", "red"),
hclustfun = hclustAvg,
trace = "none",
# col = hclrs,
col = colorpanel(100, "blue", "white", "red"),
#dendrogram = "column",
scale = "row",
margins = c( 3.4, 8 ), #column and row name spacing
density.info = "none",
key.title = "Gene Expression",
#adjCol = c( 1, 0 )
#lmat = rbind( c( 0, 4 ), c( 0, 1 ), c( 3, 2 ) ),
#lhei = c( lcm( 2 ) , lcm( 2 ), lcm( 2 ) ),
# lwid = c( 1, 6 ),
#keysize = 0.5,
#key.par = list( cex=0.7 )
)

legend( x = -0.09, y = 0.85,
        legend = sort(unique(knn_df$Location)),
        #col = ifelse( sort( unique( phen.tab$Location ) ) == "AIUP", "blue", "red" ),
        #lty= 1,
        #lwd = 2,
        bty = "n",
        fill = ifelse(sort(unique(knn_df$Location)) == "AIUP", "blue", "red" ),
        cex=.8,
        xpd = T,
)


# Create a png.
plot.new()
# tiff(
#   filename = file.path("Results","KNN_train_heatmap.tiff"),
#   width = 1024, height = 1024, pointsize = 28
# )

png(
  filename = file.path("Results","KNN_train_heatmap.png"),
  width = 6.5, height = 4.5, unit = "in",
  pointsize = 12, res = 300
)

heatmap.2( as.matrix(
  knn_df %>%
    as.data.frame() %>%
    tibble::column_to_rownames(., "Sample" )%>%
    .[,grepl("^ENSG",colnames(.))]
) %>% t(),
distfun = dist,
# Colv = predd,
Rowv = TRUE,
labRow = as.character(knn_gene_symbols),
ColSideColors = ifelse(knn_df$Location == "AIUP", "blue", "red"),
hclustfun = hclustAvg,
trace = "none",
# col = hclrs,
col = colorpanel(100, "blue", "white", "red"),
#dendrogram = "column",
scale = "row",
margins = c( 3.4, 8 ), #column and row name spacing
density.info = "none",
key.title = "Gene Expression",
#adjCol = c( 1, 0 )
#lmat = rbind( c( 0, 4 ), c( 0, 1 ), c( 3, 2 ) ),
#lhei = c( lcm( 2 ) , lcm( 2 ), lcm( 2 ) ),
# lwid = c( 1, 6 ),
#keysize = 0.5,
#key.par = list( cex=0.7 )
)

legend( x = -0.09, y = 0.85,
        legend = sort(unique(knn_df$Location)),
        #col = ifelse( sort( unique( phen.tab$Location ) ) == "AIUP", "blue", "red" ),
        #lty= 1,
        #lwd = 2,
        bty = "n",
        fill = ifelse(sort(unique(knn_df$Location)) == "AIUP", "blue", "red" ),
        cex=.8,
        xpd = T,
)
