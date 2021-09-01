library(TwoSampleMR)
library(dplyr)
setwd('/home/adity/Documents/Horizon/test/')
# Load the downloaded RData object. This will load the rf object
load("store/rf.rdata")
#ao = available_outcomes()

exposures = c('ebi-a-GCST004627', 'ebi-a-GCST004629', 'ebi-a-GCST004608', 'ebi-a-GCST004603', 'ieu-a-1056', 'ieu-a-271', 'ukb-b-1937', 'prot-a-266', 'ukb-d-30020_irnt')
outcomes = c('ebi-a-GCST005038', 'ukb-b-18335', 'ukb-b-12930', 'ukb-b-11497', 'ukb-b-7872', 'ukb-b-14944')


for (exposure in exposures) {
  for (outcome in outcomes) {
    if (file.exists(paste0("RES_MOE/",exposure,"_", outcome, ".csv"))) {
      next
    }
    if (file.exists(paste0("RES_MOE/",exposure,"_", outcome, ".csv"))){
      variants_harmonised = read.csv(paste0('RES_MOE/', exposure,"_", outcome, "_harmonised.csv"), stringsAsFactors=F)
    } else {
      variants_exposure = extract_instruments(exposure)
      variants_outcome = extract_outcome_data(variants_exposure$SNP, outcome)
      variants_harmonised = harmonise_data(variants_exposure, variants_outcome)
      write.csv(variants_harmonised, file=paste0('RES_MOE/', exposure,"_", outcome, "_harmonised.csv"), row.names=F)
    }
    if (nrow(variants_harmonised) == 0){
      next
    }
    result <- mr_wrapper(variants_harmonised)
    res_moe <- mr_moe(result, rf)
    res_moe_df = as.data.frame(res_moe[[1]]$estimates)
    write.csv(x = res_moe_df, file = paste0("RES_MOE/",exposure,"_", outcome, ".csv"), row.names = F)
    result_plot = mr(variants_harmonised)
    p1 <- mr_scatter_plot(result_plot, variants_harmonised)
    png(file=paste0("PLOT/",exposure,"_", outcome, ".png"))
    print(p1)
    dev.off()
  }
}
