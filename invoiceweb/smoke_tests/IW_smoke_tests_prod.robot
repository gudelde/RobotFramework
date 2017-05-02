*** Settings ***
Documentation     execute all tests accorging the numeration
Library           Selenium2Library
Library           String

*** Variables ***
${sign_in_button}    id=ctl00_ContentPlaceHolder1_SubmitButton
${client_selection_button}    id=selected-client
${search_button}    name=submit
${waiting_for_results}    css=div.preloader.hidden
${main-content}    css=div.main-content
${search_results}    id=search-results-table
${search results cels}    xpath=id('search-results-table')

*** Test Cases ***
1_Load_IW_login
    [Documentation]    1. load IW 2. login and expect that sign out button is visible and no error message appears
    Open Browser    https://invoiceweb.lindorff.com/200368/Home/Dashboard    browser=ie    #load IW
    Maximize Browser window
    Input Text    name=ctl00$ContentPlaceHolder1$UsernameTextBox    jurgita.beisiniene@lindorff.com    #login
    Input Password    name=ctl00$ContentPlaceHolder1$PasswordTextBox    Lindorff123
    Click Element    ${sign_in_button}
    Wait Until Element Is Not Visible    id=ctl00_ContentPlaceHolder1_UsernameTextBox
    Wait Until Element Is Visible    id=logout    15
    Should Not Contain    css=div.root-container    There is a problem in the system. Please try again later.

2_Select_EN_ language
    [Documentation]    1. check if settings menu button is visible, expected result - settings menu button is visible 2. open settings menu and select English language, expected result - settings menu button name is in English language
    Wait Until Page Contains Element	id=settings-button
	Wait Until Element Is Visible    id=settings-menu
	Click Element    id=settings-button
	Click Element    xpath=//div[@id='settings-menu']/ul/li[1]/a
    Wait Until Page Contains    Search for Documents    15

3_Select_NAV_client_check_it_is_selected
    [Documentation]    1. open clients list 2. select Navision client, expected result: button name=selected client
    Click Element    ${client_selection_button}    #open clients list
    Wait until element is visible    Link=KSS Energia Oy
    Click Element    Link=KSS Energia Oy    #select client
    Wait Until Element Contains    ${client_selection_button}    KSS Energia Oy

4_Search_for_doc_and_cust_boxes_visible
    [Documentation]    1. check that page does not contain error message "There is a problem in the system. Please try again later." , expected result: page does not contain error message 2. check if search for documents and search for customers boxes exist, expected result: main page contains \ search for documents and search for customers boxes
    Element Should Not Contain    css=div.page-content    There is a problem in the system. Please try again later.
    Element Should Be Visible    css=div.page-content-left.dashboard-content-left
    Element Should Contain    css=div.page-content-left.dashboard-content-left    Search for Documents
    Element Should Contain    css=div.page-content-left.dashboard-content-left    Search for Customers

5_perform_customers_search_returns_20items
    [Documentation]    1. open customers tab, check if error message does not exist; expected result - customers tab main containt does not have error message 2. click search button and check search result; expected result - search returned 20 items
    Click Link    Customers
    Wait Until Element Is Visible    ${search_button}    10
    Element Should Not Contain    ${main-content}    There is a problem in the system. Please try again later.
    Click Element    ${search_button}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    10
    Page Should Contain Element    ${search_results}
    Element Should Not Contain    ${main-content}    There is a problem in the system. Please try again later.
    ${search_items_count}    Get Matching Xpath Count    //html/body/div[1]/div[3]/div/div[2]/table/tbody/tr
    ${search_items}    Convert To Integer    ${search_items_count}
    Should Be True    '${search_items}'=='20'

6_open_cust_card_check_boxes_exist
    [Documentation]    1. open the first customer card and check available boxes; expected result - header box exist, customer basic information box exist, documents box exist, comments box exist
    ${first_cust_no}    Get Table Cell    ${search results cels}    21    1
    Click Link    ${first_cust_no}
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${waiting_for_results}
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${waiting_for_results}    10
    Page Should Contain Element    id=sticky
    Page Should Contain Element    css=div.content-box.shadow
    ${number_of_boxes}    Get Matching Xpath Count    xpath=//html/body/div/div[3]/div/div[3]/div[1]/div
    Should Be Equal    ${number_of_boxes}    2
    Page Should Contain Element    css=div.page-content-right.shadow
    Page should contain    BASIC INFORMATION
    Page should contain    DOCUMENTS
    Page should contain    COMMENTS

7_perform_invoices_search_returns_20items
    [Documentation]    1. open invoices tab, check if error message does not exist; expected result - invoices tab main containt does not have error message 2. click search button and check search result; expected result - search returned 20 items
    Click Link    Invoices
    Wait Until Element Is Visible    ${search_button}    10
    Element Should Not Contain    ${main-content}    There is a problem in the system. Please try again later.
    Click Element    ${search_button}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    10
    Page Should Contain Element    ${search_results}
    Element Should Not Contain    ${main-content}    There is a problem in the system. Please try again later.
    ${search_items_count}    Get Matching Xpath Count    //html/body/div[1]/div[3]/div/div[2]/table/tbody/tr
    ${search_items}    Convert To Integer    ${search_items_count}
    Should Be True    '${search_items}'=='20'

8_open_inv_card_check_boxes_exist
    [Documentation]    1. open the first invoice card and check available boxes; expected result - header box exist, invoice basic information box exist, settlements box exist, comments box exist
    ${first_inv_no}    Get Table Cell    ${search results cels}    21    1
    Click Link    ${first_inv_no}
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${waiting_for_results}
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${waiting_for_results}    10
    Page Should Contain Element    id=sticky
    Page Should Contain Element    css=div.content-box.shadow
    ${number_of_boxes}    Get Matching Xpath Count    xpath=//html/body/div/div[3]/div/div[3]/div[1]/div
    Should Be Equal    ${number_of_boxes}    2
    Page Should Contain Element    css=div.page-content-right.shadow
    Page should contain    BASIC INFORMATION
    Page should contain    SETTLEMENTS
    Page should contain    COMMENTS

9_Select_NAV_client_contracts_enabled
    [Documentation]    1. open clients list 2. select Navision client, where contract invoicing is enabled; expected result: button name=selected client and page conatains "Contracts"
    Click Element    ${client_selection_button}    #open clients list
    Wait until element is visible    Link=Otavamedia Oy
    Click Element    Link=Otavamedia Oy    #select client
    Wait Until Element Contains    ${client_selection_button}    Otavamedia Oy
    Page Should Contain    Contracts

10_perform_contracts_search_returns_20items
    [Documentation]    1. open contracts tab, check if error message does not exist; expected result - contracts tab main containt does not have error message 2. click search button and check search result; expected result - search returned 20 items
    Click Link    Contracts
    Wait Until Element Is Visible    ${search_button}    10
    Element Should Not Contain    ${main-content}    There is a problem in the system. Please try again later.
    Click Element    ${search_button}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    10
    Page Should Contain Element    ${search_results}
    Element Should Not Contain    ${main-content}    There is a problem in the system. Please try again later.
    ${search_items_count}    Get Matching Xpath Count    //html/body/div[1]/div[3]/div/div[2]/table/tbody/tr
    ${search_items}    Convert To Integer    ${search_items_count}
    Should Be True    '${search_items}'=='20'

11_open_contr_card_check_boxes_exist
    [Documentation]    1. open the first contract card and check available boxes; expected result - header box exist, contract basic information box exist, invoice box exist, comments box exist
    ${first_contr_no}    Get Table Cell    ${search results cels}    21    1
    Click Link    ${first_contr_no}
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${waiting_for_results}
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${waiting_for_results}    10
    Page Should Contain Element    id=sticky
    Page Should Contain Element    css=div.content-box.shadow
    ${number_of_boxes}    Get Matching Xpath Count    xpath=//html/body/div/div[3]/div/div[3]/div[1]/div
    Should Be Equal    ${number_of_boxes}    2
    Page Should Contain Element    css=div.page-content-right.shadow
    Page should contain    BASIC INFORMATION
    Page should contain    INVOICE LIST
    Page should contain    COMMENTS

12_perform_reminders_search_returns_20items
    [Documentation]    1. open reminders tab, check if error message does not exist; expected result - reminders tab main containt does not have error message 2. click search button and check search result; expected result - search returned 20 items
    Click Link    Reminders
    Wait Until Element Is Visible    ${search_button}    10
    Element Should Not Contain    ${main-content}    There is a problem in the system. Please try again later.
    Click Element    ${search_button}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    10
    Page Should Contain Element    ${search_results}
    Element Should Not Contain    ${main-content}    There is a problem in the system. Please try again later.
    ${search_items_count}    Get Matching Xpath Count    //html/body/div[1]/div[3]/div/div[2]/table/tbody/tr
    ${search_items}    Convert To Integer    ${search_items_count}
    Should Be True    '${search_items}'=='20'

13_open_rem_card_check_boxes_exist
    [Documentation]    1. open the first reminder card and check available boxes; expected result - header box exist, reminder basic information box exist, settlements box exist, comments box exist
    ${first_rem_no}    Get Table Cell    ${search results cels}    21    1
    Click Link    ${first_rem_no}
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${waiting_for_results}
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${waiting_for_results}    10
    Page Should Contain Element    id=sticky
    Page Should Contain Element    css=div.content-box.shadow
    ${number_of_boxes}    Get Matching Xpath Count    xpath=//html/body/div/div[3]/div/div[3]/div[1]/div
    Should Be Equal    ${number_of_boxes}    2
    Page Should Contain Element    css=div.page-content-right.shadow
    Page should contain    BASIC INFORMATION
    Page should contain    SETTLEMENTS
    Page should contain    COMMENTS
