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
        valueBox(width = 4,
                 value = tags$p(len, style = "font-size: 100%;"), 
                 subtitle = "Jumlah Pengajuan", 
                 icon = icon("industry"),
                 color = "maroon"),
        valueBox(width = 4,
                 value = tags$p(count_yes, style = "font-size: 100%;"), 
                 subtitle = "Jumlah Pengajuan yang Dropping", 
                 icon = icon("wallet"),
                 color = "maroon"),
        valueBox(width = 4,
                 value = tags$p(median_sla_adj, "Menit", style = "font-size: 100%;"), 
                 subtitle = "Rata-Rata SLA", 
                 icon = icon("clock"),
                 color = "maroon")
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
