*** Settings ***
Library           Selenium2Library
Library           String

*** Variables ***
${Remindet_icon}    xpath=//html/body/div[1]/div[3]/div/div[2]/table/tbody/tr[1]/td[9]/div[1]
${Show_all_link}    xpath=//html/body/div[1]/div[3]/div/div[2]/div/a
${Search_button}    xpath=//html/body/div[1]/div[3]/div/div[1]/form/div[1]/input[8]
${Search_results}    id=search-results-table
${INV_Manage_stops_button}    xpath=//div[contains(string(), "Manage stops")]
${Manage_stops_window}    xpath=//html/body/div[3]
${INV_Set_stop_button}    xpath=//html/body/div[4]/div/div[1]/div[2]/input
${Reminder_stopped_icon}    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[2]/div[2]/div[1]/table/tbody/tr[1]/td[10]/div[1]
${IMG}            background-image
${9cell}          xpath=//html/body/div[1]/div[3]/div/div[2]/table/tbody/tr[1]/td[9]
${End_of_list}    css=.info-text.end-of-list-text
${Sort_cust_no}    xpath=//html/body/div[1]/div[3]/div/div[2]/table/thead/tr/th[1]/a
${first_cell_first_col}    xpath=//html/body/div[1]/div[3]/div/div[2]/table/tbody/tr[1]/td[1]/a
${waiting_for_results}    css=div.preloader hidden    # xpath=//html/body/div[1]/div[3]/div/div[3]/div
${access logo}    id=access-logo
${client_selection_button}    id=selected-client

*** Test Cases ***
Load_IW_login
    Open Browser    https://invoicetest.lindorff.fi/InvoiceWeb/200362/Home/Dashboard    browser=google chrome    #load IW
    Maximize Browser window
    Input Text    name=ctl00$ContentPlaceHolder1$UsernameTextBox    jurgita.beisiniene@lindorff.com    #login
    Input Password    name=ctl00$ContentPlaceHolder1$PasswordTextBox    Lindorff123
    Click Element    id=ctl00_ContentPlaceHolder1_SubmitButton
    Wait Until Page Contains    Search for Documents    15

Stop_reminder
    Wait Until Page Contains Element    id=selected-client
    Click Element    id=selected-client    #open clients list
    Wait until element is visible    Link=KSS Energia Oy
    Click Element    Link=KSS Energia Oy    #select client
    Wait Until Element Contains    id=selected-client    KSS Energia Oy
    Click Link    Invoices
    Wait Until Page Contains Element    name=submit
    Click Element    name=submit
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    20
    Wait Until Element Is Visible    ${Search_results}    #search for not remindet invoice
    ${INV_InvoiceNO}    Get_inv_no_not_remindet    Invoices    1    2    8    9
    Input text    xpath=//html/body/div[1]/div[3]/div/div[1]/form/div[1]/input[1]    ${INV_InvoiceNO}
    ${tmp}    Get Value    xpath=//html/body/div[1]/div[3]/div/div[1]/form/div[1]/input[1]
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${tmp}    ${INV_InvoiceNO}
    Click Element    name=submit
    Wait Until Element Is Visible    id=sticky
    Element Should Contain    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[2]/table/tbody/tr[1]/td[2]    ${INV_InvoiceNO}    #check if the selected invoice is opened
    Wait Until Page Contains Element    ${INV_Manage_stops_button}    #check if manage stops button exist
    Click Element    ${INV_Manage_stops_button}
    Wait Until Element Is Visible    ${Manage_stops_window}
    Click element    ${INV_Set_stop_button}
    Input Text    id=Reason    Test reason    #specify reason
    Click Element    xpath=//html/body/div[4]/div/div[1]/div[3]/form/table/tbody/tr[3]/td[2]/div/input    #confirm manage stops
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    20
    Wait Until Element Is Visible    xpath=//html/body/div[3]
    Wait Until Element Is Not Visible    xpath=//html/body/div[3]
    Click Element    ${INV_Manage_stops_button}
    Element Should Contain    xpath=//html/body/div[4]/div/div[1]/div[1]    Reminding stop (Active)    #reminding stop active message should exist
    Page Should Contain Element    xpath=//html/body/div[4]/div/div[1]/div[2]/input    #remove reminding stop button should exist
    Click Element    xpath=//html/body/div[4]/div/div[3]    #close reminding stop window
    Element Should Be Visible    xpath=//html/body/div[1]/div[3]/div/div[2]/div[2]

Sort_according_cust_number
    Click Element    xpath=//html/body/div[1]/div[1]/div[1]/div/div[1]/div[1]    #open clients list
    Wait until element is visible    Link=Netett Sverige Ab
    Click Element    Link=Netett Sverige Ab    #select client
    Click Element    xpath=//html/body/div[1]/div[2]/div/div/ul/li[1]/a    #open customers tab
    Wait Until Element Is Visible    ${Search_button}
    Click Element    ${Search_button}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    20
    Wait Until Page Contains Element    ${Search_results}    15
    ${first_cust_no}    Get Table Cell    ${Search_results}    2    1    #get the first customer number
    ${first_cust_name}    Get Table Cell    ${Search_results}    2    2    #get the first customer name
    ${first_cust_id}    Get Table Cell    ${Search_results}    2    3    #get the first customer Personal / Business ID
    ${first_cust_address}    Get Table Cell    ${Search_results}    2    4    #get the first customer Personal / Business ID
    ${first_cust_amount}    Get Table Cell    ${Search_results}    2    5    #get the first customer Personal / Business ID
    Set Suite Variable    ${first_cust_no}
    Set Suite Variable    ${first_cust_name}
    Set Suite Variable    ${first_cust_id}
    Set Suite Variable    ${first_cust_address}
    Set Suite Variable    ${first_cust_amount}
    Click Element    xpath=//html/body/div[1]/div[3]/div/div[2]/table/thead/tr/th[1]/a    #execute sort according customer number
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    20
    ${last_cust_no}    Get Table Cell    ${Search_results}    2    1    #get the last customer number
    ${last_cust_name}    Get Table Cell    ${Search_results}    2    2    #get the first customer name
    ${last_cust_id}    Get Table Cell    ${Search_results}    2    3    #get the first customer Personal / Business ID
    ${last_cust_address}    Get Table Cell    ${Search_results}    2    4    #get the first customer Personal / Business ID
    ${last_cust_amount}    Get Table Cell    ${Search_results}    2    5    #get the first customer Personal / Business ID
    Set Suite Variable    ${last_cust_no}
    Set Suite Variable    ${last_cust_name}
    Set Suite Variable    ${last_cust_id}
    Set Suite Variable    ${last_cust_address}
    Set Suite Variable    ${last_cust_amount}
    Should Be True    '${first_cust_no}'<'${last_cust_no}'
    Should Be True    '${first_cust_name}'!='${last_cust_name}'
    Should Be True    '${first_cust_id}'!='${last_cust_id}'
    Should Be True    '${first_cust_address}'!='${last_cust_address}'
    Should Be True    '${first_cust_amount}'!='${last_cust_amount}'
    Click Element    xpath=//html/body/div[1]/div[3]/div/div[2]/table/thead/tr/th[1]/a    #execute sort according customer number
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    20
    ${first_cust_no_repeat}    Get Table Cell    ${Search_results}    2    1    #get the first customer number
    ${first_cust_name_repeat}    Get Table Cell    ${Search_results}    2    2    #get the first customer name
    ${first_cust_id_repeat}    Get Table Cell    ${Search_results}    2    3    #get the first customer Personal / Business ID
    ${first_cust_address_repeat}    Get Table Cell    ${Search_results}    2    4    #get the first customer Personal / Business ID
    ${first_cust_amount_repeat}    Get Table Cell    ${Search_results}    2    5    #get the first customer Personal / Business ID
    Set Suite Variable    ${first_cust_no_repeat}
    Set Suite Variable    ${first_cust_name_repeat}
    Set Suite Variable    ${first_cust_id_repeat}
    Set Suite Variable    ${first_cust_address_repeat}
    Set Suite Variable    ${first_cust_amount_repeat}
    Should Be True    '${first_cust_no}'=='${first_cust_no_repeat}'
    Should Be True    '${first_cust_name}'=='${first_cust_name_repeat}'
    Should Be True    '${first_cust_id}'=='${first_cust_id_repeat}'
    Should Be True    '${first_cust_address}'=='${first_cust_address_repeat}'
    Should Be True    '${first_cust_amount}'=='${first_cust_amount_repeat}'

Sort_according_cust_name
    Click Element    xpath=//html/body/div[1]/div[1]/div[1]/div/div[1]/div[1]    #open clients list
    Wait until element is visible    Link=Netett Sverige Ab
    Click Element    Link=Netett Sverige Ab    #select client
    Click Element    xpath=//html/body/div[1]/div[2]/div/div/ul/li[1]/a    #open customers tab
    Wait Until Element Is Visible    ${Search_button}
    Click Element    ${Search_button}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    20
    Wait Until Page Contains Element    ${Search_results}    15
    ${first_cust_no}    Get Table Cell    ${Search_results}    2    1    #get the first customer number
    ${first_cust_name}    Get Table Cell    ${Search_results}    2    2    #get the first customer name
    ${first_cust_id}    Get Table Cell    ${Search_results}    2    3    #get the first customer Personal / Business ID
    ${first_cust_address}    Get Table Cell    ${Search_results}    2    4    #get the first customer Personal / Business ID
    ${first_cust_amount}    Get Table Cell    ${Search_results}    2    5    #get the first customer Personal / Business ID
    Set Suite Variable    ${first_cust_no}
    Set Suite Variable    ${first_cust_name}
    Set Suite Variable    ${first_cust_id}
    Set Suite Variable    ${first_cust_address}
    Set Suite Variable    ${first_cust_amount}
    Click Element    xpath=//html/body/div[1]/div[3]/div/div[2]/table/thead/tr/th[2]/a    #execute sort according customer name ascending
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    20
    ${cust_no1}    Get Table Cell    ${Search_results}    2    1    #get customer number
    ${cust_name1}    Get Table Cell    ${Search_results}    2    2    #get customer name
    ${cust_id1}    Get Table Cell    ${Search_results}    2    3    #get customer Personal / Business ID
    ${cust_address1}    Get Table Cell    ${Search_results}    2    4    #get customer Personal / Business ID
    ${cust_amount1}    Get Table Cell    ${Search_results}    2    5    #get customer Personal / Business ID
    Set Suite Variable    ${cust_no1}
    Set Suite Variable    ${cust_name1}
    Set Suite Variable    ${cust_id1}
    Set Suite Variable    ${cust_address1}
    Set Suite Variable    ${cust_amount1}
    Should Be True    '${first_cust_no}'!='${cust_no1}'
    Should Be True    '${first_cust_name}'!='${cust_name1}'
    Should Be True    '${first_cust_id}'!='${cust_id1}'
    Should Be True    '${first_cust_address}'!='${cust_address1}'
    Should Be True    '${first_cust_amount}'!='${cust_amount1}'
    Click Element    xpath=//html/body/div[1]/div[3]/div/div[2]/table/thead/tr/th[2]/a    #execute sort according customer name descending
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    20
    ${cust_no2}    Get Table Cell    ${Search_results}    2    1    #get customer number
    ${cust_name2}    Get Table Cell    ${Search_results}    2    2    #get customer name
    ${cust_id2}    Get Table Cell    ${Search_results}    2    3    #get customer Personal / Business ID
    ${cust_address2}    Get Table Cell    ${Search_results}    2    4    #get customer Personal / Business ID
    ${cust_amount2}    Get Table Cell    ${Search_results}    2    5    #get customer Personal / Business ID
    Set Suite Variable    ${cust_no2}
    Set Suite Variable    ${cust_name2}
    Set Suite Variable    ${cust_id2}
    Set Suite Variable    ${cust_address2}
    Set Suite Variable    ${cust_amount2}
    Should Be True    '${cust_no1}'!='${cust_no2}'!
    Should Be True    '${cust_name1}'!='${cust_name2}'
    Should Be True    '${cust_id1}'!='${cust_id2}'
    Should Be True    '${cust_address1}'!='${cust_address2}'
    Should Be True    '${cust_amount1}'=='${cust_amount2}'
    Click Element    xpath=//html/body/div[1]/div[3]/div/div[2]/table/thead/tr/th[2]/a    #execute sort according customer name ascending
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    20
    ${cust_no3}    Get Table Cell    ${Search_results}    2    1    #get customer number
    ${cust_name3}    Get Table Cell    ${Search_results}    2    2    #get customer name
    ${cust_id3}    Get Table Cell    ${Search_results}    2    3    #get customer Personal / Business ID
    ${cust_address3}    Get Table Cell    ${Search_results}    2    4    #get customer Personal / Business ID
    ${cust_amount3}    Get Table Cell    ${Search_results}    2    5    #get customer Personal / Business ID
    Set Suite Variable    ${cust_no3}
    Set Suite Variable    ${cust_name3}
    Set Suite Variable    ${cust_id3}
    Set Suite Variable    ${cust_address3}
    Set Suite Variable    ${cust_amount3}
    Should Be True    '${cust_no1}'=='${cust_no3}'!
    Should Be True    '${cust_name1}'=='${cust_name3}'
    Should Be True    '${cust_id1}'=='${cust_id3}'
    Should Be True    '${cust_address1}'=='${cust_address3}'
    Should Be True    '${cust_amount1}'=='${cust_amount3}'
    Click Element    html/body/div[1]/div[3]/div/div[2]/table/thead/tr/th[1]/a
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    20
    ${cust_no4}    Get Table Cell    ${Search_results}    2    1    #get customer number
    ${cust_name4}    Get Table Cell    ${Search_results}    2    2    #get customer name
    ${cust_id4}    Get Table Cell    ${Search_results}    2    3    #get customer Personal / Business ID
    ${cust_address4}    Get Table Cell    ${Search_results}    2    4    #get customer Personal / Business ID
    ${cust_amount4}    Get Table Cell    ${Search_results}    2    5    #get customer Personal / Business ID
    Set Suite Variable    ${cust_no4}
    Set Suite Variable    ${cust_name4}
    Set Suite Variable    ${cust_id4}
    Set Suite Variable    ${cust_address4}
    Set Suite Variable    ${cust_amount4}
    Should Be True    '${cust_no1}'=='${cust_no4}'!
    Should Be True    '${cust_name1}'=='${cust_name4}'
    Should Be True    '${cust_id1}'=='${cust_id4}'
    Should Be True    '${cust_address1}'=='${cust_address4}'
    Should Be True    '${cust_amount1}'=='${cust_amount4}'

Scroll_to_the_bottom
    Click Element    xpath=//html/body/div[1]/div[1]/div[1]/div/div[1]/div[1]    #open clients list
    Wait until element is visible    Link=Netett Sverige Ab
    Click Element    Link=Netett Sverige Ab    #select client
    Click Element    xpath=//html/body/div[1]/div[2]/div/div/ul/li[1]/a    #open customers tab
    Wait Until Element Is Visible    ${Search_button}
    Click Element    ${Search_button}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    20
    Wait Until Page Contains Element    ${Search_results}    15
    Click Element    ${Show_all_link}
    Wait Until Element Is Visible    ${waiting_for_results}
    Run Keyword    Page_bottom
    Element Should Be Visible    ${End_of_list}

Export_account_statement_report
    Open Browser    https://invoicetest.lindorff.fi/InvoiceWeb/200362/Home/Dashboard    browser=google chrome    #load IW
    Maximize Browser window
    Input Text    name=ctl00$ContentPlaceHolder1$UsernameTextBox    jurgita.beisiniene@lindorff.com    #login
    Input Password    name=ctl00$ContentPlaceHolder1$PasswordTextBox    Lindorff123
    Click Element    id=ctl00_ContentPlaceHolder1_SubmitButton
    Click Element    id=selected-client    #select client
    Wait Until Element Is Visible    Link=KSS Energia Oy
    Click Element    Link=KSS Energia Oy
    Wait Until Element Is Visible    xpath=//html/body/div[1]/div[2]/div/div/ul/li[1]/a
    Click Element    xpath=//html/body/div[1]/div[2]/div/div/ul/li[1]/a    #open customers tab

Customers tab elements
    Wait Until Page Contains Element    id=selected-client
    Click Element    id=selected-client    #open clients list
    Wait until element is visible    Link=KSS Energia Oy
    Click Element    Link=KSS Energia Oy    #select client
    Wait Until Element Contains    id=selected-client    KSS Energia Oy
    Click Link    Customers
    Wait Until Page Contains Element    name=submit
    Page Should Contain Element    id=selected-client
    Page Should Contain Element    id=settings-button
    Page Should Contain Element    id=logout
    Page Should Contain Element    id=access-logo
    Page Should Contain Element    id=selected-application
    Page Should Contain    Customers
    Page Should Contain    Invoices
    Page Should Contain    Reminders
    Page Should Contain Element    id=CustomerNumber
    Page Should Contain Element    id=CustomerName
    Page Should Contain Element    id=CustomerIdentifier
    Page Should Contain Element    id=DocumentNumber
    Element Should Not Be Visible    id=search-results-container
    Click element    name=submit
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    20
    Page Should Contain Element    id=search-results-container
    Page Should Contain Element    id=lindorff-logo
    Page Should Contain Element    id=customer-service-info
    Click Element    ${first_cell_first_col}
    Wait Until Element Is Visible    id=sticky
    Page Should Contain Element    css=div.edit-icon
    Click Element    css=div.edit-icon
    Page Should Contain Element    id=edit-customer-basic-information-popup-container
    Select From List By Value    id=CustomerType    1
    Input text    id=Identifier    test input identifier
    Click Element    id=IsGroupCustomer
    Input text    id=Name1    test name
    Input text    id=Name2    test name 2
    Input text    id=Address1    test adress 1
    Input text    id=Address2    test adress 2
    Input text    id=PostalCode    1234
    Input text    id=City    test city
    Select From List By Value    id=CountryCode    32    #32=Lithuania
    Select From List By Value    id=LanguageCode    6    #6=Lithuanian language
    Input Text    id=Phone1    +370123123
    Input Text    id=Email    test@test.com
    Click Button    css=.select-button.popup-action-button
    Wait Until Element Is Not Visible    id=edit-customer-basic-information-popup-container

Tabs_of_NAV_client
    Run Keyword    Select_NAV_client    #select client
    Page Should Contain    Customers
    Page Should Contain    Invoices
    Page Should Contain    Reminders
    Sleep    1s
    Click Element    xpath=//html/body/div[1]/div[2]/div/div/ul/li[1]/a    #open customers tab
    Wait Until Element Is Visible    ${Search_button}
    Click Element    ${Search_button}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}
    ${table_title_cust_tab}    Get Table Cell    ${Search_results}    1    1
    Should Be Equal    ${table_title_cust_tab}    Customer number
    ${customer_number}    Get Table Cell    ${Search_results}    2    1
    ${customer_name}    Get Table Cell    ${Search_results}    2    2
    ${id}    Get Table Cell    ${Search_results}    2    3
    ${address}    Get Table Cell    ${Search_results}    2    4
    ${open_amount}    Get Table Cell    ${Search_results}    2    5
    Click link    ${customer_number}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}
    Should Contain    xpath=//html/body/div/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[2]/div/div[1]/div[2]    ${customer_number}
    Should Contain    xpath=//html/body/div/div[3]/div/div[2]/span[2]    ${customer_number}
    Should Contain    xpath=//html/body/div/div[3]/div/div[2]/span[2]    ${customer_name}
    Should Contain    xpath=//html/body/div/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[2]/div/div[2]/div[2]    ${id}
    Should Contain    xpath=//html/body/div/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[2]/div/div[3]/div[2]    ${customer_name}
    Should Contain    xpath=//html/body/div/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[3]/div/div[1]/div[2]    ${address}
    Should Contain    xpath=//html/body/div/div[3]/div/div[2]/span[3]    ${open_amount}
    Click Element    Invoices
    Wait Until Element Is Visible    ${Search_button}
    Click Element    ${Search_button}
    Wait Until Element Is Not Visible    ${waiting_for_results}
    ${table_title_invoices_tab}    Get Table Cell    ${Search_results}    1    1
    Should Be Equal    ${table_title_invoices_tab}    Invoice number
    ${invoice_number}    Get Table Cell    ${Search_results}    2    1
    ${invoice_type}    Get Table Cell    ${Search_results}    2    2
    ${customer_number}    Get Table Cell    ${Search_results}    2    3
    ${customer_name}    Get Table Cell    ${Search_results}    2    4
    ${posting_date}    Get Table Cell    ${Search_results}    2    5
    ${due_date}    Get Table Cell    ${Search_results}    2    6
    ${amount}    Get Table Cell    ${Search_results}    2    7
    ${open}    Get Table Cell    ${Search_results}    2    8
    Click link    ${invoice_number}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[2]/table/tbody/tr[1]/td[2]    ${invoice_number}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[2]/table/tbody/tr[3]/td[2]    ${due_date}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[2]/table/tbody/tr[5]/td[2]    ${posting_date}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[5]/table/tbody/tr[1]/td[2]/a    ${customer_number}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[5]/table/tbody/tr[2]/td[2]    ${customer_name}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[2]/span[2]    ${invoice_number}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[2]/span[2]    ${invoice_type}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[2]/span[3]    ${amount}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[2]/span[4]    ${open}
    Click Element    Reminders
    Wait Until Element Is Visible    ${Search_button}
    Click Element    ${Search_button}
    Wait Until Element Is Not Visible    ${waiting_for_results}
    ${table_title_reminders_tab}    Get Table Cell    ${Search_results}    1    1
    Should Be Equal    ${table_title_reminders_tab}    Reminder
    ${reminder}    Get Table Cell    ${Search_results}    2    1
    ${customer_number}    Get Table Cell    ${Search_results}    2    2
    ${customer_name}    Get Table Cell    ${Search_results}    2    3
    ${posting_date}    Get Table Cell    ${Search_results}    2    4
    ${due_date}    Get Table Cell    ${Search_results}    2    5
    ${amount}    Get Table Cell    ${Search_results}    2    6
    ${open}    Get Table Cell    ${Search_results}    2    7
    Click link    ${reminder}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[3]/div[2]/table/tbody/tr[1]/td[2]    ${reminder}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[2]/span[1]    ${reminder}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[2]/span[1]    Reminder
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[3]/div[2]/table/tbody/tr[3]/td[2]    ${due_date}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[3]/div[2]/table/tbody/tr[4]/td[2]    ${posting_date}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[3]/div[5]/table/tbody/tr[1]/td[2]/a    ${customer_number}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[3]/div[5]/table/tbody/tr[2]/td[2]    ${customer_name}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[2]/span[2]    ${amount}
    Should Contain    xpath=//html/body/div[1]/div[3]/div/div[2]/span[3]    ${open}

*** Keywords ***
Get_inv_no_not_remindet
    [Arguments]    ${tab}    ${column1}    ${column2}    ${column8}    ${column9}
    Click Link    ${tab}
    Wait Until Page Contains Element    ${Search_button}    10s
    Click Element    ${Search_button}
    Wait Until Page Contains Element    ${Search_results}    15s
    Sleep    5s
    : FOR    ${i}    IN RANGE    20
    \    ${variable1}    Get Table Cell    ${Search_results}    ${i+2}    ${column1}
    \    ${variable1_inv_no}=    Get Length    ${variable1}
    \    ${variable2}    Get Table Cell    ${Search_results}    ${i+2}    ${column2}
    \    ${variable3}    Get Table Cell    ${Search_results}    ${i+2}    ${column8}
    \    ${variable3_number}    Get Substring    ${variable3}    \    -4
    \    ${variable3_correctno1}    Replace String    ${variable3_number}    ,    .
    \    ${variable3_correctno2}    Replace String    ${variable3_correctno1}    ${SPACE}    ${EMPTY}
    \    ${variable3_int}    Convert To Number    ${variable3_correctno2}
    \    ${variable4}    Run Keyword And Return Status    Element Should Not Be Visible    xpath=/html/body/div[1]/div[3]/div/div[2]/table/tbody/tr[${i+1}]/td[9]/div[1]
    \    ${ProperValues}=    Run Keyword And Return Status    Should Be True    '${variable1_inv_no}'>'4' and '${variable2}'=='Invoice' and '${variable3_int}'>'0.00' and '${variable4}'=='True'
    \    Log To Console    ${variable1}, ${variable2}, ${variable3}, ${variable4}
    \    Run Keyword If    ${ProperValues}    Exit For Loop
    Run Keyword And Continue On Failure    Should Be True    ${ProperValues}
    [Return]    ${variable1}

Page_bottom
    Click Element    ${Show_all_link}
    : FOR    ${i}    IN RANGE    9999
    \    ${Present_ListBottom}=    Run Keyword And Return Status    Element Should Be Visible    ${End_of_list}
    \    Run Keyword If    ${Present_ListBottom}    Exit For Loop
    \    ...    ELSE    Execute Javascript    window.scrollTo(0, document.body.scrollHeight)
    \    Wait Until Element Is Visible    ${waiting_for_results}
    \    Wait Until Element Is Not Visible    ${waiting_for_results}    20

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

Select_NAV_client
    Click Element    ${client_selection_button}    #open clients list
    Wait until element is visible    Link=KSS Energia Oy
    Click Element    Link=KSS Energia Oy    #select client
    Wait Until Element Contains    ${client_selection_button}    KSS Energia Oy
