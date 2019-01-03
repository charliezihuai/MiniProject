library(dplyr)
library(tidyr)
library(leaflet)
library(rgdal)

#input the map

boroughs<-readOGR(dsn="Data/ESRI") #read the map data

boroughs<-spTransform(boroughs, CRS("+init=epsg:4326"))  #transfer to the format we can work on

bounds<-bbox(boroughs)  #identify the bounds


projectdata<-read.csv("Data/report9916.csv") #get our report data


#preparation the function

function(input, output, session){
  
  #preparation the data
  getDataSet<-reactive({
    
    dataSet<-projectdata[projectdata$Year==input$dataYear & projectdata$Categories==input$cate,] #preparation to get the input
    
    joinedDataset<-boroughs #copy GIS data

    joinedDataset@data <- suppressWarnings(left_join(joinedDataset@data, dataSet, by="NAME")) #combination with 'name'
    
    joinedDataset
  })
  
  #preparation the map
  output$londonMap<-renderLeaflet({
    leaflet() %>% 
      addTiles('http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', 
               attribution='Map tiles by <a href="mailto:ucfnuab@ucl.ac.uk">Zihuai Huang</a>,
               <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; 
               Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>% 
      setView(mean(bounds[1,]), mean(bounds[2,]), zoom=9.5) #setting the default view
    
  })
  
  #year select function 
  output$ChosenYear<-renderUI({
    yearRange<-sort(unique(as.numeric(projectdata$Year)), decreasing=TRUE)
    selectInput("dataYear", "Year", choices=yearRange, selected=yearRange[1])
  })
  
  #setting the style of map
  observe({
    theData<-getDataSet() 
    
    pal <- colorQuantile("Greys", theData$Reports, n = 9) 
    
    dataINFO <- paste0("<strong>Borough: </strong>", 
                            theData$NAME, 
                            "<br><strong>",
                            input$cate," 
                            reports: </strong>", 
                            theData$Reports,
                            "<br><strong>",
                            "Year</strong>: ",
                            theData$Year)
    
    
    
    #for changing the categories or years
    leafletProxy("londonMap", data = theData) %>%
      clearShapes() %>%
      addPolygons(data = theData,
                  fillColor = pal(theData$Reports), 
                  fillOpacity = 0.7, 
                  color = NULL, 
                  weight = 0,
                  popup = dataINFO)})
}