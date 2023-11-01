library(readxl)
library(tidyverse)
library(lubridate)

#Summary <- read_excel("Summary Pengajuan Wholesale Loan - 3 November 2023.xlsx", 
#                                                               skip = 2)
Summary <- read_excel("D:/Ichlasul Amal - DKPK/Wholesale/Monitoring/Data Monitoring/Desember 2023/Data Monitoring Wholesale Credit Tool - Desember 2023.xlsx", 
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


# 1. Buat line graph per bulan-tahun
# Menghitung banyaknya data berdasarkan bulan dan tahun menggunakan pipe
jumlah_data <- Summary %>%
  mutate(bulan = month(`Tanggal Permohonan`, label = TRUE), tahun = year(`Tanggal Permohonan`)) %>%
  group_by(tahun, bulan) %>%
  summarise(jumlah = n())

# Membuat plot bar
plot_line <- ggplot(jumlah_data, aes(x = bulan, y = jumlah, color = tahun, group = tahun)) +
  geom_line() +
  labs(title = "Jumlah Data Berdasarkan Bulan-Tahun",
       x = "Bulan",
       y = "Jumlah Data") +
  theme_minimal()  

plot_line

# 2. Jumlah pengajuan
len <- nrow(Summary)
len
# 3. Buat table berdasarkan Grade
grade <- Summary %>% 
  group_by(`Hasil Rating`) %>% 
  summarise(Jumlah = n(),
            Proporsi = Jumlah/len)

grade
# 4. Cari tahu nilai rata-rata SLA Adjusment
calculate_z_score <- function(data) {
  # Menghitung rata-rata dan deviasi standar
  mean_data <- mean(data)
  sd_data <- sd(data)
  
  # Menghitung Z-Score
  z_score <- (data - mean_data) / sd_data
  
  return(z_score)
}

identify_outliers <- function(data) {
  # Hitung Q1 dan Q3
  Q1 <- quantile(data, 0.25)
  Q3 <- quantile(data, 0.75)
  
  # Hitung IQR
  IQR <- Q3 - Q1
  
  # Hitung Batas Atas dan Batas Bawah untuk Outlier
  upper_bound <- Q3 + 1.5 * IQR
  lower_bound <- Q1 - 1.5 * IQR
  
  # Identifikasi outlier
  outliers <- data[data < lower_bound | data > upper_bound]
  
  return(outliers)
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

z_scores <- calculate_z_score(Summary$SLA_Adjusment)
# Membuat histogram dari Z-Scores
hist(z_scores, breaks = 10, main="Histogram of Z-Scores", xlab="Z-Score", ylab="Frequency", col="lightblue")
# Menambahkan garis vertical pada nilai 0
abline(v = 0, col = "red", lty = 2)

outliers <- identify_outliers(Summary$SLA_Adjusment)
cat("Outlier:", outliers, "\n")

median_sla_adj <- calculate_median(Summary$SLA_Adjusment)
median_sla_adj

# 5. Hitung pengajuan yag telah dropping
count_yes <- sum(Summary$Dropping == "Yes", na.rm = TRUE)
count_yes

# 6. Jumlah pengajuan dalam hari
# Konversi nama hari dalam bahasa Indonesia
# Konversi nama hari dalam bahasa Indonesia
nama_hari <- c("Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu")

Summary %>%
  mutate(hari = factor(wday(`Tanggal Permohonan`, week_start = 1), levels = 1:7, labels = nama_hari)) %>%
  group_by(hari) %>%
  summarise(jumlah = n())
