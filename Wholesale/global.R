library(shiny)
library(shinydashboard)
library(readxl)
library(tidyverse)
library(lubridate)
library(DT)

Summary <- read_excel("data.xlsx", 
                      sheet = "Data", range = "A2:O121")

Summary <- Summary[Summary$No != 39, ]

Summary$SLA <- as.numeric(difftime(Summary$`Tanggal Proses Rating`, Summary$`Tanggal Permohonan`, units = "mins"))

# Daftar ID baris yang ingin Anda ubah
rows_to_modify <- c(3, 5, 8, 9, 10, 16, 26, 27, 28, 31, 33, 35, 41, 45, 54, 56,
                    63, 67, 72, 83, 84, 92, 103, 107, 109, 115, 119)

# Nilai baru untuk setiap baris yang ingin diubah
new_values <- c(27, 4, 11, 12, 14, 30, 1, 24, 53, 21, 14, 18, 25, 40, 1, 7,
                19, 41, 2, 1, 4, 2, 1, 81, 150, 15, 1)

# Membuat kolom baru "SelisihMenitBaru" dengan nilai awal dari "SelisihMenit"
Summary$SLA_Adjusment <- Summary$SLA

# Loop untuk mengubah nilai selisih menit
for (i in 1:length(rows_to_modify)) {
  row_id <- rows_to_modify[i]
  new_value <- new_values[i]
  Summary$SLA_Adjusment[Summary$No == row_id] <- new_value
}

# Fungsi untuk menghitung median dari vektor
calculate_median <- function(data) {
  n <- length(data)  # Jumlah data
  sorted_data <- sort(data)  # Mengurutkan data
  
  if (n %% 2 == 1) {
    # Jika jumlah data ganjil, median adalah nilai tengah
    median_value <- sorted_data[(n + 1) %/% 2]
  } else {
    # Jika jumlah data genap, median adalah rata-rata dari dua nilai tengah
    median_value <- mean(sorted_data[c(n %/% 2, (n %/% 2) + 1)])
  }
  
  return(median_value)
}

len <- nrow(Summary)
count_yes <- sum(Summary$Dropping == "Yes", na.rm = TRUE)
median_sla_adj <- calculate_median(Summary$SLA_Adjusment)
