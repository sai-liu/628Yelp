# Readme

## Introduction

**Group members:** Yicen Liu; Hua Tong; Enze Wang



Yicen Liu: liu943@wisc.edu

Hua Tong: htong24@wisc.edu

Enze Wang: ewang36@wisc.edu



This code is for Yelp project, Module3, Stat 628 , 2020 Fall, University of Wisconsin-Madison. This project want to give data-driven, actionable suggestion based on reviews and business data. 

**Shiny application:** https://ewang36.shinyapps.io/m_3_app/

**Google Address for All Our Data:** https://drive.google.com/drive/folders/16EfjTT4BNjj9D6pakG6MR0Bpt2Pj3Hfi?usp=sharing



## Contribution of Module 3

|               | Github Repository; Main Code                                 | Shiny Application                | Four-Pages Summary                                           | Narrated Presentation                                        |
| ------------- | ------------------------------------------------------------ | -------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **Yicen Liu** | Main editor the 4_Word_Importance_Regression_Tree.ipynb. Fix other code. | Fix and review the application.  | Fix other parts.                                             | Main editor of mp4 file. Speaker of data clean, business and menu suggesion part. |
| **Hua Tong**  | Main editor the 8_Analysis_Business.ipynb. Fix other code.   | Fix and review the application.  | Main editor of summary                                       | Speaker of Shiny application part.                           |
| **Enze Wang** | Main editor of 1_json_to_csv.ipynb; 2_Data_Clean.ipynb; 3_Exploratory_Data_Analysis.ipynb; 4_Word_Importance_TF_IDF.ipynb; 5_Word_Variable_Choose.ipynb; 6_Analysis_Noun_Class.ipynb; 7_1_Review_Attitude.ipynb; 7_2_Analysis_Noun_Attitude.ipynb; 9_Suggestion_Writer.ipynb. Responsible, maintain the GitHub and fix other code. | Main editor of Shiny application | Editor of review attitude, analysis part  and fix other part. | Main editor of  pptx file. Speaker of review attitude, analysis part. |



## Contents of GitHub

* code:
  * app:
    * app.R: Main code for Shiny application. Visit our Shiny application on https://ewang36.shinyapps.io/m_3_app/
    * Suggestion_Important_Negative_by_word.csv: Contains review suggestion for important negative words.
    * Suggestion_Important_Positive_by_word.csv: Contains review suggestion for important positive words.
    * Suggestion.csv: Contains menu, review and business suggestion.
    * rsconnect: Made from publishment to Shiny applicaition website.
  * 1_json_to_csv.ipynb: **Run the code from 1_ to 9_, wait the results of code before then run the following one. See below for detailed structure.**
  * 2_Data_Clean.ipynb
  * 3_Exploratory_Data_Analysis.ipynb
  * 4_Word_Importance_TF_IDF.ipynb
  * 4_Word_Importance_Regression_Tree.ipynb
  * 5_Word_Variable_Choose.ipynb
  * 6_Analysis_Noun_Class.ipynb
  * 7_1_Review_Attitude.ipynb
  * 7_2_Analysis_Noun_Attitude.ipynb
  * 8_Analysis_Business.ipynb
  * 9_Suggestion_Writer.ipynb
* figure: contains all figure from code. 
* data: **See below for detailed structure.** 
  * We keep all data below 100M in our data folder in GitHub, we save all data on https://drive.google.com/drive/folders/16EfjTT4BNjj9D6pakG6MR0Bpt2Pj3Hfi?usp=sharing 
* Module_3_Summary.pdf: Our summary file.
* Module_3_Presentation.mp4: Our presentation video.



## Code and Data Structure

| Code                                        | Input Data                                                   | Function                                                     | Output Data                                                  |
| ------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **1_json_to_csv.ipynb**                     | business_city.json; review_city.json; tip_city.json; user_city.json | Transfer .json to .csv. Put business_attribute to several columns. | business_city.csv; review_city.csv; tip_city.csv; user_city.csv |
| **2_Data_Clean.ipynb**                      | business_city.csv; review_city.csv; tip_city.csv; user_city.csv | Wash data according null value ratio, distance, find the number of different category and choose pizza category, wash every columns. Keep English review only. | pizza_business.csv; pizza_review.csv; pizza_review2.csv (handle from Yicen Liu) ; pizza_tip.csv; pizza_user.csv |
| **3_Exploratory_Data_Analysis.ipynb**       | pizza_business.csv; pizza_review.csv                         | Do exploratory data analysis on pizza reviews and business. Combine review and business data, do review split and count frequent word list.  Extract food words. | pizza_business_clean_review.csv; Food_Word_Data.csv; Word_Freq.csv |
| **4_Word_Importance_TF_IDF.ipynb**          | pizza_business_clean_review.csv; Word_Freq.csv               | Calculate word importance rank by TF-IDF, parallel with 4_Word_Importance_Regression_Tree.ipynb | Importance_word_tf_idf.csv                                   |
| **4_Word_Importance_Regression_Tree.ipynb** | pizza_review2.csv;                                           | Calculate word importance rank by linear regression and tree regression, parallel with 4_Word_Importance_TF_IDF.ipynb, export linear rank by Importance_matrix1.csv, and tree regression rank by Importance_matrix2.csv and Importance_matrix3.csv | Importance_matrix1.csv; Importance_matrix2.csv; Importance_matrix3.csv; R1.Rdata; R2.Rdata; R3.Rdata; y.Rdata |
| **5_Word_Variable_Choose.ipynb**            | Importance_word_tf_idf.csv; Importance_matrix1.csv; Importance_matrix2.csv; Importance_matrix3.csv; pizza_business_clean_review.csv; pizza_review.csv | Find all noun, food noun from tf-idf results, and important food and service words as Noun_Variables_Important.csv, build word matrix as Word_Count_Matrix.csv. Find all positive and negative words mainly from tree regression results as AD.csv. Find all positive, negative, important positive and important negative word list as Important_Negative_Word.csv, Important_Positive_Word.csv. Negative_Word.csv, Positive_Word.csv. Find negative adverb such as "never", "not" and "no" from pizza_review.csv. | Noun_Variables.csv; Noun_Variables_Important.csv; Word_Count_Matrix.csv; AD.csv;    Important_Negative_Word.csv; Important_Positive_Word.csv; Negative_Word.csv; Positive_Word.csv; |
| **6_Analysis_Noun_Class.ipynb**             | Word_Count_Matrix.csv; pizza_review.csv; Noun_Variables_Important.csv | Do linear regression and lasso regression to find the connection between occurrence of word in review with the review star rating. Write coefficient and p-value in Results_Analysis_Noun_Class.csv. | Results_Analysis_Noun_Class.csv                              |
| **7_1_Review_Attitude.ipynb**               | importance_word_tf_idf.csv; pizza_business_clean_review.csv; pizza_review.csv; Positive_Word.csv; Negative_Word.csv; Noun_Variables_Important.csv | Build review attitude judge function, split review again and combine review according to target words. Build review attitude matrix with target words and target reviews as Word_Review_Matrix.csv. | Split_Review.csv; Word_Review_Matrix.csv                     |
| **7_2_Analysis_Noun_Attitude.ipynb**        | Word_Review_Matrix.csv; pizza_review.csv; Noun_Variables_Important.csv; | Do ANOVA and T test to find significant words whose difference between star rating from positive reviews and negative reviews is significant. Export as Results_Analysis_Noun_Attitude.csv. | Results_Analysis_Noun_Attitude.csv                           |
| **8_Analysis_Business.ipynb**               | pizza_business.csv                                           | Do ANOVA and T test to find significant business attributes whose difference between business rating is sifnificant. | Suggestion.csv                                               |
| **9_Suggestion_Writer.ipynb**               | Results_Analysis_Noun_Class.csv; Results_Analysis_Noun_Attitude.csv; pizza_review.csv; pizza_business.csv; pizza_business_clean_review.csv; Word_Review_Matrix.csv; Positive_Word.csv; Negative_Word.csv; Important_Positive_Word.csv; Important_Negative_Word.csv | Write the analysis results before as prepared data for Shiny application. Including fit business and menu suggestion with their individual reality as Suggestion.csv. Count top3 positive, negative, important positive and important negative words as Suggestion_Important_Negative_by_word.csv; Suggestion_Important_Positive_by_word.csv; Suggestion_Negative_by_word.csv; Suggestion_Positive_by_word.csv and Suggestion_Positive_Negative_Food_Ratio.csv | Suggestion.csv; Suggestion_Important_Negative_by_word.csv; Suggestion_Important_Positive_by_word.csv; Suggestion_Negative_by_word.csv; Suggestion_Positive_by_word.csv; Suggestion_Positive_Negative_Food_Ratio.csv |

