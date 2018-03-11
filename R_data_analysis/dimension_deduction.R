# This is first try to clean the fianal table and regression results
summary=X_finalTable  # this file is summary of price and review
list=modified_data # this file is the house information
final=merge(summary, list, by=c("listing_id")) 
table=final
#table$occupancy=((table$reviews/0.72)*5.1)/table$avaliLength

# 1. Delete useless data
# a. inactive year 
table$ID <- seq.int(nrow(table))
del_idx=c()
l_id=unique(final$listing_id)
for (i in l_id){
        for (j in 2015:2017){
                sub=subset(final, final$listing_id==i & final$years==j)
                if (sum(sub$avaliLength)==0){
                        del_idx=append(del_idx, sub$ID)
                }
        }
}
table_copy=table
table_copy_del=table_copy[-del_idx,] # this is the final after deleting inactive year

# b. inactive listing given year (available length less than 50% of the total length)
del_idx1=c()
l_id1=unique(final_copy_del$listing_id)
for (i in l_id1){
        for (j in 2015:2017){
                sub1=subset(final_copy_del, final_copy_del$listing_id==i & final_copy_del$years==j)
                if (sum(sub1$avaliLength)/365<.3){
                        del_idx1=append(del_idx1, sub1$ID)
                }
        }
}
table_copy_del1=table_copy_del
table_copy_del1=table_copy_del[!(table_copy_del$ID %in% del_idx1),]
table1=table_copy_del1
####### table 1 is the table deleted inactive house listing ####################



