#libraries

install.packages('rfm')
library(rfm)
install.packages('magrittr')
library(magrittr)
library(dplyr)
library(lubridate)

setwd('J:/Jishnu')

transaction_data <- read.csv('Book1.csv', header = T, stringsAsFactors = F)

head(transaction_data)

#Data type conversion

transaction_data$transaction_date <- as.Date(transaction_data$transaction_date)

transaction_data$customer_id <- as.factor(transaction_data$customer_id)

transaction_data$list_price <- as.numeric(transaction_data$list_price)

str(transaction_data)

#creation of rfm table

analysis_date <- as_date('2018-01-01', tz='UTC')

rfm_result <- rfm_table_order(transaction_data, customer_id, transaction_date, list_price, analysis_date)


#segmenting

segment_names <- c("Champions", "Loyal Customers", "Potential Loyalist",
                   "New Customers", "Promising", "Need Attention", "About To Sleep",
                   "At Risk", "Can't Lose Them", "Hibernating", "Lost")

recency_lower   <- c(4, 2, 3, 4, 3, 3, 2, 1, 1, 2, 1)
recency_upper   <- c(5, 4, 5, 5, 4, 4, 3, 2, 1, 3, 1)
frequency_lower <- c(4, 3, 1, 1, 1, 3, 1, 2, 4, 2, 1)
frequency_upper <- c(5, 4, 3, 1, 1, 4, 2, 5, 5, 3, 1)
monetary_lower  <- c(4, 4, 1, 1, 1, 3, 1, 2, 4, 2, 1)
monetary_upper  <- c(5, 5, 3, 1, 1, 4, 2, 5, 5, 3, 1)

segments <- rfm_segment(rfm_result, segment_names, recency_lower, recency_upper,
                        frequency_lower, frequency_upper, monetary_lower, monetary_upper)
segments

#converting tibble to excel

write.table(segments, file = "J:/Jishnu//df.csv", sep = ',')


#tabular segments
segments %>%
  dplyr::count(segment) %>%
  dplyr::arrange(dplyr::desc(n)) %>%
  dplyr::rename(Segment = segment, Count = n)

#average recency
rfm_plot_median_recency(segments)

#average frequency
rfm_plot_median_frequency(segments)

#average monetary value
rfm_plot_median_monetary(segments)

#heatmap
rfm_heatmap(rfm_result)

#barchart
rfm_bar_chart(rfm_result)

#histogram
rfm_histograms(rfm_result)

#customers by orders
rfm_order_dist(rfm_result)

#recency vs monetary value
rfm_rm_plot(rfm_result)

#frequency vs monetary value
rfm_fm_plot(rfm_result)

#recency vs frequency
rfm_rf_plot(rfm_result)

















