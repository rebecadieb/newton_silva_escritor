library(dplyr)
library(readr)
library(lubridate)
library(DT)
library(shiny)
library(shinythemes)
library(shinydashboard)
library(flexdashboard)
library(hrbrthemes)
library(wordcloud)

theme <- bslib::bs_theme(version = 4)

shinyUI(fluidPage(theme = theme,
  tags$head(tags$style(HTML(".shiny-output-error-validation {color: red;}"))),
  titlePanel("Newton Silva Escritor"),
  navbarPage("",
    tabPanel( "sobre o autor",
      fluidRow(
        column(2, align="center",
            tags$img(src="WhatsApp Image 2021-06-22 at 16.40.46.jpeg", width="180px", height="210px")),
        column(4, align="center",
          p("Este aplicativo web foi desenvolvido com o intuito de reunir contos, crônicas, poesias e outras classificações do autor, 
            facilitando a busca pelos textos tanto para leitura quanto para coleta de informações, fornecendo também estatísticas e curiosidades.", style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
          br(),
          p(strong("Newton Silva"), "(Fortaleza, novembro de 1960) é chargista, jornalista e ilustrador brasileiro. Começou a ilustrar a seção de quadrinhos do antigo jornal Tribuna do Ceará em 1985. 
            Em 1988 passou a colaborar no jornal Diário do Nordeste. 
            A tira Jujumento, o jumento elemental, foi premiada como primeiro colocado no 1º Festival Nacional de Cinema de Animação, 
            Quadrinhos e Games da região serrana do Rio de Janeiro.",style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
          br(),
          p(strong("Premiações:"),
            br(),
            "A Crônica do Abuso para a coletânea de contos do PRÊMIO DE LITERATURA UNIFOR (edição de 2007)",
            br(),
            "Os encantos de Dona Orlanda para a coletânea de contos do PRÊMIO DE LITERATURA UNIFOR (edição de 2013)",
            br(),
            "Navios Abstratos, escrito em 1987, foi o primeiro colocado no XIII Concurso “Fritz Teixeira de Salles” de Poesia em 2015, da Fundação Cultural “Pascoal Andreta” (Monte Sião – MG)",
            br(),
            "Poema Ponte dos Ingleses no ano de 2018 pelo XX Prêmio Ideal Clube de Literatura",
            style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
          br(),
          p("Os textos podem ser encontrados no", a(href="https://www.recantodasletras.com.br/autor_textos.php?id=71794&categoria=&lista=ultimas", "Recanto das letras", target="_blank"), " e são atualizados mensalmente neste aplicativo web",style="text-align:justify;color:black;background-color:papayawhip;padding:15px;border-radius:10px")
        ),
        column(2, align="center",
          tags$img(src="calamus scribae.jpg",width="190px",height="210px"),
          br(),
          br(),
          p("Para mais informações consulte o blog ", a(href="http://calamus-scribae.blogspot.com/", "Calamus Scribae", target="_blank"),
          br(), style="text-align:justify;color:black")
        )
      ),
      hr(),
      p(em("Desenvolvido por "), a(href="https://github.com/rebecadieb", "Rebeca Dieb", target="_blank"), style="text-align:center; font-family: times")
    ),
    tabPanel("leia",
      p(strong("Busca por títulos e informações")),
      dataTableOutput("tabela_titulos"),
      br(),
      htmlOutput("drilldown")
    ),
    tabPanel("descubra", 
       fluidRow(
          column(4, shinydashboard::valueBoxOutput('total_titulos', width = NULL)),
          column(4, shinydashboard::valueBoxOutput('tempo_publi', width = NULL)),
          column(4, shinydashboard::valueBoxOutput('total_leituras', width = NULL)),
          column(4, shinydashboard::valueBoxOutput('max_leituras', width = NULL)),
          column(4, shinydashboard::valueBoxOutput('min_leituras', width = NULL)),
          column(4, shinydashboard::valueBoxOutput('max_data', width = NULL)),
          column(width=12,
            plotOutput("frequencia_palavras")
          )
        )
      )
    )
  )
)


