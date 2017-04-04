*** Settings ***
Documentation     A test suite For Simple Robot test
...
...               This test is as simple as possible for RobotFramework testing purposes when we can make sure the Robot is working.
...               To run perform robot success.robot from CMD
Library           Selenium2Library

*** Test Cases ***
Perform Simple Search
    Open Browser And Website 
    Do Search
   	#[Teardown]    Close Browser
 

*** Keywords ***
Open Browser And Website
    Open Browser    ${WEBSITE}    ${BROWSER}
    Set Window Size     1200     800
    Set Window Position     730     200
        #Maximize Browser Window
    Set Selenium Speed    ${DELAY} 

Do Search
    Input Text    q    ${SEARCH_KEYWORD} 
    Click Element   btnK 


*** Variables ***
${WEBSITE}         https://www.google.com/
${BROWSER}        Firefox
${DELAY}          1
${MAX_TIMEOUT}     90
${SHORT_TIMEOUT}     10
${SEARCH_KEYWORD}   Lindorff

