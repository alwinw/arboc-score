library(shiny)
library(DT)

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("AKI risk based on creatinine (ARBOC) score"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(
        inputId = "factors",
        label = "Risk Factors:",
        choiceNames =
          list(
            "Cardiac Surgery",
            "Vasopressor Use",
            "Chronic Liver Disease",
            "Cr change =1µmol/L/h over 4-5.8 hours"
          ),
        choiceValues =
          list("PCs", "Vas", "CLD", "Crch")
      ),
      textOutput("score")
    ),

    mainPanel(
      dataTableOutput("table")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  points_table <- c(PCs = 1, Vas = 3, CLD = 1, Crch = 1)

  raw_table <- data.frame(
    `Total Points` = c("0", "1", "2", "3", "4", "5", "6"),
    `Risk` = c("Low", "Low", "Medium", "Medium", "High", "High", "High"),
    `Risk of stages 2 or 3 AKI in 8.7 to 25.6 hours` = c("0.7%", "2.3%", "12.7%", "26.5%", "42.4%", "85.3%", ">85.3%"),
    check.names = FALSE
  )

  score_table <- datatable(
    raw_table,
    rownames = FALSE, selection = "none",
    options = list(dom = "t", pageLength = 10)
    ) %>%
    formatStyle(
      "Total Points",
      target = "row",
      backgroundColor = styleEqual(
        0:6, c("#97FF97", "#97FF97", "#FFFFA7", "#FFFFA7", "#FFA7A7", "#FFA7A7", "#FFA7A7")
      )
    )

  output$score = renderText({
    score = sum(points_table[input$factors], 0, na.rm = TRUE)
    paste("ARBOC Score:", score)
  })

  output$table <- renderDataTable({
    row = sum(points_table[input$factors], 0, na.rm = TRUE)
    score_table %>%
      formatStyle(
        "Total Points",
        target = "row",
        fontWeight = styleEqual(row, "bold")
      )
  })
}

# Run the application
shinyApp(ui = ui, server = server)
