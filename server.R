dados <- read_csv("data/textos_dados_recanto_V2.csv")

palavras <-
  read_csv("data/palavras_word_cloud.csv")

# Formatando os dados -----------------------------------------------------

dados_completo <- dados %>%
  group_by(titulo) %>%
  slice(which.max(publicacao)) %>%
  ungroup()

titulos <-
  dados %>%
  mutate(publicacao = format(as.Date(publicacao), "%d/%m/%Y")) %>%
  group_by(titulo) %>%
  summarise(leituras  = sum(leituras),
            publicacao = max(publicacao),
            categoria = first(categoria),
            subcategoria = first(subcategoria)) %>%
  relocate(publicacao, .after = titulo)

tabela_titulos <- titulos %>%
  rename(Título = titulo,
         Publicação = publicacao,
         Leituras = leituras,
         Categoria = categoria,
         Subcategoria = subcategoria)

server <- function(input, output, session) {

# Página leitura ----------------------------------------------------------

  # display the data that is available to be drilled down
  output$tabela_titulos <-
    DT::renderDataTable(tabela_titulos,
                        selection = 'single', filter = "top",
                        options = list(pageLength = 5,
                                       info = FALSE,
                                       columnDefs = list(list(className = 'dt-left', targets = 1:5),
                                                         list(targets = 5, visible = FALSE)))
    )

  # subset the records to the row that was clicked
  drilldata <- reactive({
    shiny::validate(
      need(length(input$tabela_titulos_rows_selected) > 0, "Clique no título para visualizar o texto")
    )

    titulo_sel <-
      tabela_titulos %>%
      slice(as.integer(input$tabela_titulos_rows_selected)) %>%
      select(Título) %>%
      as.character()

    dados_titulo_sel <-
      dados %>%
      filter(titulo==titulo_sel)

    titulo_sel <-
      dados_titulo_sel %>%
      select(titulo) %>%
      as.character()

    cat_sub_sel <-
      dados_titulo_sel %>%
      select(categoria_subcategoria) %>%
      as.character()

    texto_sel <-
      dados_titulo_sel %>%
      select(texto_completo) %>%
      as.character()

    data_sel <-
      dados_titulo_sel %>%
      mutate(data = format(as.Date(publicacao), "%d/%m/%Y")) %>%
      select(data) %>%
      as.character()

    link_sel <-
      dados_titulo_sel %>%
      select(href) %>%
      paste0("https://www.recantodasletras.com.br", .)

    HTML(
      paste(paste("<b> Titulo:", titulo_sel, "</b>"),
            paste("<b> Classificação:", cat_sub_sel, "</b>"),
            texto_sel,
            paste("<b> Publicado em", data_sel),
            paste0('<a href="', link_sel, '">Link no recanto das letras</a>'),
            sep = "<br/><br/>"
      )
    )

  })

  output$drilldown <- renderPrint(drilldata())

# Página estatísticas -----------------------------------------------------

  output$frequencia_palavras <- renderPlot({
    p <- wordcloud(words = palavras$token, freq = palavras$n, min.freq = 20,
              max.words=500, random.order=FALSE, colors = brewer.pal(9, "Greens"))
    p
  })

  output$total_titulos <- shinydashboard::renderValueBox({
    total_textos <-
      titulos %>%
      select(titulo) %>%
      n_distinct()
    shinydashboard::infoBox(total_textos,"títulos", icon = icon("bookmark"))})

  output$tempo_publi <- shinydashboard::renderValueBox({
    tempo_publi <-
      dados_completo %>%
      select(publicacao) %>%
      summarise((max(publicacao)-min(publicacao))/365) %>%
      as.numeric(unlist(.)) %>%
      round()
    shinydashboard::infoBox(tempo_publi, "anos publicando", icon = icon("business-time"))})

  output$total_leituras <- shinydashboard::renderValueBox({
    total_leituras <-
      titulos %>%
      summarise(sum(leituras)) %>%
      as.numeric()
    shinydashboard::infoBox(total_leituras, "leituras", icon = icon("book-reader"))})

  output$max_leituras <- shinydashboard::renderValueBox({
    d <- max(titulos$leituras)
    shinydashboard::infoBox(d, "máximo de leituras em um texto", icon = icon("users"))})

  output$min_leituras <- shinydashboard::renderValueBox({
    d <- min(titulos$leituras)
    shinydashboard::infoBox(d, "mínimo de leituras em um texto", icon = icon("user"))})

  output$max_data <- shinydashboard::renderValueBox({
    d <- format(as.Date(max(dados_completo$publicacao)), "%d/%m/%Y")
    shinydashboard::infoBox(d, "última publicação", icon = icon("calendar-day"))})

}
