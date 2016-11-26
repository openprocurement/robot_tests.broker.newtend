*** Settings ***
Library  Selenium2Screenshots
Library  Selenium2Library
Library  String
Library  DateTime
Library  newtend_service.py

*** Variables ***
# Auction creation locators
${locator.title}                     id=tender-title    # Lot number (name) according to DGF
${locator.description}               tender-description     # Lot is going to be present on Auction
${locator.dgfid}                     id=tender-dgfID    # dfgID field
${locator.value.amount}              id=budget          # Start Lot price
${locator.minimalStep.amount}        id=step            # Minimal price step-up
${locator.step.percentage}           id=step-percent    # Step percentage
${locator.guaranteeamount}           id=guarantee-amount    # Amount of Bank guarantee
# Item's locators
${locator.items[0].description}      id=itemDescription0     # Description of Item (Lot in Auctions)
${locator.items[0].quantity}         id=quantity0
${locator.items[0].unit.name}        id=measure-list
${locator.items[0].classification.scheme}           id=classifier10
${locator.items[0].classification.scheme.title}     xpath=//label[contains(., "Классификатор CPV")]

${locator.items[0].deliveryAddress}   id=deliveryAddress0   # Modal window will appear
${locator.delivery_zip}             xpath=//input[@name="postalCode"]
${locator.delivery_region}          xpath=//input[@name="region"]
${locator.delivery_town}            xpath=//input[@name="locality"]
${locator.delivery_address}         xpath=//input[@name="streetAddress"]
${locator.delivery_save}            xpath=//button[@ng-click="save()"]
${locator.tenderPeriod.endDate}     id=end-date-registration

${locator.save}            id=submit-btn    # Publish auction btn is used, when creating auction firstly
# View locators
${locator.view.status}               xpath=//span[@class="status ng-binding"]
${locator.view.title}                id=view-tender-title
${locator.view.description}          id=view-tender-description
${locator.view.dgfID}                id=view-tender-dgfID
${locator.view.value.amount}         id=view-tender-value
${locator.view.minimalStep.amount}   id=step
${locator.view.tenderPeriod.startDate}      id=start-date-registration
${locator.view.tenderPeriod.endDate}        id=end-date-registration
${locator.view.auctionPeriod.startDate}     xpath=//span[@ng-if="tender.data.auctionPeriod"]
${locator.view.enquiryPeriod.StartDate}     id=start-date-qualification
${locator.view.enquiryPeriod.endDate}       id=end-date-qualification
${locator.view.items[0].deliveryDate.endDate}   id=end-date-delivery
${locator.view.procuringEntity.name}        id=view-customer-name
${locator.view.items[0].deliveryAddress}    id=deliveryAddress
${locator.view.items[0].classification.scheme.title}  xpath=//label[@for="classifier-0"]   # id=classifier-0
${locator.view.items[0].classification.scheme}        id=classifier-0
${locator.view.items[0].classification.id}            id=classifier-0
${locator.view.QUESTIONS[0].title}          xpath=//span[@class="user ng-binding"]
${locator.view.QUESTIONS[0].description}    xpath=//span[@class="question-description ng-binding"]
${locator.view.QUESTIONS[0].date}           xpath=//span[@class="date ng-binding"]
${locator.view.items[0].unit.name}          xpath=//span[@class="unit ng-binding"]
${locator.view.items[0].quantity}           id=quantity-0
${locator.view.items[0].description}        id=view-item-description-0
${locator.view.auctionId}                   xpath=//a[@class="ng-binding ng-scope"]
${locator.view.value.valueAddedTaxIncluded}         xpath=//label[@for="with-nds"]
${locator.view.value.currency}              xpath=//label[@for="budget"]
${locator.view.auctionPeriod.startDate}     xpath=//div[@class="ng-binding"]    # Date and time of auction Trade tab
${locator.view.cancellations[0].status}     xpath=//h4[@class="ng-binding"]
${locator.view.documents.title}             xpath=//a[@class="ng-binding"]
${locator.view.eligibilityCriteria}         id=eligibility-criteria    # eligibility Criteria field show
${locator.answer_raw}                       xpath=//div[@class="row question-container"]

*** Keywords ***
Підготувати дані для оголошення тендера
  [Arguments]  ${username}  ${tender_data}  ${role_name}
  ${tender_data}=   update_data_for_newtend_new   ${role_name}   ${tender_data}
  [Return]   ${tender_data}


Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  ...      ${ARGUMENTS[0]} ==  username
  Open Browser
  ...      ${USERS.users['${ARGUMENTS[0]}'].homepage}
  ...      ${USERS.users['${ARGUMENTS[0]}'].browser}
  ...      alias=${ARGUMENTS[0]}
  Set Window Size   @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
  Run Keyword If   '${ARGUMENTS[0]}' != 'Newtend_Viewer'   Login    ${ARGUMENTS[0]}

Login
  [Arguments]  @{ARGUMENTS}
#  Logs in as Auction owner, who can create Fin auctions
  Wait Until Page Contains Element   id=password   20
  Input Text   id=view-email   ${USERS.users['${ARGUMENTS[0]}'].login}
  Input Text   id=password   ${USERS.users['${ARGUMENTS[0]}'].password}
  Click Element   id=edit-tender-btn
  Sleep     2
  Log To Console   Success logging in as Some one - ${ARGUMENTS[0]}

Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data
# Initialisation. Getting values from Dictionary
  Log To Console    Start creating procedure

  ${title}=         Get From Dictionary   ${ARGUMENTS[1].data}               title
  ${description}=   Get From Dictionary   ${ARGUMENTS[1].data}               description
  ${dgfID}=         Get From Dictionary   ${ARGUMENTS[1].data}               dgfID
  ${budget}=        Get From Dictionary   ${ARGUMENTS[1].data.value}         amount
  ${guarantee}=     Get From Dictionary   ${ARGUMENTS[1].data.guarantee}     amount
  ${step_rate}=     Get From Dictionary   ${ARGUMENTS[1].data.minimalStep}   amount
  #  Items block info
  ${items}=                                Get From Dictionary         ${ARGUMENTS[1].data}                   items
  ${item0}=                                Get From List               ${items}                               0
  ${item_description}=                     Get From Dictionary         ${item0}                               description
  ${item_quantity}=                        Get From Dictionary         ${item0}                               quantity
  ${unit_code}=                            Get From Dictionary         ${item0.unit}                          code
  ${unit_name}=                            Get From Dictionary         ${item0.unit}                          name
  ${classification_scheme}=                Get From Dictionary         ${item0.classification}                scheme
  ${classification_description}=           Get From Dictionary         ${item0.classification}                description
  ${classification_id}=                    Get From Dictionary         ${item0.classification}                id
  ${deliveryaddress_postalcode}=           Get From Dictionary         ${item0.deliveryAddress}               postalCode
  ${deliveryaddress_countryname}=          Get From Dictionary         ${item0.deliveryAddress}               countryName
  ${deliveryaddress_streetaddress}=        Get From Dictionary         ${item0.deliveryAddress}               streetAddress
  ${deliveryaddress_region}=               Get From Dictionary         ${item0.deliveryAddress}               region
  ${deliveryaddress_locality}=             Get From Dictionary         ${item0.deliveryAddress}               locality


#  # Date of auction start
  ${start_date}=    Get From Dictionary   ${ARGUMENTS[1].data.auctionPeriod}    startDate

  Wait Until Page Contains Element   xpath=//a[@ui-sref="createTender"]   100
  Click Link                         xpath=//a[@ui-sref="createTender"]
# Selecting DGF Financial asset or DGF Other assets
  Run Keyword If  '${mode}' == 'dgfFinancialAssets'  select from list by value   xpath=//select[@id="tenderProcedure"]   dgfFinancialAssets
  Run Keyword If  '${mode}' == 'dgfOtherAssets'    select from list by value     xpath=//select[@id="tenderProcedure"]   dgfOtherAssets
  Click Element     id=attach-docs-btn

  Log To Console    Selecting Some procedure ${mode}

# Input fields tender
  Input Text   ${locator.title}              ${title}
  Input Text   ${locator.description}        ${description}
  Input Text   ${locator.dgfid}              ${dgfID}
  ${budget_string}      Convert To String    ${budget}
  Input Text   ${locator.value.amount}       ${budget_string}
  Click Element    id=with-nds
  ${step_rate_string}   Convert To String     ${step_rate}
  Input Text   ${locator.minimalStep.amount}  ${step_rate_string}
  ${guarantee_string}   Convert To String     ${guarantee}
  Input Text    ${locator.guaranteeamount}    ${guarantee_string}
# Add Item(s)
  Input Text    ${locator.items[0].description}     ${item_description}
  Input Text    ${locator.items[0].quantity}        ${item_quantity}
  click Element   ${locator.items[0].unit.name}
  click Element   xpath=//a[contains(text(), '${unit_name}')]
# Selecting classifier
  Click Element     ${locator.items[0].classification.scheme}
  Sleep     5
  Input Text        id=classifier-search-field    ${classification_id}
  Sleep     5
  Click Element     xpath=//span[contains(text(), '${classification_id}')]
  Click Element     id=select-classifier-btn

# Add delivery address
  Click Element     ${locator.items[0].deliveryAddress}
  Sleep     2
  Input Text        ${locator.delivery_zip}      ${deliveryaddress_postalcode}
  Input Text        ${locator.delivery_region}   ${deliveryaddress_region}
  Input Text        ${locator.delivery_town}     ${deliveryaddress_locality}
  Input Text        ${locator.delivery_address}  ${deliveryaddress_streetaddress}
  Click Element     ${locator.delivery_save}

# Auction Start date block
  ${start_date_date}  Get Substring   ${start_date}    0   10
  ${hours}=           Get Substring   ${start_date}   11   13
  ${minutes}=         Get Substring   ${start_date}   14   16
  Input Text   ${locator.tenderPeriod.endDate}      ${start_date_date}
  Input Text   xpath=//input[@ng-change="updateHours()"]     ${hours}
  Input Text   xpath=//input[@ng-change="updateMinutes()"]   ${minutes}

# Save Auction - publish to CDB
  Click Element                      ${locator.save}
  Wait Until Page Contains Element   xpath=//div[@id="attach-docs-modal"]   30
  Click Element                      id=no-docs-btn
# Get Ids
  Wait Until Page Contains Element   xpath=//div[@class="title"]   30
  ${tender_uaid}=         Get Text   xpath=//div[@class="title"]
  [Return]  ${TENDER_UAID}


Додати багато придметів
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items
  ${Items_length}=     Get Length   ${items}
  : FOR    ${INDEX}    IN RANGE    1    ${Items_length}
  \   Click Element    ${locator.edit.add_item}
  \   Додати придмет   ${items[${INDEX}]}   ${INDEX}

# ===================================
#       Docs Upload
# ===================================
Завантажити документ
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${file_path}
  ...      ${ARGUMENTS[2]} ==  ${TENDER_UAID}
#  Fail   Тест не написаний
  # Navigating to documents tab
  Reload Page
  Sleep     2
  Click Element     xpath=//a[@ui-sref="tenderView.documents"]
  Sleep     3
  Wait Until Page Contains Element     xpath=//button[@ng-click="uploadDocument()"]
  Click Element     xpath=//button[@ng-click="uploadDocument()"]
  # Interacting with document upload mechanism
  Log To Console    'Interacting with documents modal window'
  Wait Until Page Contains Element     xpath=//form[@name="uploadDocumentsForm"]
  Log To Console    'Specify document type'
  Select From List By Value    xpath=//select[@id="documentType"]      notice
  Sleep     2
  Log To Console    'Inserting document'
  # === Mega Hack for document Upload ===
  Execute Javascript  $('button[ng-model="file"]').click()
  Choose File         xpath=//input[@type="file"]    ${ARGUMENTS[1]}
  Sleep     2
  # Confirm file Upload
  Click Element     xpath=//button[@ng-click="upload()"]
  Sleep     10

Завантажити ілюстрацію
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  ${image_path}
  # Navigating to documents tab
  Reload Page
  Sleep     2
  Click Element     xpath=//a[@ui-sref="tenderView.documents"]
  Sleep     3
  Wait Until Page Contains Element     xpath=//button[@ng-click="uploadDocument()"]
  Click Element     xpath=//button[@ng-click="uploadDocument()"]
  # Interacting with document upload mechanism - Illustration
  Log To Console    'Interacting with documents modal window - Illustation'
  Wait Until Page Contains Element     xpath=//form[@name="uploadDocumentsForm"]
  Log To Console    'Specify document type'
  Select From List By Value    xpath=//select[@id="documentType"]      illustration
  Sleep     2
  Log To Console    'Inserting document'
  # === Mega Hack for document Upload ===
  Execute Javascript  $('button[ng-model="file"]').click()
  Choose File         xpath=//input[@type="file"]    ${ARGUMENTS[2]}
  Sleep     2
  # Confirm file Upload
  Click Element     xpath=//button[@ng-click="upload()"]
  Sleep     10

Додати Virtual Data Room
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  ${vdr_link}
  # Navigating to documents tab
  Reload Page
  Sleep     2
  Click Element     xpath=//a[@ui-sref="tenderView.documents"]
  Sleep     3
  Wait Until Page Contains Element     xpath=//button[@ng-click="uploadDocument()"]
  Click Element     xpath=//button[@ng-click="uploadDocument()"]
  # Interacting with document upload mechanism - Illustration
  Log To Console    'Interacting with documents modal window - Illustation'
  Wait Until Page Contains Element     xpath=//form[@name="uploadDocumentsForm"]
  Log To Console    'Specify document type'
  Select From List By Value    xpath=//select[@id="documentType"]      virtualDataRoom
  Sleep     2
  Log To Console    'Inserting VDR'
  Input Text    xpath=//input[@id="auction-vdr-url"]    ${ARGUMENTS[2]}
  Input Text    xpath=//input[@id="auction-vdr-title"]  ${ARGUMENTS[2]}
  # === Mega Hack for document Upload ===
  # Confirm file Upload
  Click Element     xpath=//button[@ng-click="upload()"]
  Sleep     10
# ======= Docs Upload ===============

Подати скаргу
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  ${Complain}
  Fail  Не реалізований функціонал

порівняти скаргу
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${file_path}
  ...      ${ARGUMENTS[2]} ==  ${TENDER_UAID}
  Fail  Не реалізований функціонал

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  Log To Console   Searching for UFOs - ${ARGUMENTS[1]}
  Switch browser   ${ARGUMENTS[0]}
  Run Keyword If   '${ARGUMENTS[0]}' == 'Newtend_Owner'   Wait Until Page Contains Element    xpath=//a[@href="#/home/?pageNum=1&query=&status=&userOnly=&procurementMethodType="]
  Run Keyword If   '${ARGUMENTS[0]}' == 'Newtend_Owner'   Click Element    xpath=//a[@href="#/home/?pageNum=1&query=&status=&userOnly=&procurementMethodType="]
  Run Keyword If   '${ARGUMENTS[0]}' != 'Newtend_Owner'   Click Element    xpath=//div[@href="#/home/?pageNum=1&query=&status=&bidderOnly=&procurementMethodType="]
  Sleep     2
  ${auction_number}=    Convert To String   ${ARGUMENTS[1]}
  Input Text        xpath=//input[@type="search"]     ${auction_number}
  Click Element     xpath=//div[@ng-click="search()"]
  Sleep     2
  Wait Until Page Contains Element   xpath=//a[@ui-sref="tenderView.overview({id: tender.id})"]   10
  Sleep     2
  Click Element                      xpath=//a[@ui-sref="tenderView.overview({id: tender.id})"]

# ====Newtend===========
отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uaid
  ...      ${ARGUMENTS[2]} ==  field_name
  Switch browser   ${ARGUMENTS[0]}
  Run Keyword And Return  Отримати інформацію про ${ARGUMENTS[2]}

отримати текст із поля і показати на сторінці
  [Arguments]   ${field_name}
  Sleep  2
  ${return_value}=   Get Text  ${locator.view.${field_name}}
  [Return]  ${return_value}

отримати інформацію про title
  ${title}=   отримати текст із поля і показати на сторінці   title
  [Return]  ${title}

Отримати інформацію про status
  Reload page
  ${return_value}=   отримати текст із поля і показати на сторінці   status
  ${return_value}=   convert_nt_string_to_common_string     ${return_value}
  Log To Console     ${return_value}
  [Return]  ${return_value}

отримати інформацію про description
  ${description}=   отримати текст із поля і показати на сторінці   description
  [Return]  ${description}

отримати інформацію про dgfID
  ${description}=   отримати текст із поля і показати на сторінці   dgfID
  [Return]   ${description}

отримати інформацію про auctionId
  ${auctionId}=   отримати текст із поля і показати на сторінці   auctionId
  [Return]  ${auctionId}

отримати інформацію про value.amount
  ${valueAmount}=   отримати текст із поля і показати на сторінці   value.amount
  ${valueAmount}=   Convert To Number   ${valueAmount.split(' ')[0]}
  Log To Console    value amount - ${valueAmount}
  [Return]  ${valueAmount}

отримати інформацію про minimalStep.amount
  ${minimalStepAmount}=   отримати текст із поля і показати на сторінці   minimalStep.amount
  ${minimalStepAmount}=   Convert To Number   ${minimalStepAmount.split(' ')[0]}
  [Return]  ${minimalStepAmount}

Отримати інформацію про value.currency
  ${valueCurrency}=       отримати текст із поля і показати на сторінці    value.currency
  ${valueCurrency}=       Get Substring     ${valueCurrency}    -4      -1
  Log To Console          ${valueCurrency}
  [Return]   ${valueCurrency}

# NDS
Отримати інформацію про value.valueAddedTaxIncluded
  ${return_value}=   отримати текст із поля і показати на сторінці   value.valueAddedTaxIncluded
  ${return_value}=   convert_nt_string_to_common_string      ${return_value}
  Log To Console        ${return_value}
  [Return]  ${return_value}

# Name of auction creator
отримати інформацію про procuringEntity.name
  ${procuringEntity_name}=   отримати текст із поля і показати на сторінці   procuringEntity.name
  Log To Console  ${procuringEntity_name}
  [Return]  ${procuringEntity_name}

отримати інформацію про enquiryPeriod.endDate
  ${enquiryPeriodEndDate}=   отримати текст із поля і показати на сторінці   enquiryPeriod.endDate
  [Return]  ${enquiryPeriodEndDate}

отримати інформацію про tenderPeriod.startDate
  ${tenderPeriodStartDate}=   отримати текст із поля і показати на сторінці   tenderPeriod.startDate
  [Return]  ${tenderPeriodStartDate}

отримати інформацію про tenderPeriod.endDate
  ${tenderPeriodEndDate}=   отримати текст із поля і показати на сторінці   tenderPeriod.endDate
  Log To Console     ${tenderPeriodEndDate}
  ${return_value}=   get_time_with_offset   ${tenderPeriodEndDate}
  Log To Console     ${return_value}
  [Return]  ${return_value}

отримати інформацію про enquiryPeriod.startDate
  ${enquiryPeriodStartDate}=   отримати текст із поля і показати на сторінці   enquiryPeriod.StartDate
  [Return]  ${enquiryPeriodStartDate}

# full scenario
Отримати інформацію про eligibilityCriteria
  ${eligibilityCriteria}=   отримати текст із поля і показати на сторінці   eligibilityCriteria
  Log To Console            ${eligibilityCriteria}
  [Return]  ${eligibilityCriteria}

# Comperison of Item names fields
Отримати інформацію із предмету
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uaid
  ...      ${ARGUMENTS[2]} ==  item_id
  ...      ${ARGUMENTS[3]} ==  field_name
   Run Keyword And Return  Отримати інформацію із ${ARGUMENTS[3]}

переглянути текст із поля і показати на сторінці
  [Arguments]   ${field_name}
  Sleep  1
  ${return_value}=   Get Text  ${locator.view.${field_name}}
  [Return]  ${return_value}

отримати інформацію із description
# Відображення опису номенклатур тендера
  ${description_raw}=   переглянути текст із поля і показати на сторінці   items[0].description
  ${description_1}=   Get Substring     ${description_raw}  0   11
  ${description_2}=   convert_nt_string_to_common_string  ${description_raw.split(': ')[-1]}
  ${description}=   catenate  ${description_1}  ${description_2}
  Log To Console    ${description_1}
  Log To Console    ${description_2}
  [Return]  ${description}

отримати інформацію із items[0].deliveryDate.endDate
  ${deliveryDate_endDate}=   переглянути текст із поля і показати на сторінці   items[0].deliveryDate.endDate
  [Return]  ${deliveryDate_endDate}

отримати інформацію про items[0].deliveryLocation.latitude
  Fail  Не реалізований функціонал

отримати інформацію про items[0].deliveryLocation.longitude
  Fail  Не реалізований функціонал

##CAV
Отримати інформацію із classification.scheme
# Відображення схеми класифікації номенклатур тендера - CAV
  ${classificationScheme_newtend}=   переглянути текст із поля і показати на сторінці   items[0].classification.scheme.title
  ${classificationScheme}=           convert_nt_string_to_common_string      ${classificationScheme_newtend}
  [Return]  ${classificationScheme}

отримати інформацію із classification.id
  ${classification_id}=   переглянути текст із поля і показати на сторінці   items[0].classification.scheme
  [Return]  ${classification_id.split(' - ')[0]}

отримати інформацію із classification.description
#  Відображення опису класифікації номенклатур тендера
  ${classification_description_raw}=   переглянути текст із поля і показати на сторінці   items[0].classification.scheme
  ${classification_description}=       Get Substring      ${classification_description_raw}     13
  Log To Console        ${classification_description}
  [Return]      ${classification_description}

##item
отримати інформацію із unit.name
  ${unit_name}=   переглянути текст із поля і показати на сторінці   items[0].unit.name
  Run Keyword And Return If  '${unit_name}' == 'килограммы'   Convert To String   кілограм
  [Return]  ${unit_name}

Отримати інформацію про unit.code
  Fail  Не реалізований функціонал

отримати інформацію із quantity
  ${quantity}=   переглянути текст із поля і показати на сторінці   items[0].quantity
  ${quantity}=   Convert To Number   ${quantity}
  [Return]  ${quantity}

додати предмети закупівлі
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  username
  ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} =  3
  ${period_interval}=  Get Broker Property By Username  ${ARGUMENTS[0]}  period_interval
  ${ADDITIONAL_DATA}=  prepare_test_tender_data  ${period_interval}      multi
  ${items}=            Get From Dictionary   ${ADDITIONAL_DATA.data}     items
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Wait Until Page Contains Element   ${locator.edit_tender}    10
  Click Element                      ${locator.edit_tender}
  Wait Until Page Contains Element   ${locator.edit.add_item}  10
  Input Text        ${locator.edit.description}   description
  Run Keyword If   '${TEST NAME}' == 'Можливість додати позицію закупівлі в тендер'   додати позицію
  Run Keyword If   '${TEST NAME}' != 'Можливість додати позицію закупівлі в тендер'   забрати позицію
  Wait Until Page Contains Element   ${locator.save}           10
  Click Element   ${locator.save}
  Wait Until Page Contains Element   ${locator.description}    20

Задати питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} = question_data
  ${title}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=  Get From Dictionary  ${ARGUMENTS[2].data}  description
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  newtend.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Click Element                      xpath=//a[@ui-sref="tenderView.chat"]
  Wait Until Page Contains Element   xpath=//button[@ng-click="askQuestion()"]   20
  Click Element                      xpath=//button[@ng-click="askQuestion()"]
#  Wait Until Page Contains Element   xpath=//input[@ng-model="title"]   10
  Input Text      xpath=//input[@ng-model="chatData.title"]   ${title}
  Input Text      xpath=//textarea[@ng-model="chatData.message"]   ${description}
  Sleep     2
  Click Element   xpath=//button[@ng-click="sendQuestion()"]
  Wait Until Page Contains    ${description}   20

  # :TODO Not realized
Задати запитання на тендер
  [Arguments]   @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} = question_data
  ${title}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=  Get From Dictionary  ${ARGUMENTS[2].data}  description
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  newtend.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Click Element                      xpath=//a[@ui-sref="tenderView.chat"]
  Wait Until Page Contains Element   xpath=//button[@ng-click="askQuestion()"]   20
  Click Element                      xpath=//button[@ng-click="askQuestion()"]
  Wait Until Page Contains Element   xpath=//input[@ng-model="chatData.title"]   10
  Input Text      xpath=//input[@ng-model="chatData.title"]   ${title}
  Input Text      xpath=//textarea[@ng-model="chatData.message"]   ${description}
  Click Element   xpath=//button[@ng-click="sendQuestion()"]
  Wait Until Page Contains    ${description}   20

  # TODO: In progress
Задати запитання на предмет
  [Arguments]   @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} = item_id
  ...      ${ARGUMENTS[3]} = question_data
#  log to console  argument1 - '${ARGUMENTS[1]}'
#  log to console  argument2 - '${ARGUMENTS[2]}'
#  log to console  argument3 - '${ARGUMENTS[3]}'
  ${title}=        Get From Dictionary  ${ARGUMENTS[3].data}  title
  ${description}=  Get From Dictionary  ${ARGUMENTS[3].data}  description
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  newtend.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Click Element                      xpath=//a[@ui-sref="tenderView.chat"]
  Wait Until Page Contains Element   xpath=//button[@ng-click="askQuestion()"]   20
  Click Element                      xpath=//button[@ng-click="askQuestion()"]
  Input Text      xpath=//input[@ng-model="chatData.title"]   ${title}
  Input Text      xpath=//textarea[@ng-model="chatData.message"]   ${description}
  Click Element   xpath=//button[@ng-click="sendQuestion()"]
  Wait Until Page Contains    ${description}   20

Оновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} == username
  ...      ${ARGUMENTS[1]} == ${TENDER_UAID}
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Reload Page

# ==========================
# Questions interaction
# ==========================

Отримати інформацію із запитання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uaid
  ...      ${ARGUMENTS[2]} ==  item_id    # Something like this - q-e5b21059
  ...      ${ARGUMENTS[3]} ==  field_name
  Run Keyword And Return  Отримати інформацію про Questions.${ARGUMENTS[3]}

Отримати інформацію про Questions.answer
  Reload Page
  Wait Until Page Contains Element   xpath=//a[@ui-sref="tenderView.chat"]   20
  Click Element              xpath=//a[@ui-sref="tenderView.chat"]
  Reload Page
  Sleep     2
  ${title}=     Get Webelements     xpath=//span[@class="answer-description ng-binding"]
  ${resp}=   Get Text   ${title[-1]}
  Log To Console    ${resp}
  [Return]  ${resp}

отримати інформацію про questions.title
  Wait Until Page Contains Element   xpath=//a[@ui-sref="tenderView.chat"]   20
  Click Element              xpath=//a[@ui-sref="tenderView.chat"]
  Reload Page
  Sleep     2
  ${title}=     Get Webelements     xpath=//span[@class="user ng-binding"]
  ${resp}=   Get Text   ${title[-1]}
  Log To Console    ${resp}
  [Return]  ${resp}

отримати інформацію про questions.description
# ${locator.view.QUESTIONS[0].description}    xpath=//span[@class="question-description ng-binding"]
  ${description}=   Get Webelements     xpath=//span[@class="question-description ng-binding"]
  ${resp}=   Get Text   ${description[-1]}
  Log To Console    ${resp}
  [Return]  ${resp}

#отримати інформацію про QUESTIONS[0].date
#  ${resp}=   отримати текст із поля і показати на сторінці   QUESTIONS[0].date
#  ${resp}=   Change_day_to_month   ${resp}
#  [Return]  ${resp}

Відповісти на запитання
   [Arguments]      @{ARGUMENTS}
   [Documentation]
   ...      ${ARGUMENTS[0]} == username
   ...      ${ARGUMENTS[1]} == ${tender_uaid}
   ...      ${ARGUMENTS[2]} == ${item_index} # smth strange
   ...      ${ARGUMENTS[3]} == ${answer_id}
   Reload Page
   ${answer}=     Get From Dictionary  ${ARGUMENTS[2].data}  answer
#   Log to Console   ${answer}
#   Log to Console   argument 2 - ${ARGUMENTS[2]}
   Click Element        xpath=//a[@ui-sref="tenderView.chat"]
   Sleep    3
   # Try to answer
   ${answer_row}=   Get Webelements   xpath=//div[@ng-repeat="question in questions"]
   Log To Console   ${answer_row[-1]}
   Mouse Over       ${answer_row[-1]}    # should show answer btn
   ${answer_round}=     Get Webelements     xpath=//div[@class="answer"]
   Focus            ${answer_round[-1]}
   Click Element    ${answer_round[-1]}
   Sleep    2
   Input Text       xpath=//textarea[@ng-model="chatData.message"]   ${answer}
   Click Element    xpath=//button[@ng-click="sendAnswer()"]

# =======================================
#       Question interaction end
# =======================================

# === Bid Making === Works fine
Подати цінову пропозицію
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} == username
  ...      ${ARGUMENTS[1]} == tender_uaid
  ...      ${ARGUMENTS[2]} == ${test_bid_data}
#  Log to Console    arg0 - '${ARGUMENTS[0]}'
#  Log to Console    arg1 - '${ARGUMENTS[1]}'
#  Log to Console    arg2 - '${ARGUMENTS[2]}'
  ${amount}=    Get From Dictionary     ${ARGUMENTS[2].data.value}    amount
  Reload Page
  : FOR   ${INDEX}   IN RANGE    1    30
  \   Log To Console   .   no_newline=true
  \   sleep     3
  \   ${count}=   Get Matching Xpath Count   xpath=//button[@ng-click="placeBid()"]
  \   Exit For Loop If   '${count}' == '1'
  Click Element     xpath=//button[@ng-click="placeBid()"]
  ${amount_bid}=    Convert To Integer                 ${amount}
  Clear Element Text  xpath=//input[@name="amount"]
  Input Text          xpath=//input[@name="amount"]    ${amount_bid}
  Click Element       xpath=//input[@name="agree"]          # Credential confirm
  # :TODO If case realise
  Run Keyword If      'Можливість' in '${TEST_NAME}'    Click Element       xpath=//input[@name="bid-valid"]      # Validation of bid
  Click Element       xpath=//button[@ng-click="placeBid()"]
  Sleep     3
  Reload Page
  Wait Until Page Contains Element      xpath=//div[@class="bid-placed make-bid ng-scope"]
  Sleep     2
  Run Keyword If      'Неможливість' in '${TEST_NAME}'    Wait Until Page Contains Element    xpath=//div[@class="alert alert-warning ng-binding"]
  Run Keyword If      'Неможливість' in '${TEST_NAME}'    Click Element   xpath=//a[@ng-click="cancelBid()"]
  Sleep     2
#  Run Keyword If      'Неможливість' in '${TEST_NAME}'    Click Element   xpath=//a[@ng-click="cancelBid()"]
  Run Keyword If      'Неможливість' in '${TEST_NAME}'    Wait Until Page Contains Element   xpath=//button[@ng-click="cancelBid()"]
  Run Keyword If      'Неможливість' in '${TEST_NAME}'    Click Element   xpath=//button[@ng-click="cancelBid()"]
  ${resp}=      Run Keyword If   'Можливість' in '${TEST_NAME}'   Get text    xpath=//h3[@class="ng-binding"]
  [Return]     ${resp}


# ========= Key words ========
#------------------------------------------------------------------------------
#Можливість завантажити протокол аукціону в пропозицію кандидата       | FAIL |
#No keyword with name 'newtend.Завантажити протокол аукціону' found.
#------------------------------------------------------------------------------
#Можливість перевірити протокол аукціону                               | FAIL |
#До ставки bid_index = 0 не завантажено документів
#------------------------------------------------------------------------------

Скасувати цінову пропозицію
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} == username
  ...      ${ARGUMENTS[1]} == ${TENDER_UAID}
  Click Element     xpath=//a[@ng-click="cancelBid()"]
  Wait Until Page Contains Element     xpath=//div[@ng-if="isCancel"]
  Click Element     xpath=//button[@ng-click="cancelBid()"]

Отримати інформацію із пропозиції
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} == username
  ${value_raw}=     Get Text   xpath=//h3[@title=""]
  Log To Console    ${value_raw}
  ${value_num}=     Get Substring  ${value_raw}  0   -4
  Log To Console    ${value_num}
  ${value}=         Convert To Integer  ${value_num}
  [Return]  ${value}

Змінити цінову пропозицію
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  tenderId
    ...    ${ARGUMENTS[2]} ==  amount
    ...    ${ARGUMENTS[3]} ==  amount.value
    Reload Page
    Sleep   2
    Click Element           xpath=//button[@ng-click="placeBid()"]
    Clear Element Text      xpath=//input[@name="amount"]
    ${updated_bid}=     Convert To Integer   ${ARGUMENTS[3]}
    Log To Console      Updatetd bid amount - ${updated_bid}
    Input Text          xpath=//input[@name="amount"]         ${updated_bid}
    Sleep   3
    Click Element       xpath=//button[@ng-click="changeBid()"]
    Sleep   3
    Reload Page
    # :TODO fin document - seems to be done
Завантажити фінансову ліцензію
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[0]} ==  file
  ...    ${ARGUMENTS[1]} ==  tenderId
  Log to Console    arg_0 - ${ARGUMENTS[0]}
  Log to Console    arg_1 - ${ARGUMENTS[1]}
  Log to Console    arg_2 - ${ARGUMENTS[2]}
  Click Element       xpath=//a[@ui-sref="tenderView.documents"]
  Wait Until Page Contains Element    xpath=//button[@ng-click="uploadDocument()"]
  Click Element       xpath=//button[@ng-click="uploadDocument()"]
  Sleep     2
  Log To Console    'Specify document type - financialLicense'
  Select From List By Value    xpath=//select[@id="documentType"]      financialLicense
  Sleep     2
  Execute Javascript  $('button[ng-file-select=""]').click()
  Sleep     3
  Choose File         xpath=//input[@type="file"]    ${ARGUMENTS[2]}
  Click Element       xpath=//button[@ng-click="upload()"]

Завантажити документ в ставку
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[1]} ==  file
  ...    ${ARGUMENTS[2]} ==  tenderId
  Log to Console    arg_0 - ${ARGUMENTS[0]}
  Log to Console    arg_1 - ${ARGUMENTS[1]}
  Log to Console    arg_2 - ${ARGUMENTS[2]}
  Click Element       xpath=//a[@ui-sref="tenderView.documents"]
  Wait Until Page Contains Element    xpath=//button[@ng-click="uploadDocument()"]
  Click Element       xpath=//button[@ng-click="uploadDocument()"]
  Sleep     2
  Log To Console    'Specify document type'
  Select From List By Value    xpath=//select[@id="documentType"]      commercialProposal
  Execute Javascript  $('button[ng-file-select=""]').click()
  Sleep     3
  Choose File         xpath=//input[@type="file"]    ${ARGUMENTS[2]}
  Click Element       xpath=//button[@ng-click="upload()"]

# :TODO Change document - seems to be done
Змінити документ в ставці
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[1]} ==  file
  ...    ${ARGUMENTS[2]} ==  tenderId
  Click Element       xpath=//a[@ui-sref="tenderView.documents"]
  Wait Until Page Contains Element    xpath=//button[@ng-click="uploadDocument()"]
  ${replaces}=      Get Webelements     xpath=//a[@ng-model="$parent.$parent.replaceFiles"]
  Execute Javasript     ${replaces[1]}.click()
  Sleep     2
  Choose File       xpath=//input[@type="file"]    ${ARGUMENTS[2]}
  Log To Console    Document changed
# ==================
# === Links for auction ===
Отримати посилання на аукціон для глядача
  [Arguments]  @{ARGUMENTS}
  Reload Page
  Sleep     3
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]
  # Waiting for auction viewer link
  : FOR   ${INDEX}   IN RANGE    1    30
  \   reload page
  \   Log To Console   .   no_newline=true
  \   sleep     30
  \   ${count}=   Get Matching Xpath Count   xpath=//a[@class="auction-link ng-binding"]
  \   ${link}=    Get Element Attribute      xpath=//a[@target="_blank"]@href
  \   Exit For Loop If   '${count}' == '1' and '${link}' != 'None'
  Wait Until Page Contains Element      xpath=//a[@class="auction-link ng-binding"]     10
  ${result}=    Get Element Attribute   xpath=//a[@target="_blank"]@href
  ${result}=    Convert To String  ${result}
  Log To Console    ${result}
  [Return]  ${result}


Отримати посилання на аукціон для учасника
  [Arguments]  @{ARGUMENTS}
  Reload Page
  Sleep     3
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]
  # Waiting for auction participant link
  : FOR   ${INDEX}   IN RANGE    1    30
  \   reload page
  \   Log To Console   .   no_newline=true
  \   sleep     30
  \   ${count}=   Get Matching Xpath Count   xpath=//a[@class="auction-link ng-binding"]
  \   ${link}=    Get Element Attribute      xpath=//a[@target="_blank"]@href
  \   Exit For Loop If   '${count}' == '1' and '${link}' != 'None'
  Wait Until Page Contains Element      xpath=//a[@class="auction-link ng-binding"]     10
  ${result}=    Get Element Attribute   xpath=//a[@target="_blank"]@href
  ${result}=    Convert To String       ${result}
  Log To Console    ${result}
  [Return]  ${result}
# =========================

Change_day_to_month
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]}  ==  date
  ${day}=     Get Substring   ${ARGUMENTS[0]}   0   2
  ${month}=   Get Substring   ${ARGUMENTS[0]}   3   6
  ${rest}=    Get Substring   ${ARGUMENTS[0]}   5
  ${return_value}=   Convert To String  ${month}${day}${rest}
  [Return]  ${return_value}


Отримати інформацію про auctionPeriod.startDate
  Click Element  xpath=//a[@ui-sref="tenderView.auction"]
  Sleep    2
  : FOR   ${INDEX}   IN RANGE    1    30
  \   reload page
  \   Log To Console   .   no_newline=true
  \   sleep     30
  \   ${count}=   Get Matching Xpath Count   xpath=//div[@class="ng-binding"]
  \   ${text}=   get text   xpath=//div[@class="ng-binding"]
  \   Exit For Loop If   '${count}' == '1' and '${text}' != ''
  ${return_value}=   отримати текст із поля і показати на сторінці  auctionPeriod.startDate
  Log To Console     Auction date - ${return_value}
  ${return_value}=   get_time_with_offset   ${return_value}
  Log To Console     converted date - ${return_value}
  [Return]  ${return_value}

Отримати інформацію про auctionPeriod.endDate
  Fail  На майданчику newtend не відображається поле Дата завершення аукціону

# =====================
#    Qualification
# =====================

Підтвердити постачальника
  [Arguments]  ${username}  ${tender_uaid}  ${award_num}
  Sleep     2
  Click Element  xpath=//a[@ui-sref="tenderView.auction"]
  Sleep     2
  Click Element  xpath=//div[@class="col-xs-4 status ng-binding pending"]
  Sleep     2
  Click Element  xpath=//button[@ng-click="decide('active')"]
  Sleep     2
  Click Element  xpath=//button[@ng-click="accept()"]
  Log To Console    Its ok - qualified

Підтвердити підписання контракту
  [Arguments]  ${username}  ${tender_uaid}  ${award_num}
  Sleep     2
  Click Element  xpath=//a[@ui-sref="tenderView.auction"]
  Sleep     2
  Click Element  xpath=//button[@ng-click="closeBids(lot.awardId, lot.contractId)"]
  Sleep     2
  Input Text   id=contractNumber    Contruct signed
  Click Element  xpath=//button[@ng-click="closeBids()"]
  Log To Console    Its Ok - contract signed

Отримати кількість документів в ставці
  # :TODO realize this key word
  Fail  Not realized

Скасування рішення кваліфікаційної комісії
  Fail  Not realized

Завантажити документ рішення кваліфікаційної комісії
  Fail  Not realized

Дискваліфікувати постачальника
  Fail  Not realized

Завантажити угоду до тендера
  Fail  Not realized
# ======================
# Qualification End
# ======================

# ===========================================
#           Auction Cancelation
# ===========================================
Скасувати закупівлю
  [Arguments]   @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} == 'username'
  ...      ${ARGUMENTS[1]} == 'auction_uaid'
  ...      ${ARGUMENTS[2]} == 'cancellation_reason'
  ...      ${ARGUMENTS[3]} == '[document][doc_path]'
  ...      ${ARGUMENTS[4]} == 'description'
  # Looking for Auction
  Log To Console   Searching for canceled UFOs - ${ARGUMENTS[1]}
  Switch browser   ${ARGUMENTS[0]}
  Run Keyword If   '${ARGUMENTS[0]}' == 'Newtend_Owner'   click element    xpath=//a[@href="#/home/?pageNum=1&query=&status=&userOnly=&procurementMethodType="]
  Sleep     2
  ${auction_number}=    Convert To String   ${ARGUMENTS[1]}
  Input Text        xpath=//input[@type="search"]     ${auction_number}
  Click Element     xpath=//div[@ng-click="search()"]
  Sleep     2
  Wait Until Page Contains Element   xpath=//a[@ui-sref="tenderView.overview({id: tender.id})"]   10
  Sleep   2
  Click Element                      xpath=//a[@ui-sref="tenderView.overview({id: tender.id})"]
  # Looking for cancell btn
  Sleep     2
  Click Element     xpath=//button[@id="cancel-tender-btn"]
  sleep     2
  Wait Until Page Contains Element     xpath=//form[@name="cancelTenderForm"]
  Input Text    xpath=//textarea[@name="comment"]   ${ARGUMENTS[2]}
  # Document attach
  # Mega Hack for documents Upload
  Execute Javascript  $('span[class="attach-title ng-binding"]').click()
  Sleep     3
  Choose File       xpath=//input[@type="file"]    ${ARGUMENTS[3]}
  Sleep     3
  Click Element     xpath=//div[@ng-click="delete()"]
  Sleep     15
  Reload Page
  Sleep     30
  Reload Page
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]       # Navigating to see cancellation reason
  Sleep     3


Отримати інформацію про cancellations[0].status
  Reload Page
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]       # Navigating to see cancellation reason
  Sleep     3
  ${return_value}=   отримати текст із поля і показати на сторінці  cancellations[0].status
  ${return_value}=   convert_Nt_String_To_Common_String     ${return_value}
  Log To Console     Auction date - ${return_value}
  [Return]      ${return_value}


Отримати інформацію про cancellations[0].reason
  ${raw_text}=      Get Webelements     xpath=//div[@class="col-xs-9 ng-binding"]
  ${text}=          Get Text         ${raw_text[-1]}
  Log To Console    ${text}
  [Return]          ${text}


Отримати інформацію із документа    # Document Title
  [Arguments]  ${username}  ${tender_uaid}  ${doc_id}  ${field}
  ${doc_title}=     Get WebElements    xpath=//a[@class="ng-binding"]
  ${title}=         Get Text           ${doc_title[-1]}
  Log To Console    ${title}
  [Return]  ${title}

# ========== Auction Cancellation ============