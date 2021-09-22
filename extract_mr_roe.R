setwd('/Users/adityamittal/Documents/Horizon/aditya_mittal_mr')
exposures = c('ebi-a-GCST004627', 'ebi-a-GCST004629', 'ebi-a-GCST004608', 'ebi-a-GCST004603',
              'ieu-a-1056 ', 'ieu-a-271', 'ukb-b-1937', 'prot-a-266', 'ukb-d-30020_irnt')
outcomes = c('ebi-a-GCST005038', 'ukb-b-18335', 'ukb-b-12930', 'ukb-b-11497', 'ukb-b-7872', 'ukb-b-14944')

df = NULL 
for (exposure in exposures){
  for (outcome in outcomes){
    if (file.exists(paste0("RES_MOE/", exposure, "_", outcome, ".csv"))){
      res_moe_df = read.csv(file = paste0("RES_MOE/",exposure,"_", outcome, ".csv"))
      estimates = res_moe_df
      index = which.max(x = estimates$MOE)
      loc_exposure = which(ao$id == as.character(estimates$id.exposure[index]))
      exposure_name = as.character(ao[loc_exposure,]$trait)
      loc_outcome = which(ao$id == as.character(estimates$id.outcome[index]))
      outcome_name = as.character(ao[loc_outcome,]$trait)
      val = cbind(estimates[index,], exposure_name)
      val = cbind(val, outcome_name) 
      if (is.null(df)) {
        df = val
      } else {
        df = rbind(df, val)
      }
    }
  }
}

df = df[order(df$pval),]
write.csv(x = df, file = "Best_MR_Results.csv")


