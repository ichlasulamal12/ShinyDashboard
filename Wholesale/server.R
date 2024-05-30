function(input,output){
  output$jumlah_pengajuan <- renderValueBox({
    len <- Summary %>%
      filter_data_by_date(input$dateRange) %>%
      nrow()
    valueBox(
      width = 4,
      value = tags$p(len, style = "font-size: 100%;"), 
      subtitle = "Jumlah Pengajuan", 
      icon = icon("industry"),
      color = "maroon"
    )
  })
  
  output$jumlah_dropping <- renderValueBox({
    count_yes <- Summary %>%
      filter_data_by_date(input$dateRange) %>%
      summarise(dropping_count = sum(Dropping == "Yes", na.rm = TRUE))
    valueBox(
      width = 4,
      value = tags$p(count_yes, style = "font-size: 100%;"), 
      subtitle = "Jumlah Pengajuan yang Dropping", 
      icon = icon("wallet"),
      color = "green"
    )
  })
  
  output$rata_sla <- renderValueBox({
    summary_filter <- Summary %>%
      filter_data_by_date(input$dateRange)
    
    median_sla_adj <- calculate_median(summary_filter$SLA_Adjusment)
    valueBox(
      width = 4,
      value = tags$p(median_sla_adj, "Menit", style = "font-size: 100%;"), 
      subtitle = "Rata-Rata SLA", 
      icon = icon("clock"),
      color = "orange"
    )
  })
  
  # Render line_graph
  output$line_graph <- renderPlot({
    jumlah_data <- Summary %>%
      filter_data_by_date(input$dateRange) %>% 
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
      filter_data_by_date(input$dateRange) %>%
      group_by(`Hasil Rating`) %>% 
      summarise(Jumlah = n(),
                Proporsi = Jumlah/len)
    
    datatable(grade, options = list(paging = FALSE, searching = FALSE, scrollY = "270px"))
  })
  
  # Render distribusi_rating
  output$distribusi_hari <- renderDataTable({
    nama_hari <- c("Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu")
    
    tabel_hari <- Summary %>%
      filter_data_by_date(input$dateRange) %>%
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
