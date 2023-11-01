function(input,output){
  # Render line_graph
  output$line_graph <- renderPlot({
    jumlah_data <- Summary %>%
      mutate(bulan = month(`Tanggal Permohonan`, label = TRUE), tahun = year(`Tanggal Permohonan`)) %>%
      group_by(tahun, bulan) %>%
      summarise(jumlah = n())
    
    ggplot(jumlah_data, aes(x = bulan, y = jumlah, color = tahun, group = tahun)) +
      geom_line() +
      labs(x = "Bulan",
           y = "Jumlah Data") +
      theme_minimal()
  })
  
  # Render distribusi_rating
  output$distribusi_rating <- renderDataTable({
    grade <- Summary %>% 
      group_by(`Hasil Rating`) %>% 
      summarise(Jumlah = n(),
                Proporsi = Jumlah/len)
    
    datatable(grade, options = list(paging = FALSE, searching = FALSE, scrollY = "270px"))
  })
  
  # Render distribusi_rating
  output$distribusi_hari <- renderDataTable({
    nama_hari <- c("Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu")
    
    tabel_hari <- Summary %>%
      mutate(hari = factor(wday(`Tanggal Permohonan`, week_start = 1), levels = 1:7, labels = nama_hari)) %>%
      group_by(hari) %>%
      summarise(jumlah = n())
    
    datatable(tabel_hari, options = list(paging = FALSE, searching = FALSE, scrollY = "270px"))
  })
  
  # Render data_summary
  output$data_summary <- renderDataTable({
    datatable(Summary, options = list(scrollX = T))
  })
}