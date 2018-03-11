# this file is to generate a table with occupancy rate using table 1 
# according to the available length
table_occupancy=table1
table_occupancy$house_sum=rowSums(table_occupancy[, c(16:162)])
table_occupancy=table_occupancy[,-c(16:162)]
table_occupancy$occp_rate=0
ava_index=which(table_occupancy$avaliLength!=0)
table_occupancy$occp_rate[ava_index]=((table_occupancy$reviews[ava_index]/0.72)*5.1)/table_occupancy$avaliLength[ava_index]     
length_ho0=220
length_ho1=120
length_ho2=20
table_occupancy$ava_prop=0
index_ho0=which(table_occupancy$isholiday==0)
index_ho1=which(table_occupancy$isholiday==1)
index_ho2=which(table_occupancy$isholiday==2)
table_occupancy$ava_prop[index_ho0]=table_occupancy$avaliLength[index_ho0]/length_ho0
table_occupancy$ava_prop[index_ho1]=table_occupancy$avaliLength[index_ho1]/length_ho1
table_occupancy$ava_prop[index_ho2]=table_occupancy$avaliLength[index_ho2]/length_ho2
summary(table_occupancy$ava_prop)
index_review0=which(table_occupancy$reviews==0)

for (i in index_review0){
        if (0.333<table_occupancy$ava_prop[i] & table_occupancy$ava_prop[i]<0.5)
                {table_occupancy$reviews[i]=0.3}
        else if (0.5<table_occupancy$ava_prop[i] & table_occupancy$ava_prop[i]<0.667)
                {table_occupancy$reviews[i]=0.6}
        else table_occupancy$reviews[i]=0.9
}
table_occupancy$occp_rate_modified=0
table_occupancy$occp_rate_modified[ava_index]=((table_occupancy$reviews[ava_index]/0.72)*5.1)/table_occupancy$avaliLength[ava_index]     
# take out available length and reviews 
# keep only the columns needed as table_clean
table_clean=table_occupancy[,-c(1,3, 6,7,16,18,19)]





