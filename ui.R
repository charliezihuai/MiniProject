library(shiny)
library(shinydashboard)
library(leaflet)


#header design, input the title

header<-dashboardHeader(title="London Crime Report")

#body design
body<-dashboardBody(
  #creating rows
  fluidRow(
    column(width = 12,
           box(width = NULL, solidHeader = TRUE,
               "NOTIFICATION: City of London is not in this map because of the lack of data. Sorry for the inconvenience.",
               p("Thanks for using the tool. This tool is made by ", a("Zihuai Huang", href = "mailto:ucfnuab@ucl.ac.uk"))
               )),
    
    #creating column
    column(width = 9,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("londonMap", height=500)
           )
    ),
    #choosing year & choosing categories
    column(width=3,
           box(width=NULL, 
               uiOutput("ChosenYear"),
               radioButtons("cate", "Categories",c("All recorded offences"="All recorded offences",
                                                   "Violence Against the Person"="Violence Against the Person",
                                                   "Sexual Offences" = "Sexual Offences", "Robbery"="Robbery" , 
                                                   "Burglary"="Burglary" , 
                                                   "Theft and Handling"="Theft and Handling" , 
                                                   "Fraud or Forgery"="Fraud or Forgery" , 
                                                   "Criminal Damage"="Criminal Damage" , 
                                                   "Drugs"="Drugs",
                                                   "Other Notifiable Offences"="Other Notifiable Offences"))
           )
    ),
    #data links for users
    column(width=3,
           box(width=NULL,
               p("Map data is from: ", a("LONDON DATASTORE", href = "https://data.london.gov.uk/dataset/statistical-gis-boundary-files-london")),
               p("Report data is from: ", a("LONDON DATASTORE", href = "https://data.london.gov.uk/dataset/recorded_crime_rates"))
           )
    )
  )
)

#dashboard design
dashboardPage(
  skin = "black",
  header,
  #disable the sidebar
  dashboardSidebar(disable = TRUE),
  body
)