*** Settings ***
Library           Selenium2Library
Library           String

*** Variables ***
${search_button}    submit
${search_results}    id=search-results-table
${show_all}       id=show-all-search-results
${end_of_list}    css=div.info-text.end-of-list-text
${InfoRibbon}     id=sticky
${INV_RefNoValue}    css=td.value.wrap-word
${waiting_for_results}    css=div.preloader.hidden    # xpath=//html/body/div[1]/div[3]/div/div[3]/div
${sign_in_button}    id=ctl00_ContentPlaceHolder1_SubmitButton
${client_selection_button}    id=selected-client
${client_selection_list}    css=div.settings-button.expandable-client-selection
${sign_out_button}    id=logout
${sign_out_page_title}    id=ctl00_PageTitleLabel
${login_in_again_link}    id=ctl00_ContentPlaceHolder1_Label123
${CUST_cust_no_search_field}    id=CustomerNumber
${INV_doc_no_search_field}    id=DocumentNumber
${REM_rem_no_search_field}    id=DocumentNumber
${access-logo}    id=access-logo
${advanced_search_button}    css=a.advanced-search-toggle
${all_inv_types_box}    id=Type
${main_content}    css=div.main-content
${search_results_cels}    xpath=id('search-results-table')
${info_text}      css=div.info-text
${REM_rem_no}     css=td.value.wrap-word    # xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[3]/div[2]/table/tbody/tr[1]/td[2]
${search_result_items}    css=tr.tody.#search-results-table    # xpath=//html/body/div[1]/div[3]/div/div[2]/table/tbody/tr
${websiteurl}	https://invoicetest.lindorff.fi/InvoiceWeb/200362/Home/Dashboard
${browser}	ie
${DELAY}	1

*** Test Cases ***
Load_IW_login
    Open Browser    ${websiteurl}    browser=${browser}    #load IW
    Maximize Browser window
	Set Selenium Speed    ${DELAY} 
    Input Text    name=ctl00$ContentPlaceHolder1$UsernameTextBox    jurgita.beisiniene@lindorff.com    #login
    Input Password    name=ctl00$ContentPlaceHolder1$PasswordTextBox    Lindorff123
    Click Element    ${sign_in_button}
	Wait Until Page Contains Element	id=settings-button
	Click Element    id=settings-button
	Click Element    xpath=//div[@id='settings-menu']/ul/li[1]/a
    Wait Until Page Contains    Search for Documents    15

Check_clients_list
    Click Element    ${client_selection_button}    #open clients list
    Wait Until Element Is Visible    ${client_selection_list}
    Click Element    Link=LähiTapiola    #select NAVISION client
    Comment    Wait Until Element Is Not Visible    ${client_selection_list}    15s
    Element Text should be    ${client_selection_button}    LähiTapiola
    Click Element    ${client_selection_button}    #open clients list
    Wait Until Element Is Visible    Link=Tansec Oy    #select LIS client
    Click Element    Link=Tansec Oy
    Comment    Wait Until Element Is Not Visible    ${client_selection_list}    15s
    Element Text should be    ${client_selection_button}    Tansec Oy
    Click Element    ${client_selection_button}    #open clients list
    Wait Until Element Is Visible    Link=Netett Sverige Ab    #select APTIC client
    Click Element    Link=Netett Sverige Ab
    Comment    Wait Until Element Is Not Visible    ${client_selection_list}    15s
    Element Text should be    ${client_selection_button}    Netett Sverige Ab

Open_page_return_back_NAVISION_client
    [Setup]
    Click Element    ${client_selection_button}    #open clients list
    Wait Until Element Is Visible    Link=LähiTapiola
    Click Element    Link=LähiTapiola    #select NAVISION client
    Click Link    Customers    #open customers tab
    Wait Until Page Contains Element    ${CUST_cust_no_search_field}    #customers tab should open
    Click Element    ${search_button}    #click search
    #Wait until element is visible    ${waiting_for_results}
    #Wait until element is not visible    ${waiting_for_results}
    Wait until element is visible    ${search_results}
    Click Element    xpath=//html/body/div[1]/div[3]/div/div[2]/table/tbody/tr[1]/td[1]/a    #open the first customer card
    Wait until element is visible    css=div.label    #check if customer card is opened, page should contain customer number
    Go Back
    Page Should Contain Element    ${CUST_cust_no_search_field}    #customers tab should be returned
    Page Should Not Contain Element    ${search_results}
    Go Back
    Page Should Contain    Search for Documents    #main page should be returned
    Page Should Contain    Search for Customers
    Click Link    Invoices    #open invoices tab
    Wait Until Page Contains Element    ${INV_doc_no_search_field}    #invoices tab should open
    Click Element    ${search_button}    #click search
    #Wait until element is visible    ${waiting_for_results}
    #Wait until element is not visible    ${waiting_for_results}
    Wait until element is visible    ${search_results}
    Click Element    xpath=//html/body/div[1]/div[3]/div/div[2]/table/tbody/tr[1]/td[1]/a    #open the first invoice card
    Wait until element is visible    css=td.label.no-wrap    #check if invoice card is opened, page should contain invoice number
    Go Back
    Page Should Contain Element    ${INV_doc_no_search_field}    #invoices tab should be returned
    Page Should Not Contain Element    ${search_results}
    Go Back
    Page Should Contain    Search for Documents    #main page should be returned
    Page Should Contain    Search for Customers
    Click Link    Reminders    #open reminders tab
    Wait Until Page Contains Element    ${REM_rem_no_search_field}    #reminders tab should open
    Click Element    ${search_button}    #click search
    #Wait until element is visible    ${waiting_for_results}
    #Wait until element is not visible    ${waiting_for_results}
    Wait until element is visible    ${search_results_cels}
    ${first_rem_item}    Get Table Cell    ${search_results_cels}    2    1
    Click Link    ${first_rem_item}    #open the first reminder card
    Wait until element is visible    css=td.label.no-wrap    #check if reminder card is opened, page should contain reminder number
    Element Text Should Be    css=td.label.no-wrap    Reminder number:
    Go Back
    Page Should Contain Element    ${REM_rem_no_search_field}    #reminders tab should be returned
    Page Should Not Contain Element    ${search_results_cels}
    Go Back
    Page Should Contain    Search for Documents    #main page should be returned
    Page Should Contain    Search for Customers

Get_NAVISION_client_data
    [Documentation]    1. selects Navision client;
    ...    2. selects customer number, checks if error message after search button click does not appear;
    ...    3. selects custoner name, checks if error message after search button click does not appear;
    ...    4. selects customer id, checks if error message after search button click does not appear;
    ...    5. selects invoice number, checks if error message after search button click does not appear;
    ...    6. selects reminder number, checks if error message after search button click does not appear;
    ...    7. selects invoice reference number, checks if error message after search button click does not appear;
    ...    8. returns to the main page.
    Run Keyword    Select_NAV_client    #select client
    ${CUST_CustomerNo_NAV}    Get_cust_no    Customers    1
    Set Suite Variable    ${CUST_CustomerNo_NAV}
    ${CUST_CustomerName_NAV}    Get_cust_name    Customers    2
    Set Suite Variable    ${CUST_CustomerName_NAV}
    ${CUST_CustomerID_NAV}    Get_cust_id    Customers    3
    Set Suite Variable    ${CUST_CustomerID_NAV}
    ${INV_InvoiceNO_NAV}    ${INV_CustomerNO_NAV}    ${INV_CustomerName_NAV}    Get_inv_no    Invoices    1    3
    ...    4
    Set Suite Variable    ${INV_InvoiceNO_NAV}
    ${REM_ReminderNO_NAV}    ${REM_CustomerNO_NAV}    ${REM_CustomerName_NAV}    Get_rem_no    Reminders    1    2
    ...    3
    Set Suite Variable    ${REM_ReminderNO_NAV}
    ${INV_ReferenceNo_NAV}    ${INV_InvoiceNoForRefNo_NAV}    Get_ExistingReferenceNo
    Log    ${INV_ReferenceNo_NAV}
    Set Suite Variable    ${INV_ReferenceNo_NAV}
    Click Element    ${access-logo}

Get_LIS_client_data
    Run Keyword    Select_LIS_client    #select client
    ${CUST_CustomerNo_LIS}    Get_LIS_APT_cust_no    Customers    1
    Set Suite Variable    ${CUST_CustomerNo_LIS}
    ${CUST_CustomerName_LIS}    Get_cust_name    Customers    2
    Set Suite Variable    ${CUST_CustomerName_LIS}
    Comment    ${CUST_CustomerID_LIS}    Get_cust_id    Customers    3
    Comment    Set Suite Variable    ${CUST_CustomerID_LIS}
    ${INV_InvoiceNO_LIS}    ${INV_CustomerNO_LIS}    ${INV_CustomerName_LIS}    Get_inv_no    Invoices    1    3
    ...    4
    Set Suite Variable    ${INV_InvoiceNO_LIS}
    ${REM_ReminderNO_LIS}    ${REM_CustomerNO_LIS}    ${REM_CustomerName_LIS}    Get_rem_no    Reminders    1    2
    ...    3
    Set Suite Variable    ${REM_ReminderNO_LIS}
    ${INV_ReferenceNo_LIS}    ${INV_InvoiceNoForRefNo_LIS}    Get_ExistingReferenceNo
    Log    ${INV_ReferenceNo_LIS}
    Set Suite Variable    ${INV_ReferenceNo_LIS}
    Click Element    ${access-logo}
    Wait Until Page Contains    Search for Documents
 
Logout
    Page Should Contain Element    ${sign_out_button}
    Click Element    ${sign_out_button} 
    Page Should Not Contain Element    ${sign_out_button} 

*** Keywords ***
Page_bottom
    Click Element    ${show_all}
    : FOR    ${i}    IN RANGE    999
    \    ${Present_ListBottom}=    Run Keyword And Return Status    Element Should Be Visible    ${end_of_list}
    \    Run Keyword If    ${Present_ListBottom}    Exit For Loop
    \    ...    ELSE    Execute Javascript    window.scrollTo(0, document.body.scrollHeight)
    \    Sleep    1

Page_bottom_quick
    Click Element    id=show-all-search-results
    Sleep    2
    : FOR    ${i}    IN RANGE    0    100
    \    Execute Javascript    lazyLoadResults(${i});void(0)
    \    Log To Console    ${i}
    Sleep    10
    ${tableSize}    Get Matching Xpath Count    html/body/div[1]/div[3]/div/div[2]/table/tbody/tr
    ${tableSize}    Convert To Integer    ${tableSize}
    Log To Console    >>> ${tableSize}

Get_cust_no
    [Arguments]    ${tab}    ${column1}
    Click Link    ${tab}
    Wait Until Page Contains Element    ${search_button}    10s
    Click Element    ${search_button}
    #Wait Until Element Is Visible    ${waiting_for_results}
    #Wait Until Element Is Not Visible    ${waiting_for_results}    15s
    Element Should Not Contain    ${main_content}    There is a problem in the system. Please try again later.
    Wait Until Page Contains Element    ${search_results_cels}    30s
    : FOR    ${i}    IN RANGE    20
    \    ${variable1}    Get Table Cell    ${search_results_cels}    ${i+2}    ${column1}
    \    ${variable1_length}=    Get Length    ${variable1}
    \    ${ProperValues}=    Run Keyword And Return Status    Should Be True    ${variable1_length}>9
    \    Run Keyword If    ${ProperValues}    Exit For Loop
    Run Keyword And Continue On Failure    Should Be True    ${ProperValues}
    [Return]    ${variable1}

Get_LIS_APT_cust_no
    [Arguments]    ${tab}    ${column1}
    Click Link    ${tab}
    Wait Until Page Contains Element    ${search_button}    10s
    Click Element    ${search_button}
    #Wait Until Element Is Visible    ${waiting_for_results}
    #Wait Until Element Is Not Visible    ${waiting_for_results}    15s
    Element Should Not Contain    ${main_content}    There is a problem in the system. Please try again later.
    Wait Until Page Contains Element    ${search_results_cels}    10s
    : FOR    ${i}    IN RANGE    100
    \    ${variable1}    Get Table Cell    ${search_results_cels}    ${i+2}    ${column1}
    \    ${variable1_length}=    Get Length    ${variable1}
    \    ${ProperValues}=    Run Keyword And Return Status    Should Be True    ${variable1_length}>7
    \    Run Keyword If    ${ProperValues}    Exit For Loop
    Run Keyword And Continue On Failure    Should Be True    ${ProperValues}
    [Return]    ${variable1}

Get_cust_name
    [Arguments]    ${tab}    ${column2}
    Click Link    ${tab}
    Wait Until Page Contains Element    ${search_button}    10s
    Click Element    ${search_button}
    #Wait Until Element Is Visible    ${waiting_for_results}
    #Wait Until Element Is Not Visible    ${waiting_for_results}    15s
    Element Should Not Contain    ${main_content}    There is a problem in the system. Please try again later.
    Wait Until Page Contains Element    ${search_results_cels}    10s
    : FOR    ${i}    IN RANGE    100
    \    ${variable1}    Get Table Cell    ${search_results_cels}    ${i+2}    ${column2}
    \    ${variable1_length}=    Get Length    ${variable1}
    \    ${ProperValues}=    Run Keyword And Return Status    Should Be True    ${variable1_length}>9
    \    Run Keyword If    ${ProperValues}    Exit For Loop
    Run Keyword And Continue On Failure    Should Be True    ${ProperValues}
    [Return]    ${variable1}

Get_cust_id
    [Arguments]    ${tab}    ${column3}
    Click Link    ${tab}
    Wait Until Page Contains Element    ${search_button}    10s
    Click Element    ${search_button}
    #Wait Until Element Is Visible    ${waiting_for_results}
    #Wait Until Element Is Not Visible    ${waiting_for_results}    15s
    Element Should Not Contain    ${main_content}    There is a problem in the system. Please try again later.
    Wait Until Page Contains Element    ${search_results_cels}    10s
    : FOR    ${i}    IN RANGE    100
    \    ${variable1}    Get Table Cell    ${search_results_cels}    ${i+2}    ${column3}
    \    ${variable1_length}=    Get Length    ${variable1}
    \    ${ProperValues}=    Run Keyword And Return Status    Should Be True    ${variable1_length}>9
    \    Run Keyword If    ${ProperValues}    Exit For Loop
    Run Keyword And Continue On Failure    Should Be True    ${ProperValues}
    [Return]    ${variable1}

Get_inv_no
    [Arguments]    ${tab}    ${column1}    ${column3}    ${column4}
    Click Link    ${tab}
    Wait Until Page Contains Element    ${search_button}    10s
    Click Element    ${search_button}
    #Wait Until Element Is Visible    ${waiting_for_results}
    #Wait Until Element Is Not Visible    ${waiting_for_results}    15s
    Element Should Not Contain    ${main_content}    There is a problem in the system. Please try again later.
    Wait Until Page Contains Element    ${search_results_cels}    10s
    Sleep    5s
    : FOR    ${i}    IN RANGE    100
    \    ${variable1}    Get Table Cell    ${search_results_cels}    ${i+2}    ${column1}
    \    ${variable1_length}=    Get Length    ${variable1}
    \    ${variable2}    Get Table Cell    ${search_results_cels}    ${i+2}    ${column3}
    \    ${variable2_length}=    Get Length    ${variable2}
    \    ${variable3}    Get Table Cell    ${search_results_cels}    ${i+2}    ${column4}
    \    ${variable3_length}=    Get Length    ${variable3}
    \    ${ProperValues}=    Run Keyword And Return Status    Should Be True    ${variable1_length}>5
    \    Run Keyword If    ${ProperValues}    Exit For Loop
    Run Keyword And Continue On Failure    Should Be True    ${ProperValues}
    [Return]    ${variable1}    ${variable2}    ${variable3}

Get_rem_no
    [Arguments]    ${tab}    ${column1}    ${column2}    ${column3}
    Click Link    ${tab}
    Wait Until Page Contains Element    ${search_button}    10s
    Click Element    ${search_button}
    #Wait Until Element Is Visible    ${waiting_for_results}
    #Wait Until Element Is Not Visible    ${waiting_for_results}    15s
    Element Should Not Contain    ${main_content}    There is a problem in the system. Please try again later.
    Wait Until Page Contains Element    ${search_results_cels}    10s
    Sleep    5s
    : FOR    ${i}    IN RANGE    100
    \    ${variable1}    Get Table Cell    ${search_results_cels}    ${i+2}    ${column1}
    \    ${variable1_length}=    Get Length    ${variable1}
    \    ${variable2}    Get Table Cell    ${search_results_cels}    ${i+2}    ${column2}
    \    ${variable2_length}=    Get Length    ${variable2}
    \    ${variable3}    Get Table Cell    ${search_results_cels}    ${i+2}    ${column3}
    \    ${variable3_length}=    Get Length    ${variable3}
    \    ${ProperValues}=    Run Keyword And Return Status    Should Be True    ${variable1_length}>5
    \    Run Keyword If    ${ProperValues}    Exit For Loop
    Run Keyword And Continue On Failure    Should Be True    ${ProperValues}
    [Return]    ${variable1}    ${variable2}    ${variable3}

Get_ExistingReferenceNo
    Click Link    Invoices
    Wait Until Page Contains Element    ${advanced_search_button}
    Click Element    ${advanced_search_button}
    Wait Until Page Contains Element    ${all_inv_types_box}
    Select From List By Value    ${all_inv_types_box}    Invoice
    Click Element    ${search_button}
    #Wait Until Element Is Visible    ${waiting_for_results}
    #Wait Until Element Is Not Visible    ${waiting_for_results}    15s
    Element Should Not Contain    ${main_content}    There is a problem in the system. Please try again later.
    Wait Until Page Contains Element    ${search_results_cels}    10s
    : FOR    ${i}    IN RANGE    40
    \    ${InvoiceNo_forRefNo}    Get Table Cell    ${search_results_cels}    ${i+2}    1
    \    ${InvoiceNo_length}=    Get Length    ${InvoiceNo_forRefNo}
    \    ${variable2}    Get Table Cell    ${search_results_cels}    ${i+2}    2
    \    log    ${variable2}
    \    ${ProperValues}=    Run Keyword And Return Status    Should Be True    ${InvoiceNo_length}>4 and '${variable2}'=='Invoice'
    \    Run Keyword If    ${ProperValues}    Exit For Loop
    Run Keyword And Continue On Failure    Should Be True    ${ProperValues}
    Click Link    ${InvoiceNo_forRefNo}
    #Wait Until Page Contains Element    ${InfoRibbon}
    ${ReferenceNo}=    Get Text    ${INV_RefNoValue}
    [Return]    ${ReferenceNo}    ${InvoiceNo_forRefNo}

compare_rem_no
    [Arguments]    ${REM_ReminderNo}
    ${tmp}    Get Matching Xpath Count    ${search_result_items}    #html/body/div[1]/div[3]/div/div[2]/table/tbody/tr
    ${tmp}    Convert To Integer    ${tmp}
    Log To Console    ${tmp}
    : FOR    ${i}    IN RANGE    2    ${tmp+2}
    \    ${rem_no}    Get Table Cell    xpath=html/body/div[1]/div[3]/div/div[2]/table    ${i}    1
    \    Run Keyword If    '${REM_ReminderNo}'=='${rem_no}'    Log To Console    Test failed. Reminder number ${rem_no} exist
    \    Run Keyword If    '${REM_ReminderNo}'!='${rem_no}'    Log To Console    Ok

compare_cust_no
    ${tmp}    Get Matching Xpath Count    html/body/div/div[3]/div/div[2]/table/tbody/tr
    ${tmp}    Convert To Integer    ${tmp}
    Log To Console    ${tmp}
    ${CustomerNo_part}    Get Substring    ${CUST_CustomerNo}    -3    #leaves 3 last characters
    : FOR    ${i}    IN RANGE    2    ${tmp+2}
    \    ${cust_no}    Get Table Cell    xpath=html/body/div/div[3]/div/div[2]/table    ${i}    1
    \    Should Contain    ${cust_no}    ${CustomerNo_part}

Select_NAV_client
    Click Element    ${client_selection_button}    #open clients list
    Wait until element is visible    Link=LähiTapiola
    Click Element    Link=LähiTapiola    #select client
    Wait Until Element Contains    ${client_selection_button}    LähiTapiola

Select_LIS_client
    Click Element    ${client_selection_button}    #open clients list
    Wait until element is visible    Link=Tansec Oy
    Click Element    Link=Tansec Oy    #select client
    Wait Until Element Contains    ${client_selection_button}    Tansec Oy

Select_APTIK_client
    Click Element    ${client_selection_button}    #open clients list
    Wait until element is visible    Link=Netett Sverige Ab
    Click Element    Link=Netett Sverige Ab    #select client
    Wait Until Element Contains    ${client_selection_button}    Netett Sverige Ab
