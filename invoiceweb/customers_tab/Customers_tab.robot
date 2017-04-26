*** Settings ***
Library           Selenium2Library
Library           String

*** Variables ***
${sign_in_button}    id=ctl00_ContentPlaceHolder1_SubmitButton
${client_selection_button}    id=selected-client
${search_button}    name=submit
${waiting_for_results}    css=div.preloader.hidden
${search_results}    id=search-results-table
${info_text}      css=div.info-text
${search results items}    css=tr.tody.#search-results-table    # xpath=//html/body/div[1]/div[3]/div/div[2]/table/tbody/tr
${show_all}       id=show-all-search-results
${access logo}    id=access-logo
${search results cels}    xpath=id('search-results-table')
${InfoRibbon}     id=sticky
${amounts}        css=span.balance
${main-content}    css=div.main-content
${access-logo}    id=access-logo
${documents_table_cels}    xpath=//html/body/div/div[3]/div/div[3]/div[1]/div[2]/div[2]/div[1]/table/tbody
${documents_area_customer_card}    id=results-div
${all_posted_doc_button}    css=label.radiobutton-label
${documents_table_customer_card}    id=results-table

*** Test Cases ***
Load_IW_login
    Open Browser    https://invoicetest.lindorff.fi/InvoiceWeb/200362/Home/Dashboard    browser=ie    #load IW
    Maximize Browser window
    Input Text    name=ctl00$ContentPlaceHolder1$UsernameTextBox    jurgita.beisiniene@lindorff.com    #login
    Input Password    name=ctl00$ContentPlaceHolder1$PasswordTextBox    Lindorff123
    Click Element    ${sign_in_button}
    Wait Until Page Contains    Search for Documents    15

Customers_tab_returns_some_items
    [Documentation]    check if customers tab returns some items and "There is a problem in the system. Please try again later." is not shown
    Run Keyword    Select_NAV_client    #select client
    Click Link    Customers
    Wait Until Element Is Visible    ${search_button}    15
    Element Should Not Be Visible    ${waiting_for_results}
    Page Should Not Contain Element    ${search_results}
    Element Should Not Contain    ${main-content}    There is a problem in the system. Please try again later.
    Click Element    ${search_button}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    15s
    Page Should Contain Element    ${search_results}
    Element Should Not Contain    ${main-content}    There is a problem in the system. Please try again later.
    ${search_items}    Get Matching Xpath Count    //html/body/div[1]/div[3]/div/div[2]/table/tbody/tr
    ${search_items_no}    Convert To Number    ${search_items}
    Should Be True    '${search_items_no}'>'0'
    Run Keyword If    '${search_items_no}'=='20'    Page Should Contain Element    ${show_all}
    Run Keyword    Select_LIS_client    #select client
    Click Link    Customers
    Wait Until Element Is Visible    ${search_button}    15
    Element Should Not Be Visible    ${waiting_for_results}
    Page Should Not Contain Element    ${search_results}
    Element Should Not Contain    ${main-content}    There is a problem in the system. Please try again later.
    Click Element    ${search_button}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    15s
    Page Should Contain Element    ${search_results}
    Element Should Not Contain    ${main-content}    There is a problem in the system. Please try again later.
    ${search_items}    Get Matching Xpath Count    //html/body/div[1]/div[3]/div/div[2]/table/tbody/tr
    ${search_items_no}    Convert To Number    ${search_items}
    Should Be True    '${search_items_no}'>'0'
    Run Keyword If    '${search_items_no}'=='20'    Page Should Contain Element    ${show_all}
    Run Keyword    Select_APTIK_client    #select client
    Click Link    Customers
    Wait Until Element Is Visible    ${search_button}    15
    Element Should Not Be Visible    ${waiting_for_results}
    Page Should Not Contain Element    ${search_results}
    Element Should Not Contain    ${main-content}    There is a problem in the system. Please try again later.
    Click Element    ${search_button}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    15s
    Page Should Contain Element    ${search_results}
    Element Should Not Contain    ${main-content}    There is a problem in the system. Please try again later.
    ${search_items}    Get Matching Xpath Count    //html/body/div[1]/div[3]/div/div[2]/table/tbody/tr
    ${search_items_no}    Convert To Number    ${search_items}
    Should Be True    '${search_items_no}'>'0'
    Run Keyword If    '${search_items_no}'=='20'    Page Should Contain Element    ${show_all}
    Click Element    ${access-logo}
    Wait Until Page Contains    Search for Documents    15

Ckeck_documents_list_NAV_client
    Click Link    Customers
    Run Keyword    Select_NAV_client    #select client
    Click Link    Customers
    Wait Until Element Is Visible    ${search_button}
    Click Element    ${search_button}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    15s
    ${first_cust_no}    Get Table Cell    ${search results cels}    21    1
    Click Link    ${first_cust_no}
    Wait Until Page Contains Element    ${InfoRibbon}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    15s
    Page Should Contain Element    id=results-table
    ${status_payment}    Run Keyword And Return Status    Element Should Contain    ${documents_table_customer_card}    Payment
    ${status_invoice}    Run Keyword And Return Status    Element Should Contain    ${documents_table_customer_card}    Invoice
    ${status_CR_invoice}    Run Keyword And Return Status    Element Should Contain    ${documents_table_customer_card}    Credit invoice
    ${status_reminder}    Run Keyword And Return Status    Element Should Contain    ${documents_table_customer_card}    Reminder
    ${status_other}    Run Keyword And Return Status    Element Should Contain    ${documents_table_customer_card}    Other
    Log To Console    ${status_payment}
    Log To Console    ${status_invoice}
    Log To Console    ${status_CR_invoice}
    Log To Console    ${status_reminder}
    Log To Console    ${status_other}
    Should Be True    ${status_payment} or ${status_invoice} or ${status_CR_invoice} or ${status_reminder} or ${status_other}
    Element Should Not Contain    ${documents_area_customer_card}    There is a problem in the system. Please try again later.
    Click Element    ${all_posted_doc_button}
    Wait Until Element Is Not Visible    ${waiting_for_results}    15
    Element Should Not Contain    ${documents_area_customer_card}    There is a problem in the system. Please try again later.
    Click Element    ${access-logo}
    Wait Until Page Contains    Search for Documents    15

Boxes_works_NAV_client
    [Documentation]    check boxes in customer card, basic information area
    Click Link    Customers
    Run Keyword    Select_NAV_client    #select client
    Click Link    Customers
    Wait Until Element Is Visible    ${search_button}
    Click Element    ${search_button}
    Wait Until Element Is Visible    ${waiting_for_results}
    Wait Until Element Is Not Visible    ${waiting_for_results}    15s
    ${first_cust_no}    Get Table Cell    ${search results cels}    2    1
    Click Link    ${first_cust_no}
    Wait Until Page Contains Element    ${InfoRibbon}
    ${boxes}    Run Keyword    Get Text    css=div.additional-information-container
    Should Contain    ${boxes}    Contracts
    Should Contain    ${boxes}    Balance summary
    Should Contain    ${boxes}    Electronic invoicing contracts
    Click Element    css=div.additional-information-header
    Element Should Be Visible    css=div.additional-information-content
    Element Should Not Contain    css=div.additional-information-container    There is a problem in the system. Please try again later.
    Click Element    css=div.additional-information-header.open-header
    Sleep    1s
    Element Should Not Be Visible    css=div.additional-information-content
    Click Element    xpath=//html/body/div/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[2]/div[1]
    Element Should Not Contain    xpath=//html/body/div/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[2]/div[2]    There is a problem in the system. Please try again later.
    Click Element    xpath=//html/body/div/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[2]/div[1]
    Click Element    xpath=//html/body/div/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[3]/div[1]
    Element Should Not Contain    xpath=//html/body/div/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[3]/div[2]/div[1]    There is a problem in the system. Please try again later.
    Click Element    xpath=//html/body/div/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[3]/div[1]
    Click Element    ${access-logo}
    Wait Until Page Contains    Search for Documents    15

Amounts_NAV_client
    [Documentation]    check open and unpaid amounts:
    ...
    ...    1. select client (step-1)
    ...    2. open customer card which has some documnts, does not have payments, credit invoices (step-3)
    ...    3. count documents in documents list (step-22)
    ...    4. get unpaid amounts from documents list (step-26)
    ...    5. calculate sum of unpaid amounts (step-31)
    ...    6. get open amounts from documents list (step-34)
    ...    7. calculate sum of open amounts (step-39)
    ...    8. get open amount from header (step-41)
    ...    9. get unpaid amount from header (step-48)
    ...    10. open balance summary box (step-55)
    ...    11. calculate open amount (step-58)
    ...    12. calculate unpaid amount (step-59)
    ...    13. check if open amount is correct/conforms (step-60)
    ...    14. check if unpaid amount is correct/conforms (step-61)
    Run Keyword    Select_NAV_client    #select client
    Click Link    Customers
    : FOR    ${i}    IN RANGE    20    #open customer card which has some documnts, does not have payments, credit invoices
    \    Wait Until Element Is Visible    ${search_button}    15
    \    Click Element    ${search_button}
    \    Click Element    ${search_button}
    \    Run Keyword And Continue On Failure    Wait Until Element Is Visible    ${waiting_for_results}
    \    Wait Until Element Is Not Visible    ${waiting_for_results}    15s
    \    ${cust_number}    Get Table Cell    ${search results cels}    ${i+2}    1
    \    Click link    ${cust_number}
    \    Wait Until Element Is Visible    ${waiting_for_results}
    \    Wait Until Element Is Not Visible    ${waiting_for_results}    10
    \    Wait Until Element Is Visible    ${InfoRibbon}
    \    ${result_no_doc}    Run Keyword And Return Status    Page Should Contain    No documents
    \    Log To Console    ${result_no_doc}
    \    ${result_table_payment}    Run Keyword And Return Status    Table Should Contain    xpath=//table[@id='results-table']    Payment
    \    Log To Console    ${result_table_payment}
    \    ${result_table_CRinvoice}    Run Keyword And Return Status    Table Should Contain    xpath=//table[@id='results-table']    Credit invoice
    \    Log To Console    ${result_table_CRinvoice}
    \    Run Keyword Unless    ${result_table_payment} or ${result_no_doc} or ${result_table_CRinvoice}    Exit For Loop
    Page Should Contain Element    ${amounts}
    ${documents_items}    Get Matching Xpath Count    html/body/div/div[3]/div/div[3]/div[1]/div[2]/div[2]/div[1]/table/tbody/tr    #count documents in documents list
    ${documents_items}    Convert To Integer    ${documents_items}
    Log To Console    ${documents_items}
    ${a}    Set Variable    0
    : FOR    ${i}    IN RANGE    2    ${documents_items+2}    2    #get unpaid amounts from documents list
    \    ${unpaid_n}    Get Table Cell    xpath=html/body/div/div[3]/div/div[3]/div[1]/div[2]/div[2]/div[1]/table    ${i}    10
    \    ${unpaid_0}    Get Substring    ${unpaid_n}    \    -4
    \    ${unpaid_n1}    Replace String    ${unpaid_0}    ,    .
    \    ${unpaid_n2}    Replace String    ${unpaid_n1}    ${SPACE}    ${EMPTY}
    \    ${a}    Evaluate    ${a}+${unpaid_n2}    #calculate sum of unpaid amounts
    \    Log To Console    ${a}
    ${b}    Set Variable    0
    : FOR    ${i}    IN RANGE    2    ${documents_items+2}    2    #get open amounts from documents list
    \    ${unpaid_n}    Get Table Cell    xpath=html/body/div/div[3]/div/div[3]/div[1]/div[2]/div[2]/div[1]/table    ${i}    9
    \    ${unpaid_0}    Get Substring    ${unpaid_n}    \    -4
    \    ${unpaid_n1}    Replace String    ${unpaid_0}    ,    .
    \    ${unpaid_n2}    Replace String    ${unpaid_n1}    ${SPACE}    ${EMPTY}
    \    ${b}    Evaluate    ${b}+${unpaid_n2}    #calculate sum of open amounts
    \    Log To Console    ${b}
    ${open}    Get text    xpath=//html/body/div[1]/div[3]/div/div[2]/span[3]    #get open amount from header
    Log To Console    ${open}
    ${open_just_amount}    Get Substring    ${open}    6    -4
    Log To Console    ${open_just_amount}
    ${open_just_amount_replaced1}    Replace String    ${open_just_amount}    ,    .
    ${open_just_amount_replaced}    Replace String    ${open_just_amount_replaced1}    ${SPACE}    ${EMPTY}
    Log To Console    ${open_just_amount_replaced}
    ${unpaid}    Get text    xpath=//html/body/div[1]/div[3]/div/div[2]/span[4]    #get unpaid amount from header
    Log To Console    ${unpaid}
    ${unpaid_just_amount}    Get Substring    ${unpaid}    8    -4
    Log To Console    ${unpaid_just_amount}
    ${unpaid_just_amount_replaced1}    Replace String    ${unpaid_just_amount}    ,    .
    ${unpaid_just_amount_replaced}    Replace String    ${unpaid_just_amount_replaced1}    ${SPACE}    ${EMPTY}
    Log To Console    ${unpaid_just_amount_replaced}
    Click Element    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[2]/div[1]    #open balance summary box
    Wait Until Element Is Visible    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[2]/div[2]/div[1]/table/tbody/tr[1]/td[2]
    Run Keyword    Get_balance_summary_amounts_NAV
    ${sum_open_amount}    Evaluate    ${open_invoices_amount_number}+${open_credit_invoices_amount_number}+${open_penalty_interest_number}+${open_reminder_fees_amount}-${written_off_amount_number}    #calculate open amount
    ${sum_unpaid_amount}    Evaluate    ${invoiced_amount_number}-${credited_amount_number}-${paid_amount_number}-${penalty_interest_amount_number}-${reminder_fees_amount_number}    #calculate unpaid amount
    Should Be True    '${open_just_amount_replaced}'=='${sum_open_amount}'=='${b}'    \    #check if open amount is correct
    Should Be True    '${unpaid_just_amount_replaced}'=='${sum_unpaid_amount}'=='${a}'    \    #check if unpaid amount is correct
    Click Element    ${access-logo}
    Wait Until Page Contains    Search for Documents    15

*** Keywords ***
Select_NAV_client
    Click Element    ${client_selection_button}    #open clients list
    Wait until element is visible    Link=KSS Energia Oy
    Click Element    Link=KSS Energia Oy    #select client
    Wait Until Element Contains    ${client_selection_button}    KSS Energia Oy

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

Get_balance_summary_amounts_NAV
    ${invoiced_amount1}    Get text    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[2]/div[2]/div[1]/table/tbody/tr[1]/td[2]    #get invoiced amount from balance box
    Log To Console    ${invoiced_amount1}
    ${invoiced_amount_just_amount}    Get Substring    ${invoiced_amount1}    \    -4
    Log To Console    ${invoiced_amount_just_amount}
    ${invoiced_amount_remove_space}    Replace String    ${invoiced_amount_just_amount}    ${SPACE}    ${EMPTY}
    Log To Console    ${invoiced_amount_remove_space}
    ${invoiced_amount}    Replace String    ${invoiced_amount_remove_space}    ,    .
    ${invoiced_amount_number}    Convert To Number    ${invoiced_amount}
    Log To Console    ${invoiced_amount_number}
    ${credited_amount1}    Get text    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[2]/div[2]/div[1]/table/tbody/tr[2]/td[2]    #get credited amount from balance box
    Log To Console    ${credited_amount1}
    ${credited_amount_just_amount}    Get Substring    ${credited_amount1}    \    -4
    Log To Console    ${credited_amount_just_amount}
    ${credited_amount_remove_space}    Replace String    ${credited_amount_just_amount}    ${SPACE}    ${EMPTY}
    Log To Console    ${credited_amount_remove_space}
    ${credited_amount}    Replace String    ${credited_amount_remove_space}    ,    .
    ${credited_amount_number}    Convert To Number    ${credited_amount}
    Log To Console    ${credited_amount_number}
    ${paid_amount1}    Get text    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[2]/div[2]/div[1]/table/tbody/tr[3]/td[2]    #get paid amount from balance box
    Log To Console    ${paid_amount1}
    ${paid_amount_just_amount}    Get Substring    ${paid_amount1}    \    -4
    Log To Console    ${paid_amount_just_amount}
    ${paid_amount_remove_space}    Replace String    ${paid_amount_just_amount}    ${SPACE}    ${EMPTY}
    Log To Console    ${paid_amount_remove_space}
    ${paid_amount}    Replace String    ${paid_amount_remove_space}    ,    .
    ${paid_amount_number}    Convert To Number    ${paid_amount}
    Log To Console    ${paid_amount_number}
    ${written_off_amount1}    Get text    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[2]/div[2]/div[1]/table/tbody/tr[4]/td[2]    #get written off amount from balance box
    Log To Console    ${written_off_amount1}
    ${written_off_amount_just_amount}    Get Substring    ${written_off_amount1}    \    -4
    Log To Console    ${written_off_amount_just_amount}
    ${written_off_amount_remove_space}    Replace String    ${written_off_amount_just_amount}    ${SPACE}    ${EMPTY}
    Log To Console    ${written_off_amount_remove_space}
    ${written_off_amount}    Replace String    ${written_off_amount_remove_space}    ,    .
    ${written_off_amount_number}    Convert To Number    ${written_off_amount}
    Log To Console    ${written_off_amount_number}
    ${penalty_interest_amount1}    Get text    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[2]/div[2]/div[1]/table/tbody/tr[5]/td[2]    #get penalty interest charged amount from balance box
    Log To Console    ${penalty_interest_amount1}
    ${penalty_interest_just_amount}    Get Substring    ${penalty_interest_amount1}    \    -4
    Log To Console    ${penalty_interest_just_amount}
    ${penalty_interest_remove_space}    Replace String    ${penalty_interest_just_amount}    ${SPACE}    ${EMPTY}
    Log To Console    ${penalty_interest_remove_space}
    ${penalty_interest_amount}    Replace String    ${penalty_interest_remove_space}    ,    .
    ${penalty_interest_amount_number}    Convert To Number    ${penalty_interest_amount}
    Log To Console    ${penalty_interest_amount_number}
    ${reminder_fees_amount1}    Get text    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[2]/div[2]/div[1]/table/tbody/tr[6]/td[2]    #get reminder fees charged amount from balance box
    Log To Console    ${reminder_fees_amount1}
    ${reminder_fees_just_amount}    Get Substring    ${reminder_fees_amount1}    \    -4
    Log To Console    ${reminder_fees_just_amount}
    ${reminder_fees_remove_space}    Replace String    ${reminder_fees_just_amount}    ${SPACE}    ${EMPTY}
    Log To Console    ${reminder_fees_remove_space}
    ${reminder_fees_amount}    Replace String    ${reminder_fees_remove_space}    ,    .
    ${reminder_fees_amount_number}    Convert To Number    ${reminder_fees_amount}
    Log To Console    ${reminder_fees_amount_number}
    ${open_invoices1_amount1}    Get text    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[2]/div[2]/div[2]/table/tbody/tr[1]/td[2]    #get open invoices amount from balance box
    Log To Console    ${open_invoices1_amount1}
    ${open_invoices_just_amount}    Get Substring    ${open_invoices1_amount1}    \    -4
    Log To Console    ${open_invoices_just_amount}
    ${open_invoices_remove_space}    Replace String    ${open_invoices_just_amount}    ${SPACE}    ${EMPTY}
    Log To Console    ${open_invoices_remove_space}
    ${open_invoices_amount}    Replace String    ${open_invoices_remove_space}    ,    .
    ${open_invoices_amount_number}    Convert To Number    ${open_invoices_amount}
    Log To Console    ${open_invoices_amount_number}
    ${open_credit_invoices_amount1}    Get text    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[2]/div[2]/div[2]/table/tbody/tr[2]/td[2]    #get open credit invoices amount from balance box
    Log To Console    ${open_credit_invoices_amount1}
    ${open_credit_invoices_just_amount}    Get Substring    ${open_credit_invoices_amount1}    \    -4
    Log To Console    ${open_credit_invoices_just_amount}
    ${open_credit_invoices_remove_space}    Replace String    ${open_credit_invoices_just_amount}    ${SPACE}    ${EMPTY}
    Log To Console    ${open_credit_invoices_remove_space}
    ${open_credit_invoices_amount}    Replace String    ${open_credit_invoices_remove_space}    ,    .
    ${open_credit_invoices_amount_number}    Convert To Number    ${open_credit_invoices_amount}
    Log To Console    ${open_credit_invoices_amount_number}
    ${open_penalty_interest_amount1}    Get text    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[2]/div[2]/div[2]/table/tbody/tr[3]/td[2]    #get open penalty interest amount from balance box
    Log To Console    ${open_penalty_interest_amount1}
    ${open_penalty_interest_just_amount}    Get Substring    ${open_penalty_interest_amount1}    \    -4
    Log To Console    ${open_penalty_interest_just_amount}
    ${open_penalty_interest_remove_space}    Replace String    ${open_penalty_interest_just_amount}    ${SPACE}    ${EMPTY}
    Log To Console    ${open_penalty_interest_remove_space}
    ${open_penalty_interest_amount}    Replace String    ${open_penalty_interest_remove_space}    ,    .
    ${open_penalty_interest_number}    Convert To Number    ${open_penalty_interest_amount}
    Log To Console    ${open_penalty_interest_number}
    ${open_reminder_fees_amount1}    Get text    xpath=//html/body/div[1]/div[3]/div/div[3]/div[1]/div[1]/div[2]/div[6]/div[2]/div[2]/div[2]/table/tbody/tr[4]/td[2]    #get open reminder fees amount from balance box
    Log To Console    ${open_reminder_fees_amount1}
    ${open_reminder_fees_just_amount}    Get Substring    ${open_reminder_fees_amount1}    \    -4
    Log To Console    ${open_reminder_fees_just_amount}
    ${open_reminder_fees_remove_space}    Replace String    ${open_reminder_fees_just_amount}    ${SPACE}    ${EMPTY}
    Log To Console    ${open_reminder_fees_remove_space}
    ${open_reminder_fees_amount}    Replace String    ${open_reminder_fees_remove_space}    ,    .
    ${open_reminder_fees_number}    Convert To Number    ${open_reminder_fees_amount}
    Log To Console    ${open_reminder_fees_number}
    Set Suite Variable    ${invoiced_amount_number}
    Set Suite Variable    ${credited_amount_number}
    Set Suite Variable    ${paid_amount_number}
    Set Suite Variable    ${written_off_amount_number}
    Set Suite Variable    ${penalty_interest_amount_number}
    Set Suite Variable    ${reminder_fees_amount_number}
    Set Suite Variable    ${open_invoices_amount_number}
    Set Suite Variable    ${open_credit_invoices_amount_number}
    Set Suite Variable    ${open_penalty_interest_number}
    Set Suite Variable    ${open_reminder_fees_amount}

ckeck_if_payment_exist
    [Arguments]    ${column1}
    ${tmp}    Get Matching Xpath Count    html/body/div/div[3]/div/div[3]/div[1]/div[2]/div[2]/div[1]/table/tbody
    ${tmp}    Convert To Integer    ${tmp}
    Log To Console    ${tmp}
    : FOR    ${i}    IN RANGE    ${tmp}
    \    ${doc_type}    Get Table Cell    id=results-table    ${i+2}    ${column1}
    \    ${ProperValues}=    Run Keyword And Return Status    Should Be True    '${doc_type}'!='Payment"
    \    Run Keyword If    ${ProperValues}    Exit For Loop

get_table_cell_values
    ${documents_items}    Get Matching Xpath Count    html/body/div/div[3]/div/div[3]/div[1]/div[2]/div[2]/div[1]/table/tbody/tr
    ${documents_items}    Convert To Integer    ${documents_items}
    Log To Console    ${documents_items}
    ${aa}    Set Variable    0
    : FOR    ${i}    IN RANGE    2    ${documents_items+2}    2
    \    ${unpaid_n}    Get Table Cell    xpath=html/body/div/div[3]/div/div[3]/div[1]/div[2]/div[2]/div[1]/table    ${i}    10
    \    ${unpaid_0}    Get Substring    ${unpaid_n}    \    -4
    \    ${unpaid_n1}    Replace String    ${unpaid_0}    ,    .
    \    ${unpaid_n2}    Replace String    ${unpaid_n1}    ${SPACE}    ${EMPTY}
    \    ${aa}    Evaluate    ${aa}+${unpaid_n2}
    \    Log To Console    ${aa}
