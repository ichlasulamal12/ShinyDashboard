header <- dashboardHeader(title = "Wholesale Summary Dashboard")

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(
      text = "Home",
      tabName = "home",
      icon = icon("h-square")
    ),
    menuItem(
      text = "Dataset",
      tabName = "data",
      icon = icon("book")
    )
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(
      tabName = "home",
      fluidPage(
        dateRangeInput("dateRange", "Pilih Range Data:", 
                       start = min(Summary$`Tanggal Permohonan`), 
                       end = max(Summary$`Tanggal Permohonan`))
      ),
      fluidPage(
        valueBoxOutput("jumlah_pengajuan"),
        valueBoxOutput("jumlah_dropping"),
        valueBoxOutput("rata_sla")
      ),
      fluidPage(
        box(width = 12,
            solidHeader = TRUE,
            title = "Pengajuan Kredit Wholesale melalui WCT",
            plotOutput(outputId = "line_graph")
        )
      ),
      fluidPage(
        box(width = 6,
            height = "400px",
            solidHeader = TRUE,
            title = "Distribusi Rating Pengajuan",
            DTOutput("distribusi_rating")
        ),
        box(width = 6,
            height = "400px",
            solidHeader = TRUE,
            title = "Distribusi Pengajuan dalam Hari",
            DTOutput("distribusi_hari")
        )
      )
    ),
    tabItem(
      tabName = "data",
      h2(tags$b("Summary Pengajuan Wholesale Credit Tool")),
      DTOutput("data_summary")
    )
  )
)

dashboardPage(
  header = header,
  body = body,
  sidebar = sidebar,
  skin = "purple"
)
