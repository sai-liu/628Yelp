library(shiny)
library(ggplot2)
library(leaflet)

#setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
Suggestion=read.csv("./Suggestion.csv")


ui<-navbarPage('Yelp App Suggestion For Pizza Business',inverse = T,collapsible = T,
               tabPanel("Group 4",
                          sidebarLayout(position = "left",
                                      sidebarPanel(
                                        selectInput("city","Your City:",list('Madison','Cleveland','Pittsburgh','Urbana-Champaign')),
                                        uiOutput("your_business_name"),
                                        uiOutput("your_business_address"),
                                        actionButton("submit", "Submit"),
                                        helpText("Select your business city and find your business name and address here. By city, address and your name, we can confirm who you are.")
                                        
                                      ),
                                      mainPanel(tabsetPanel(
                                        
                                        tabPanel("Basic Information",
                                                 h3("What is it?"),htmlOutput("BasicSuggestionHelp"),tags$style("#BasicSuggestionHelp {font-size:16px;}"),
                                                 h3("Business Name:"),htmlOutput("your_name"),tags$style("#your_name {font-size:16px;}"),
                                                 h3("Address:"),htmlOutput("your_address"),tags$style("#your_address {font-size:16px;}"),leafletOutput("positionPlot",width="100%",height="600px"),
                                                 h3("Business Star Rating in Yelp:"),htmlOutput("stars"),tags$style("#stars {font-size:16px;}"),plotOutput(outputId="starsPlot"),
                                                 h3("Total Review Number in Our Data Base:"),htmlOutput("Review_Num"),tags$style("#Review_Num {font-size:16px;}"),
                                                 h3("Average Review Star Rating:"),htmlOutput("Average_Review_Star_Rating"),tags$style("#Average_Review_Star_Rating {font-size:16px;}"),plotOutput(outputId="Average_Review_Star_RatingPlot")
         
                                                 ),
                                        
                                        
                                        tabPanel("Business Suggestion",
                                                 h3("What is it?"),textOutput("BusinessSuggestionHelp"),tags$style("#BusinessSuggestionHelp {font-size:16px;}"),
                                                 h3("Alcohol:"),textOutput("Alcohol"),tags$style("#Alcohol {font-size:16px;}"),
                                                 h3("Park for Bikes:"),textOutput("BikeParking"),tags$style("#BikeParking {font-size:16px;}"),
                                                 h3("Kids:"),textOutput("GoodForKids"),tags$style("#GoodForKids {font-size:16px;}"),
                                                 h3("Noise Level:"),textOutput("NoiseLevel"),tags$style("#NoiseLevel {font-size:16px;}"),
                                                 h3("Groups:"),textOutput("RestaurantsGoodForGroups"),tags$style("#RestaurantsGoodForGroups {font-size:16px;}"),
                                                 h3("Reservations:"),textOutput("RestaurantsReservations"),tags$style("#RestaurantsReservations {font-size:16px;}"),
                                                 h3("WiFi:"),textOutput("WiFi"),tags$style("#WiFi {font-size:16px;}"),
                                                 h3("Delivery:"),textOutput("RestaurantsDelivery"),tags$style("#RestaurantsDelivery {font-size:16px;}"),
                                                 h3("Park for Cars:"),textOutput("BusinessParking"),tags$style("#BusinessParking {font-size:16px;}")
                                                 ),
                                        
                                        tabPanel("Menu Suggestion",
                                                 h3("What is it?"),textOutput("MenuSuggestionHelp"),tags$style("#MenuSuggestionHelp {font-size:16px;}"),
                                                 h3("What you can add"),htmlOutput("add"),tags$style("#add {font-size:16px;}"),
                                                 h3("What you can keep"),htmlOutput("keep"),tags$style("#keep {font-size:16px;}"),
                                                 h3("What you can fix"),htmlOutput("fix"),tags$style("#fix {font-size:16px;}"),
                                                 h3("What you can avoid"),htmlOutput("avoid"),tags$style("#avoid {font-size:16px;}"),
                                                 h3("No suggestion above? Do not worry!"),htmlOutput("donotworry"),tags$style("#donotworry {font-size:16px;}")
                                                 
                                                 ),
                                        
                                        tabPanel("Review Attitude Suggestion",
                                                 h3("What is it?"),textOutput("ReviewSuggestionHelp"),tags$style("#ReviewSuggestionHelp {font-size:16px;}")
                                                
                                                 ),
                                        
                                        tabPanel("Introduction and Acknowledgements",
                                                 h3("Who are we?"),htmlOutput("whoarewe"),tags$style("#whoarewe {font-size:16px;}"),
                                                 )
                                      )
                                      
                                      ))
))

server<-shinyServer(function(input, output) {
  
  #Remember in our code, use name+address can decide the unique business, just like the business_id.
  
  #There is no noun value in name, but there is noun value in address. 
  
  
  
  output$your_business_name<-renderUI({
    selectInput("name","Choose Your Business Name:",sort(Suggestion[which(Suggestion[,"city"]==input$city),"name"]))
    })
  
  output$your_business_address<-renderUI({
    selectInput("address","Choose Your Business Address:",sort(Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name),"address"]))
  })
  
  output$BasicSuggestionHelp <- renderUI({
      HTML(paste("Are your pizza business in Pittsburgh, Cleveland, Madison and Urbana-Champaign? Can you see yourselves on Yelp? If yes. Congratulation! Just try our website find yourselves and get the suggestion. <br/>
                 <br/>
                 This page you will see your name, address, location on map, your business rating and average review star rating on Yelp. You can also know your total number of review on Yelp.
                 "))
  })
  
  
  output$your_name <- renderUI({
    HTML(paste("<br/>",input$name,"<br/>"))
  })
  
  output$your_address <- renderUI({
    HTML(paste("<br/>",input$address," , ",input$city,"<br/>",
    '<br/>'           
               ))
  })
  
  output$stars <- renderUI({
    business_stars=Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"stars"]
    HTML(paste('<br/>',business_stars," of 5.","<br/>",'<br/>',"This is your business stars, you can see your business stars position (green line) in the following plots, which can show your overall rating in Yelp, turn to Business Suggestion to see how to increase your business stars.",'<br/>'))
    
  })
  
  output$Review_Num <- renderUI({
    num=Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"Review_Num"]
    if(isTruthy(num)==TRUE){
      if(num<30){
        HTML(paste("<br/>",num,"<br/>","Your review num is too small in our data set, it is difficult to give suggestion for this level of review num, try make your busienss popular!"))
      }
      else{
        HTML(paste("<br/>",num,"<br/>"))
      }
    }
    
  })
  
  output$Average_Review_Star_Rating <- renderUI({
    
    HTML(paste('<br/>',Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"Average_Review_Star_Rating"]," of 5.","<br/>",'<br/>',"This is your average review star rating, you can see your position (green line) in the following plots, which can show your average level of review rating in Yelp, turn to Menu Suggestion and Review Attitude Suggestion to see how to increase your review stars.",'<br/>'))
    
    
  })
  
  output$starsPlot <- renderPlot({
    business_stars=Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"stars"]
    ggplot(Suggestion, aes(x = stars)) +
      geom_histogram(aes(fill = ..count..),binwidth = 0.5)+
      scale_y_continuous(name = "Count")+
      ggtitle("Your position (green line) in business star rating") +
      scale_fill_gradient("Count", low = "blue", high = "red")+
      theme(plot.title = element_text(family="Tahoma"),
            text = element_text(family = "Tahoma"),
            axis.title = element_text(size = 16),
            legend.text = element_text(size = 16),
            legend.title=element_text(face = "bold", size = 9),
            aspect.ratio = 1)+
      geom_vline(xintercept = business_stars, size = 1, colour = "#00FC2A")
      
  })
  
  output$Average_Review_Star_RatingPlot <- renderPlot({
    Average_Review_Star_Rating=Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"Average_Review_Star_Rating"]
    ggplot(Suggestion, aes(x = Average_Review_Star_Rating)) +
      geom_histogram(aes(fill = ..count..),binwidth = 0.5)+
      scale_y_continuous(name = "Count")+
      ggtitle("Your position (green line) in average review star rating") +
      scale_fill_gradient("Count", low = "blue", high = "red")+
      theme(plot.title = element_text(family="Tahoma"),
            text = element_text(family = "Tahoma"),
            axis.title = element_text(size = 16),
            legend.text = element_text(size = 16),
            legend.title=element_text(face = "bold", size = 9),
            aspect.ratio = 1)+
      geom_vline(xintercept = Average_Review_Star_Rating, size = 1, colour = "#00FC2A")
    
  })
  
  output$positionPlot <- renderLeaflet({
   
    longitude=Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"longitude"]
    latitude=Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"latitude"]
    leaflet() %>%
      addTiles() %>%  # Add default OpenStreetMap map tiles
      addMarkers(lng=longitude, lat=latitude, popup="Your location on map")
 
  })
  
  
  output$Alcohol <- renderText({
    value=Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"Alcohol"]
    if (value==1) {
      "You offer alcohol, the mean business star rating of business offer alcohol is higher than that without. Just keep it and make it better!"
    } else {
      "You do not offer alcohol or has no record in data, the mean business star rating of business offer alcohol is 0.16 stars higher than that without. Try offer alcohol for your customers"
    }
  })
  output$BikeParking <- renderText({
    value=Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"BikeParking"]
    if (value==1) {
      "You offer park for bike, the mean business star rating of business offer park for bike is higher than that without. Just keep it and make it better!"
    } else {
      "You do not offer park for bike or has no record in data, the mean business star rating of business offer park for bike is 0.19 higher than that without. Try offer park for bike"
    }
  })
  output$GoodForKids <- renderText({
    value=Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"GoodForKids"]
    if (value==1) {
      "You business is good for kids, the mean business star rating of business good for kids is higher than that is not. Just keep toy and requirement for kids!"
    } else {
      "You business is not good for kids or has no record in data, the mean business star rating of business good for kids is 0.234 higher than that is not. Try prepare something like child seats, toys, or pizza for children if possible."
    }
  })
  output$NoiseLevel <- renderText({
    value=Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"NoiseLevel"]
    if (value==1) {
      "You business is not noisy, the mean business star rating of business which not noisy is higher than that noisy. Just keep your business quiet!"
    } else {
      "You business is too noisy or has no record in data, the mean business star rating of business which not noisy is 0.28 higher than that noisy. Try let your business quiet!"
    }
  })
  output$RestaurantsGoodForGroups <- renderText({
    value=Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"RestaurantsGoodForGroups"]
    if (value==1) {
      "You business is good for groups, the mean business star rating of business good for groups is higher than that is not. Just keep your requirement for groups!"
    } else {
      "You business is not good for groups or has no record in data, the mean business star rating of business good for groups is 0.22 higher than that is not. Try offer requirement such as big tables for groups!"
    }
  })
  output$RestaurantsReservations <- renderText({
    value=Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"RestaurantsReservations"]
    if (value==1) {
      "You business offer reservation, the mean business star rating of business offer reservation is higher than that without. Just keep it and make it better!"
    } else {
      "You business do not offer reservation or has no record in data, the mean business star rating of business offer reservation is 0.21 higher than that without. Try offer reservation for your customers"
    }
  })
  output$WiFi <- renderText({
    value=Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"WiFi"]
    if (value==1) {
      "You business offer free WiFi, the mean business star rating of business offer free WiFi is higher than that without. Just keep it and make it faster!"
    } else {
      "You business do not offer free WiFi or has no record in data, the mean business star rating of business offer free WiFi is 0.17 higher than that without. Try offer free WiFi if possible."
    }
  })
  output$RestaurantsDelivery <- renderText({
    value=Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"RestaurantsDelivery"]
    if (value==1) {
      "You business do not offer delivery, the mean business star rating of business offer delivery is lower than that offer. If you plan to offer delivery please keep food fresh on the way!"
    } else {
      "You business offer delivery or has no record in data, the mean business star rating of business offer delivery is 0.5 lower than that do not. It is time for you to check your delivery quality!"
    }
  })
  output$BusinessParking <- renderText({
    value=Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"BusinessParking"]
    if (value==1) {
      "You business offer park for car, the mean business star rating of business offer park for car is higher than that without. Just keep it and make it better!"
    } else {
      "You business do not offer park for car or has no record in data, the mean business star rating of business offer park for car is 0.36 higher than that without. Try offer park for car!"
    }
  })
  
  output$BusinessSuggestionHelp <- renderText({
    "Here we find every factor according to all business and their business rating in Yelp data base and find all factors which has significant difference in business rating between their option in the following business category. There are many attribute in our data base but the following is highly related with business rating. Some results may surprise you, but we recommend you combine our suggestion with your reality to make plan for your future. On the other hand, if you find any mistake between the option and your reality in the following factors. Please contact Yelp or us to update your data."
  })
  
  output$MenuSuggestionHelp <- renderText({
    "Are customers bored with your menu? Do you want to offer something new to attract more customers? It's time to refer to this page to extend your menu. We find several frequent food related noun in all review and find the connection between their occurrence frequency with review star rating. Therefore something might have been on your menu. For those food noun whose occurrence may decrease review star rating, you can have deep search on your menu and find is it necessary to change or remove them. Note that the first four suggestions are not related with review attitude. Therefore in fifth suggestion we put the top and bottom welcome food according to their ratio of positive and negative review. If you cannot find the suggestion in the first fourth suggestion or want to find the popular or undesired food according to review attitude instead or star rating. Just reat it! "
  })
  
  output$ReviewSuggestionHelp <- renderText({
    "Do you want to know what how customers evaluate your food or service? Are there more positive or negative reviews on your business food or service. We develop a review attitude function which can show you the answer. In this page you can see the percentage of positive, neutral and negative reviews on some kinds of food or service. And according to the review from all business, we find the top 3 important positive and negative words according to your results and give the suggestion how to do next."
  })
  

  
  output$add <- renderUI({
    str1=paste("We found that the following food noun never exists on your review:",'<br/>')
    str2=paste(Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"Add"],'<br/>')
    str3=paste("In fact, the more frequent above food in review individually, the mean review star rating will increase. If you do not offer the food above, try add them into your menu.",'<br/>')
    if(isTruthy(Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"Add"])==TRUE){
      HTML(paste(str1, str2,str3, sep = '<br/>'))
    }else{
      HTML(paste("There is no enough review in our data set. Try make your business popular and add more review!"))
    }
  })
  
  
  output$keep <- renderUI({
    str1=paste("We found that the following food noun exists on your review:",'<br/>')
    str2=paste(Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"Keep"],'<br/>')
    str3=paste("Congratulations! The more occurrence of them in review individually, the mean review star rating will increase. Try make them better!",'<br/>')
    if(isTruthy(Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"Keep"])==TRUE){
      HTML(paste(str1, str2,str3, sep = '<br/>'))
    }else{
      HTML(paste("There is no enough review in our data set. Try make your business popular and add more review!"))
      }
  })
  
  output$fix <- renderUI({
    str1=paste("We found that the following food noun exists on your review:",'<br/>')
    str2=paste(Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"Fix"],'<br/>')
    str3=paste("Unfortunately, the more occurrence of them in review individually, the mean review star rating will decrease, this is result on all data set, but it's time for you to check them.",'<br/>')
    if(isTruthy(Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"Fix"])==TRUE){
      HTML(paste(str1, str2,str3, sep = '<br/>'))
    }else{
      HTML(paste("There is no enough review in our data set. Try make your business popular and add more review!"))
    }
  })
  
  output$avoid <- renderUI({
    str1=paste("We found that the following food noun never exists on your review:",'<br/>')
    str2=paste(Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"Avoid"],'<br/>')
    str3=paste("In fact, the more frequent above food in review individually, the mean review star rating will decrease. Think twice before you want to add them on your menu",'<br/>')
    if(isTruthy(Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"Avoid"])==TRUE){
      HTML(paste(str1, str2,str3, sep = '<br/>'))
    }else{
      HTML(paste("There is no enough review in our data set. Try make your business popular and add more review!"))
    }
  })
  
  output$donotworry<- renderUI({
    str1=paste("We found that the following food noun never exists on your review:",'<br/>')
    str2=paste(Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"Avoid"],'<br/>')
    str3=paste("In fact, the more frequent above food in review individually, the mean review star rating will decrease. Think twice before you want to add them on your menu",'<br/>')
    if(isTruthy(Suggestion[which(Suggestion[,"city"]==input$city & Suggestion[,"name"]==input$name &  Suggestion[,"address"]==input$address ),"Avoid"])==TRUE){
      HTML(paste(str1, str2,str3, sep = '<br/>'))
    }else{
      HTML(paste("There is no enough review in our data set. Try make your business popular and add more review!"))
    }
  })
  
  
  
  
  
  
  
  
  
  output$whoarewe <- renderUI({
      HTML(paste("We are groups for Yelp project of STAT 628, 2020 Fall in University of Wisconsin-Madison. If you have any suggestion, questions and need update your data base, please contact Yelp or us:",'<br/>',
                 '<br/>',
                 "Yicen Liu: liu943@wisc.edu",'<br/>',
                 '<br/>',
                 "Hua Tong: htong24@wisc.edu",'<br/>',
                 '<br/>',
                 "Enze Wang: ewang36@wisc.edu",'<br/>',
                 '<br/>',
                 "The data set given by our professor contains review before 2020 has many business in Pittsburgh, Cleveland, Madison and Urbana-Champaign. Our groups aim at pizza business, we study more than 60000 reviews and 1500 businesses. We give suggestion to you on three aspects.",'<br/>',
                 '<br/>',
                 "1. Which factors including offering alcohol or not, offering free WiFi or not are highly related to your business rating. What can you do to improve.",
                 '<br/>',
                 "2. What the connection between review star rating with the occurrence of food in review? By adding or fixing what food can increase the mean of review star rating based on your menu now?",
                 '<br/>',
                 "3. Among all of your review, which food or service are customers mainly complaint or praise? How they mention in review and what can you do?",'<br/>',
                 '<br/>',
                 "Our main method is ANOVA, T Test and Regression, if you want know more about the process, welcome to our GitHub: https://github.com/sai-liu/628Yelp.",'<br/>',
                 '<br/>',
                 "This app is mainly developed and maintained by Enze Wang and fixed by Hua Tong and Yicen Liu. Thanks to our professor, TA and group members.", '<br/>',
                 '<br/>'
      ))
  })
  
})
shinyApp(ui = ui, server = server)

