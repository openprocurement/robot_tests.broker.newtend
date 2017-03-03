*** Settings ***
#Library  Selenium2Screenshots
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
${locator.edit.add_item}             xpath=//a[@ng-click="addField()"]
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
${locator.dgfDecisionID}             id=view-tender-dgfDecisionID
${locator.view.dgfDecisionID}        id=view-tender-dgfDecisionID
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
${locator.view.items[1].classification.scheme.title}  xpath=//label[@for="classifier-1"]   # id=classifier-0
${locator.view.items[2].classification.scheme.title}  xpath=//label[@for="classifier-2"]   # id=classifier-0
${locator.view.items[0].classification.scheme}        id=classifier-0
${locator.view.items[1].classification.scheme}        id=classifier-1
${locator.view.items[2].classification.scheme}        id=classifier-2
${locator.view.items[0].classification.id}            id=classifier-0
${locator.view.items[1].classification.id}            id=classifier-1
${locator.view.items[2].classification.id}            id=classifier-2
${locator.view.QUESTIONS[0].title}          xpath=//span[@class="user ng-binding"]
${locator.view.QUESTIONS[0].description}    xpath=//span[@class="question-description ng-binding"]
${locator.view.QUESTIONS[0].date}           xpath=//span[@class="date ng-binding"]
${locator.view.items[0].unit.name}          xpath=//span[@class="unit ng-binding"]
${locator.view.items[0].quantity}           id=quantity-0
${locator.view.items[1].quantity}           id=quantity-1
${locator.view.items[2].quantity}           id=quantity-2
${locator.view.items[0].description}        id=view-item-description-0
${locator.view.items[1].description}        id=view-item-description-1
${locator.view.items[2].description}        id=view-item-description-2
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
  ${dgfDecisionID}=     Get From Dictionary   ${ARGUMENTS[1].data}        dgfDecisionID
  ${dgfDecisionDate}=   Get From Dictionary   ${ARGUMENTS[1].data}        dgfDecisionDate
  ${tenderAttempts}=    Get From Dictionary   ${ARGUMENTS[1].data}        tenderAttempts

# Date of auction start
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
# New fields add
  Input Text   xpath=//input[@id="tender-dgfDecisionID"]    ${dgfDecisionID}
  Input Text   xpath=//input[@id="tender-dgfDecisionDate"]  ${dgfDecisionDate}
  ${tender_attempts}=   Convert To String   ${tenderAttempts}
  Log To Console    attempts - '${tender_attempts}'
  Select From List By Value   xpath=//select[@id="tenderAttempts"]    ${tender_attempts}

  ${budget_string}      Convert To String    ${budget}
  Input Text   ${locator.value.amount}       ${budget_string}
  Click Element    id=with-nds
  ${step_rate_string}   Convert To String     ${step_rate}
  Input Text   ${locator.minimalStep.amount}  ${step_rate_string}
  ${guarantee_string}   Convert To String     ${guarantee}
  Input Text    ${locator.guaranteeamount}    ${guarantee_string}

#  Items block info
# === Loop Try to select items info ===
  ${item_number}=   substract             ${NUMBER_OF_ITEMS}    1
  ${item_number}=   Convert To Integer    ${item_number}
  log to console    number of items - 1 = '${item_number}'
  : FOR   ${INDEX}  IN RANGE    0    ${NUMBER_OF_ITEMS}
  \   ${items}=         Get From Dictionary   ${ARGUMENTS[1].data}            items
  \   ${item[x]}=                              Get From List               ${items}                 ${INDEX}
  \   ${item_description}=                  Get From Dictionary         ${item[x]}     description
  \   Log to Console    item-0-description '${INDEX}' - '${item_description}'
  \   ${item_quantity}=                     Get From Dictionary         ${item[x]}     quantity
  \   ${unit}=                              Get From Dictionary         ${item[x]}     unit
  \   ${unit_code}=                         Get From Dictionary         ${unit}        code
  \   Log to console      unit code - ${unit_code}
  \   ${unit_name}=                         Get From Dictionary         ${unit}        name
  \   ${classification}=                    Get From Dictionary         ${item[x]}     classification
  \   ${classification_scheme}=             Get From Dictionary         ${classification}    scheme
  \   ${classification_description}=        Get From Dictionary         ${classification}    description
  \   ${classification_id}=                 Get From Dictionary         ${classification}    id
  \   ${deliveryaddress}=                   Get From Dictionary         ${item[x]}           deliveryAddress
  \   ${deliveryaddress_postalcode}=        Get From Dictionary         ${deliveryaddress}   postalCode
  \   ${deliveryaddress_countryname}=       Get From Dictionary         ${deliveryaddress}   countryName
  \   ${deliveryaddress_streetaddress}=     Get From Dictionary         ${deliveryaddress}   streetAddress
  \   ${deliveryaddress_region}=            Get From Dictionary         ${deliveryaddress}   region
  \   ${deliveryaddress_locality}=          Get From Dictionary         ${deliveryaddress}   locality
#  === Seems to be working -^- Loop for getting the values from Dictionary ===
# Add Item(s)
  \   ${item_descr_field}=   Get Webelements     xpath=//input[@ng-model="item.description"]
  \   Input Text    ${item_descr_field[-1]}     ${item_description}
  \   ${item_quantity_field}=   Get Webelements     xpath=//input[@ng-model="item.quantity"]
  \   Input Text    ${item_quantity_field[-1]}        ${item_quantity}
  \   ${unit_name_field}=     Get Webelements     xpath=//a[@id="measure-list"]
  \   Focus   ${unit_name_field[-1]}
  \   Click Element   ${unit_name_field[-1]}
  \   Sleep     2
  \   ${need_measure}=   Get Webelements    xpath=//a[contains(text(), '${unit_name}')]
  \   Click Element   ${need_measure[-1]}
# Selecting classifier
  \   ${classifier_field}=      Get Webelements     xpath=//input[@ng-model="item.classification.field"]
  \   Click Element     ${classifier_field[-1]}
  \   Sleep     5
  \   Input Text        id=classifier-search-field    ${classification_id}
  \   Sleep     5
  \   Click Element     xpath=//span[contains(text(), '${classification_id}')]
  \   Click Element     id=select-classifier-btn
  \   Sleep     2
# Add delivery address
  \   ${delivery_field}=    Get Webelements     xpath=//input[@ng-model="item.address.field"]
  \   Click Element     ${delivery_field[-1]}
  \   Sleep     2
  \   Input Text        ${locator.delivery_zip}      ${deliveryaddress_postalcode}
  \   Input Text        ${locator.delivery_region}   ${deliveryaddress_region}
  \   Input Text        ${locator.delivery_town}     ${deliveryaddress_locality}
  \   Input Text        ${locator.delivery_address}  ${deliveryaddress_streetaddress}
  \   Click Element     ${locator.delivery_save}
  \   Sleep     3
  \   ${new_item_cross}=    Get Webelements     xpath=//a[@ng-click="addField()"]
  \   Run Keyword If   '${INDEX}' < '${item_number}'   Click Element    ${new_item_cross[-1]}

# Auction Start date block
  ${start_date_date}  Get Substring   ${start_date}    0   10
  ${hours}=           Get Substring   ${start_date}   11   13
  ${minutes}=         Get Substring   ${start_date}   14   16
  Input Text   ${locator.tenderPeriod.endDate}      ${start_date_date}
  Input Text   xpath=//input[@ng-change="updateHours()"]     ${hours}
  Input Text   xpath=//input[@ng-change="updateMinutes()"]   ${minutes}

#  Clear Element Text    xpath=//input[@name="tenderTurbo"]
#  Input Text            xpath=//input[@name="tenderTurbo"]      360

# Save Auction - publish to CDB
  Click Element                      ${locator.save}
  Wait Until Page Contains Element   xpath=//div[@id="attach-docs-modal"]   30
  Click Element                      id=no-docs-btn
# Get Ids
  Wait Until Page Contains Element   xpath=//div[@class="title"]   30
  ${tender_uaid}=         Get Text   xpath=//div[@class="title"]
  [Return]  ${TENDER_UAID}

# ===================================
#       Docs Upload
# ===================================
Завантажити документ
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${file_path}
  ...      ${ARGUMENTS[2]} ==  ${TENDER_UAID}
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
  Select From List By Value    xpath=//select[@id="documentType"]      tenderNotice
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
  Log To Console    arg-2 - ${ARGUMENTS[2]}
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
  Log To Console    'Interacting with documents modal window - VDR'
  Wait Until Page Contains Element     xpath=//form[@name="uploadDocumentsForm"]
  Log To Console    'Specify document type'
  Select From List By Value    xpath=//select[@id="documentType"]      virtualDataRoom
  Sleep     2
  Log To Console    'Inserting VDR'
  Input Text    xpath=//input[@id="auction-documnet-title"]    ${ARGUMENTS[2]}
  Input Text    xpath=//input[@id="document-url"]  ${ARGUMENTS[2]}
  # === Mega Hack for document Upload ===
  # Confirm file Upload
  Click Element     xpath=//button[@ng-click="upload()"]
  Sleep     10

Додати публічний паспорт активу
# This is Link for Document, but not document as is
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
  Log To Console    'Interacting with documents modal window - Public Passport'
  Wait Until Page Contains Element     xpath=//form[@name="uploadDocumentsForm"]
  Log To Console    'Specify document type'
  Select From List By Value    xpath=//select[@id="documentType"]      x_dgfPublicAssetCertificate
#  Select From List By Value    xpath=//select[@id="documentType"]      technicalSpecifications
  Sleep     2
  Log To Console    'Inserting document'
  Input Text    xpath=//input[@id="auction-documnet-title"]     ${ARGUMENTS[2]}
  Sleep     2
  Input Text    xpath=//input[@id="document-url"]     ${ARGUMENTS[2]}
  Sleep     2
  Click Element     xpath=//button[@ng-click="upload()"]
  Sleep     10

Додати офлайн документ
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  file_description
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
  Select From List By Value    xpath=//select[@id="documentType"]      x_dgfAssetFamiliarization
  Sleep     2
  Log To Console    'Inserting document'
  # === Mega Hack for document Upload ===
  Input Text    xpath=//input[@id="auction-documnet-title"]    ${ARGUMENTS[2]}
  Input Text    xpath=//textarea[@id="auction-documnet-accessDetails"]    ${ARGUMENTS[2]}
  Sleep     2
  # Confirm file Upload
  Click Element     xpath=//button[@ng-click="upload()"]
  Sleep     10

Завантажити документ в тендер з типом
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  ${image_path}
  ...      ${ARGUMENTS[3]} ==  document_type
  # Navigating to documents tab
  Reload Page
  Sleep     2
  Click Element     xpath=//a[@ui-sref="tenderView.documents"]
  Sleep     3
  Wait Until Page Contains Element     xpath=//button[@ng-click="uploadDocument()"]
  Click Element     xpath=//button[@ng-click="uploadDocument()"]
  # Interacting with document upload mechanism - Illustration
  Log To Console    'Interacting with documents modal window - '${ARGUMENTS[3]}''
  Wait Until Page Contains Element     xpath=//form[@name="uploadDocumentsForm"]
  Log To Console    'Specify document type'
  Select From List By Value    xpath=//select[@id="documentType"]      ${ARGUMENTS[3]}
  Sleep     2
  Log To Console    'Inserting document'
  # === Mega Hack for document Upload ===
  Execute Javascript  $('button[ng-model="file"]').click()
  Choose File         xpath=//input[@type="file"]    ${ARGUMENTS[2]}
  Sleep     2
  # Confirm file Upload
  Click Element     xpath=//button[@ng-click="upload()"]
  Sleep     10
# ======= Docs Upload ===============

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  Log To Console   Who is it_0 - ${ARGUMENTS[0]}
  Log To Console   Searching for UFOs - ${ARGUMENTS[1]}
  Switch browser   ${ARGUMENTS[0]}
  Run Keyword If   '${ARGUMENTS[0]}' == 'Newtend_Owner'   Wait Until Page Contains Element    xpath=//a[@href="#/home/?pageNum=1&query=&status=&userOnly=&procurementMethodType="]
  Run Keyword If   '${ARGUMENTS[0]}' == 'Newtend_Owner'   Click Element    xpath=//a[@href="#/home/?pageNum=1&query=&status=&userOnly=&procurementMethodType="]
  Run Keyword If   '${ARGUMENTS[0]}' != 'Newtend_Owner'   Go To     http://ea-trunk.newtend.com/provider/
  Sleep     2
  ${auction_number}=    Convert To String   ${ARGUMENTS[1]}
  Input Text        xpath=//input[@type="search"]     ${auction_number}
  Click Element     xpath=//div[@ng-click="search()"]
  Sleep     2
  Wait Until Page Contains Element   xpath=//a[@ui-sref="tenderView.overview({id: tender.id})"]   10
  Sleep     2
  Click Element                      xpath=//a[@ui-sref="tenderView.overview({id: tender.id})"]
  Sleep     2

# ====Newtend===========
Отримати кількість предметів в тендері
  [Arguments]  @{ARGUMENTS}
  Reload Page
  Sleep     2
  Wait Until Page Contains Element    xpath=//a[@ui-sref="tenderView.overview"]     20
  Click Element      xpath=//a[@ui-sref="tenderView.overview"]
  Sleep     2
  ${items_number}=   Get Matching Xpath Count    xpath=//div[@ng-bind="item.description"]
  Log To Console   Items number - '${items_number}'
  [Return]  ${items_number}

Додати предмет закупівлі
  [Arguments]   @{ARGUMENTS}
  [Documentation]
  ...     ${ARGUMENTS[0]} == username
  ...     ${ARGUMENTS[1]} == auction_uaid
  ...     ${ARGUMENTS[2]} == item_info
  Log To Console    arg-0 - ${ARGUMENTS[0]}

Видалити предмет закупівлі
  [Arguments]   @{ARGUMENTS}
  [Documentation]
  ...     ${ARGUMENTS[0]} == username
  ...     ${ARGUMENTS[1]} == auction_uaid
  ...     ${ARGUMENTS[2]} == item_id
  Log To Console    arg-0 - ${ARGUMENTS[0]}


Отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uaid
  ...      ${ARGUMENTS[2]} ==  field_name
  Run Keyword And Return  Отримати інформацію про ${ARGUMENTS[2]}

Отримати текст із поля і показати на сторінці
  [Arguments]   ${field_name}
  Sleep  2
  ${return_value}=   Get Text  ${locator.view.${field_name}}
  [Return]  ${return_value}

Отримати інформацію про title
  ${title}=   Отримати текст із поля і показати на сторінці   title
  [Return]  ${title}

Отримати інформацію про awards[0].status
  Reload Page
  Sleep     2
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]
  Sleep     2
#  Wait Until Page Contains Element      xpath=//div[@ng-repeat="bid in tenderBids"]     10
  ${status}=    Get Text    id=award-0
  ${correct_status}=    convert_nt_string_to_common_string      ${status}
  Log To Console    winner status - '${correct_status}'
  [Return]    ${correct_status}

Отримати інформацію про awards[1].status
  Reload Page
  Sleep     2
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]
  Sleep     2
#  Wait Until Page Contains Element      xpath=//div[@ng-repeat="bid in tenderBids"]     10
  ${status}=    Get Text    id=award-1
  ${correct_status}=    convert_nt_string_to_common_string      ${status}
  Log To Console    looser status - '${correct_status}'
  [Return]    ${correct_status}

Отримати інформацію про status
  Reload page
  ${return_value}=   Отримати текст із поля і показати на сторінці   status
  ${return_value}=   convert_nt_string_to_common_string     ${return_value}
  Log To Console     ${return_value}
  [Return]  ${return_value}

Отримати інформацію про description
  ${description}=   Отримати текст із поля і показати на сторінці   description
  [Return]  ${description}

Отримати інформацію про dgfDecisionID
  ${dgfDecisionID_full}=   Get Text      xpath=//div[@id="view-tender-dgfDecisionID"]
  [Return]      ${dgfDecisionID_full.split(u"№")[-1]}

Отримати інформацію про dgfID
  ${description}=   Отримати текст із поля і показати на сторінці   dgfID
  [Return]   ${description}

Отримати інформацію про dgfDecisionDate
  ${date_text}=    Get Text      xpath=//div[@id="view-tender-dgfDecisionID"]
  ${date}=    Get Substring      ${date_text}   4   14
  [Return]    ${date}

Отримати інформацію про tenderAttempts
  ${attempts_raw}=  Get Text    xpath=//div[@id="tenderAttempts"]
  ${attempts_value}=   Get Substring   ${attempts_raw}     -2    -1
  ${attempts}=   Convert To Integer     ${attempts_value}
  [Return]      ${attempts}

Отримати інформацію про auctionId
  ${auctionId}=   Отримати текст із поля і показати на сторінці   auctionId
  [Return]  ${auctionId}

Отримати інформацію про value.amount
  ${valueAmount}=   Отримати текст із поля і показати на сторінці   value.amount
  ${valueAmount}=   Convert To Number   ${valueAmount.split(' ')[0]}
  [Return]  ${valueAmount}

Отримати інформацію про minimalStep.amount
  ${minimalStepAmount}=   Отримати текст із поля і показати на сторінці   minimalStep.amount
  ${minimalStepAmount}=   Convert To Number   ${minimalStepAmount.split(' ')[0]}
  [Return]  ${minimalStepAmount}

Отримати інформацію про value.currency
  ${valueCurrency}=       Отримати текст із поля і показати на сторінці    value.currency
  ${valueCurrency}=       Get Substring     ${valueCurrency}    -4      -1
  [Return]   ${valueCurrency}

# NDS
Отримати інформацію про value.valueAddedTaxIncluded
  ${return_value}=   Отримати текст із поля і показати на сторінці   value.valueAddedTaxIncluded
  ${return_value}=   convert_nt_string_to_common_string      ${return_value}
  [Return]  ${return_value}

# Name of auction creator
Отримати інформацію про procuringEntity.name
  ${procuringEntity_name}=   Отримати текст із поля і показати на сторінці   procuringEntity.name
  Log To Console  ${procuringEntity_name}
  [Return]  ${procuringEntity_name}

Отримати інформацію про procurementMethodType
  ${type_titles}=   Get Webelements     xpath=//div[@class="title"]
  ${procurementType_text}=   Get Text   ${type_titles[-1]}
  ${procurementMethodType}=  convert_nt_string_to_common_string   ${procurementType_text}
  Log To Console  ${procurementMethodType}
  [Return]  ${procurementMethodType}

Отримати інформацію про enquiryPeriod.endDate
  ${enquiryPeriodEndDate}=   Отримати текст із поля і показати на сторінці   enquiryPeriod.endDate
  [Return]  ${enquiryPeriodEndDate}

Отримати інформацію про tenderPeriod.startDate
  ${tenderPeriodStartDate}=   Отримати текст із поля і показати на сторінці   tenderPeriod.startDate
  [Return]  ${tenderPeriodStartDate}

Отримати інформацію про tenderPeriod.endDate
  ${tenderPeriodEndDate}=   Отримати текст із поля і показати на сторінці   tenderPeriod.endDate
  Log To Console     ${tenderPeriodEndDate}
  ${return_value}=   get_time_with_offset   ${tenderPeriodEndDate}
  Log To Console     ${return_value}
  [Return]  ${return_value}

Отримати інформацію про enquiryPeriod.startDate
  ${enquiryPeriodStartDate}=   Отримати текст із поля і показати на сторінці   enquiryPeriod.StartDate
  [Return]  ${enquiryPeriodStartDate}

Отримати інформацію про items[0].description
# Відображення опису номенклатур тендера
  ${description_raw}=   Переглянути текст із поля і показати на сторінці   items[0].description
  ${description_1}=     Get Substring     ${description_raw}  0   11
  ${description_2}=     convert_nt_string_to_common_string  ${description_raw.split(': ')[-1]}
  ${description}=       Catenate  ${description_1}  ${description_2}
  [Return]  ${description}

Отримати інформацію про items[1].description
# Відображення опису номенклатур тендера
  ${description_raw}=   Переглянути текст із поля і показати на сторінці   items[1].description
  ${description_1}=     Get Substring     ${description_raw}  0   11
  ${description_2}=     convert_nt_string_to_common_string  ${description_raw.split(': ')[-1]}
  ${description}=       Catenate  ${description_1}  ${description_2}
  [Return]  ${description}

Отримати інформацію про items[2].description
# Відображення опису номенклатур тендера
  ${description_raw}=   Переглянути текст із поля і показати на сторінці   items[2].description
  ${description_1}=     Get Substring     ${description_raw}  0   11
  ${description_2}=     convert_nt_string_to_common_string  ${description_raw.split(': ')[-1]}
  ${description}=       Catenate  ${description_1}  ${description_2}
  [Return]  ${description}
# full scenario
Отримати інформацію про eligibilityCriteria
  ${eligibilityCriteria}=   Отримати текст із поля і показати на сторінці   eligibilityCriteria
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
# :TODO use near by construction to refactore all keywords that use 'Get Information From "Some agrument"'
#  Need to send Argument with 'Field name' and argument with 'Item ID'
#  Run Keyword And Return  Отримати інформацію із ${ARGUMENTS[3]}   ${ARGUMENTS[2]}


Переглянути текст із поля і показати на сторінці
  [Arguments]   ${field_name}
  Sleep  1
  ${return_value}=   Get Text  ${locator.view.${field_name}}
  [Return]  ${return_value}

Отримати інформацію із description
# :TODO - fix it, add @{arguments}, change path to Get Text
# Відображення опису номенклатур тендера
  ${description_raw}=   Get text    xpath=//div[@ng-bind="item.description"(contains(text(), '${ARGUMENTS[2]}'))]
  Log To Console    item's descritpion text - ${description_raw}
  ${description_1}=    Get Substring     ${description_raw}  0   11
  ${description_2}=    convert_nt_string_to_common_string  ${description_raw.split(': ')[-1]}
  ${description}=      Catenate  ${description_1}  ${description_2}
  [Return]  ${description}

Отримати інформацію із items[0].deliveryDate.endDate
  ${deliveryDate_endDate}=   Переглянути текст із поля і показати на сторінці   items[0].deliveryDate.endDate
  [Return]  ${deliveryDate_endDate}

Отримати інформацію про items[0].deliveryLocation.latitude
  Fail  Не реалізований функціонал

Отримати інформацію про items[0].deliveryLocation.longitude
  Fail  Не реалізований функціонал

##CAV
Отримати інформацію із classification.scheme
# :TODO - fix it, add @{arguments}, change path to Get Text
# Відображення схеми класифікації номенклатур тендера - CAV
  ${classificationScheme_newtend}=   Переглянути текст із поля і показати на сторінці   items[0].classification.scheme.title
  ${classificationScheme}=           convert_nt_string_to_common_string      ${classificationScheme_newtend}
  [Return]  ${classificationScheme}

Отримати інформацію із classification.id
  [Arguments]   @{arguments}
  [Documentation]
  ...           ${ARGUMENTS[0]} == user_role
  ...           ${ARGUMENTS[1]} == auction_id
  ...           ${ARGUMENTS[2]} == field_name   # example - items[0].classification.id
  ${classification_id}=   Переглянути текст із поля і показати на сторінці   ${ARGUMENTS[2]}
  [Return]  ${classification_id.split(' - ')[0]}

Отримати інформацію про items[0].classification.id
  ${classification_id}=   Переглянути текст із поля і показати на сторінці   items[0].classification.scheme
  [Return]  ${classification_id.split(' - ')[0]}

Отримати інформацію про items[1].classification.id
  ${classification_id}=   Переглянути текст із поля і показати на сторінці   items[1].classification.scheme
  [Return]  ${classification_id.split(' - ')[0]}

Отримати інформацію про items[2].classification.id
  ${classification_id}=   Переглянути текст із поля і показати на сторінці   items[2].classification.scheme
  [Return]  ${classification_id.split(' - ')[0]}

Отримати інформацію із classification.description
#  Відображення опису класифікації номенклатур тендера
  [Arguments]   @{arguments}
  [Documentation]
  ...           ${ARGUMENTS[0]} == user_role
  ...           ${ARGUMENTS[1]} == auction_id
  ...           ${ARGUMENTS[2]} == field_name   # example - items[0].classification.description
  ${classification_description_raw}=   Get Webelement     xpath=//div[contains(text(), '${ARGUMENTS[1]}')]
  ${classification_description}=       Get Text           ${classification_description_raw}
  ${classification_description}=       Get Substring      ${classification_description_raw}     13
  [Return]      ${classification_description}

Отримати інформацію про items[0].classification.description
#  Відображення опису класифікації номенклатур тендера
  ${classification_description_raw}=   Переглянути текст із поля і показати на сторінці   items[0].classification.scheme
  ${classification_description}=       Get Substring      ${classification_description_raw}     13
  [Return]      ${classification_description}

Отримати інформацію про items[1].classification.description
#  Відображення опису класифікації номенклатур тендера
  ${classification_description_raw}=   Переглянути текст із поля і показати на сторінці   items[1].classification.scheme
  ${classification_description}=       Get Substring      ${classification_description_raw}     13
  [Return]      ${classification_description}

Отримати інформацію про items[2].classification.description
#  Відображення опису класифікації номенклатур тендера
  ${classification_description_raw}=   Переглянути текст із поля і показати на сторінці   items[2].classification.scheme
  ${classification_description}=       Get Substring      ${classification_description_raw}     13
  [Return]      ${classification_description}

##item
# :TODO - Refactor code using @{arguments}
# --- see line 593 - Get Data from 'some argument'
Отримати інформацію із unit.name
# :TODO - fix it, add @{arguments}, change path to Get Text
  ${unit_name}=   Get Text      xpath=//div[contains(., '${item_id}')]//span[@class="unit ng-binding"]
#  ${unit_name}=   Переглянути текст із поля і показати на сторінці   items[${ARGUMENTS[2]}].unit.name
  Log To Console    unit name - ${unit_name}
#  Run Keyword And Return If  '${unit_name}' == 'килограммы'   Convert To String   кілограм
  [Return]  ${unit_name}

Отримати інформацію про items[0].unit.name
  ${units}=     Get Webelements     xpath=//span[@class="unit ng-binding"]
  ${unit_name}=     Get Text    ${units[0]}
  Log To Console    unit namesss - ${unit_name}
  [Return]  ${unit_name}

Отримати інформацію про items[1].unit.name
  ${units}=     Get Webelements     xpath=//span[@class="unit ng-binding"]
  ${unit_name}=     Get Text    ${units[1]}
  Log To Console    unit namesss - ${unit_name}
  [Return]  ${unit_name}

Отримати інформацію про items[2].unit.name
  ${units}=     Get Webelements     xpath=//span[@class="unit ng-binding"]
  ${unit_name}=     Get Text    ${units[2]}
  Log To Console    unit namesss - ${unit_name}
  [Return]  ${unit_name}

Отримати інформацію про unit.code
  Fail  Не реалізований функціонал

Отримати інформацію про items[0].unit.code
  Fail  Не реалізований функціонал

Отримати інформацію про items[1].unit.code
  Fail  Не реалізований функціонал

Отримати інформацію із unit.code
  Fail  Не реалізований функціонал

Отримати інформацію із quantity
  [Arguments]   @{Arguments}
  [Documentation]
  ...           ${ARGUMENTS[0]} == user_role
  ...           ${ARGUMENTS[1]} == auction_id
  ...           ${ARGUMENTS[2]} == field_name   # example - items[0].quantity
  ${quantity}=   Переглянути текст із поля і показати на сторінці   ${ARGUMENTS[2]}
  ${quantity}=   Convert To Integer   ${quantity}
  [Return]  ${quantity}

Отримати інформацію про items[0].quantity
  ${quantity}=   Переглянути текст із поля і показати на сторінці   items[0].quantity
  ${quantity}=   Convert To Integer   ${quantity}
  [Return]  ${quantity}

Отримати інформацію про items[1].quantity
  ${quantity}=   Переглянути текст із поля і показати на сторінці   items[1].quantity
  ${quantity}=   Convert To Integer   ${quantity}
  [Return]  ${quantity}

Отримати інформацію про items[2].quantity
  ${quantity}=   Переглянути текст із поля і показати на сторінці   items[2].quantity
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
  newtend.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Click Element                      xpath=//a[@ui-sref="tenderView.chat"]
  Wait Until Page Contains Element   xpath=//button[@ng-click="askQuestion()"]   20
  Click Element                      xpath=//button[@ng-click="askQuestion()"]
  Input Text      xpath=//input[@ng-model="chatData.title"]   ${title}
  Input Text      xpath=//textarea[@ng-model="chatData.message"]   ${description}
  Sleep     2
  Click Element   xpath=//button[@ng-click="sendQuestion()"]
  : FOR   ${INDEX}  IN RANGE    1   15
  \   Log To Console   .   no_newline=true      # Provided by Victor Belostenni
  \   Sleep     10
  \   Reload Page
  \   ${text}=   Get Matching Xpath Count   xpath=//div[@ng-repeat="question in questions"]
  \   Exit For Loop If  '${text}' > '0'
  Wait Until Page Contains    ${description}   20

Задати запитання на тендер
  [Arguments]   @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} = question_data
  ${title}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=  Get From Dictionary  ${ARGUMENTS[2].data}  description
  newtend.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Click Element                      xpath=//a[@ui-sref="tenderView.chat"]
  Wait Until Page Contains Element   xpath=//button[@ng-click="askQuestion()"]   20
  Click Element                      xpath=//button[@ng-click="askQuestion()"]
  Wait Until Page Contains Element   xpath=//input[@ng-model="chatData.title"]   10
  Input Text      xpath=//input[@ng-model="chatData.title"]   ${title}
  Sleep     2
  Select From List By Label  xpath=//select[@name="questionOf"]   Auction
  Input Text      xpath=//textarea[@ng-model="chatData.message"]   ${description}
  Click Element   xpath=//button[@ng-click="sendQuestion()"]
  Sleep     5
  : FOR   ${INDEX}  IN RANGE    1   15
  \   Log To Console   .   no_newline=true
  \   Sleep     10
  \   Reload Page
  \   ${text}=   Get Matching Xpath Count   xpath=//div[@ng-repeat="question in questions"]
  \   Exit For Loop If  '${text}' > '0'
  Wait Until Page Contains    ${description}   20

Задати запитання на предмет
  [Arguments]   @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} = item_id
  ...      ${ARGUMENTS[3]} = question_data
  ${title}=        Get From Dictionary  ${ARGUMENTS[3].data}  title
  ${description}=  Get From Dictionary  ${ARGUMENTS[3].data}  description
  newtend.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Click Element                      xpath=//a[@ui-sref="tenderView.chat"]
  Wait Until Page Contains Element   xpath=//button[@ng-click="askQuestion()"]   20
  Click Element                      xpath=//button[@ng-click="askQuestion()"]
  Sleep     2
  Input Text      xpath=//input[@ng-model="chatData.title"]   ${title}
  Sleep     2
  Select From List By Label  xpath=//select[@name="questionOf"]    Предмет аукциона
  Sleep     2
  ${item_name}=     Get text    xpath=//option[contains(text(), '${ARGUMENTS[2]}')]
  Log To Console    '${item_name}'
  Select From List By Label  xpath=//select[@name="relatedItem"]   ${item_name}
  Input Text      xpath=//textarea[@ng-model="chatData.message"]   ${description}
  Click Element   xpath=//button[@ng-click="sendQuestion()"]
  : FOR   ${INDEX}  IN RANGE    1   15
  \   Log To Console   .   no_newline=true
  \   Sleep     15
  \   Reload Page
  \   ${text}=   Get Matching Xpath Count   xpath=//div[@ng-repeat="question in questions"]
  \   Exit For Loop If  '${text}' > '1'
  Wait Until Page Contains    ${description}   20

Оновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} == username
  ...      ${ARGUMENTS[1]} == ${TENDER_UAID}
  Reload Page

Отримати кількість документів в тендері
  [Arguments]   @{ARGUMENTS}
  Log To Console    arg-0 - ${ARGUMENTS[0]}
  Reload Page
  Sleep     2
  Run Keyword If   '${ARGUMENTS[0]}' != 'Newtend_Viewer'     Wait Until Page Contains      xpath=//a[@ui-sref="tenderView.overview"]
  Click Element     xpath=//a[@ui-sref="tenderView.overview"]
  Sleep     2
  ${docs_amount}=   Get Matching Xpath Count    xpath=//div[@ng-repeat="document in documentsSection | versionFilter | orderBy:'-dateModified'"]
  Log To Console    Docs amount - ${docs_amount}
  [Return]      ${docs_amount}

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
  Run Keyword And Return  Отримати інформацію про Questions.${ARGUMENTS[3]}  ${ARGUMENTS[2]}

Отримати інформацію про Questions.answer
  [Arguments]   @{ARGUMENTS}
  [Documentation]
  ...       ${ARGUMENTS[0]} == item_id
  Log to console    arg-0 - ${ARGUMENTS[0]}
  Reload Page
  Sleep     2
  Wait Until Page Contains Element   xpath=//a[@ui-sref="tenderView.chat"]   20
  Click Element              xpath=//a[@ui-sref="tenderView.chat"]
  Sleep     10
  Reload Page
  Sleep     10
  ${title}=     Get Webelement     xpath=//div[@ng-repeat="question in questions"][contains(., '${ARGUMENTS[0]}')]//span[@class="answer-description ng-binding"]
  ${resp}=   Get Text   ${title}
  [Return]  ${resp}

Отримати інформацію про Questions.title
  [Arguments]    @{arguments}
  Reload Page
  Wait Until Page Contains Element   xpath=//a[@ui-sref="tenderView.chat"]   20
  Click Element              xpath=//a[@ui-sref="tenderView.chat"]
  Sleep     2
  Reload Page
  Sleep     2
  ${title}=     Get Webelement     xpath=//span[contains(text(), '${ARGUMENTS[2]}')]
  ${resp}=   Get Text   ${title}
  [Return]  ${resp}

Отримати інформацію про Questions.description
  [Arguments]    @{arguments}
  Sleep     2
  ${title_description}=     Get Webelement     xpath=//div[@class="col-xs-10 col-sm-10"][contains(., '${ARGUMENTS[2]}')]
  ${description}=   Get Text   ${title_description}
  [Return]  ${description.split(': ')[-1]}

Отримати інформацію про Questions[0].title
  Reload Page
  Wait Until Page Contains Element   xpath=//a[@ui-sref="tenderView.chat"]   20
  Click Element              xpath=//a[@ui-sref="tenderView.chat"]
  Sleep     2
  Reload Page
  Sleep     2
  ${title_description}=     Get Webelements     xpath=//span[@class="user ng-binding"]
  ${title}=     Get Text    ${title_description[0]}
  [Return]  ${title}

Отримати інформацію про Questions[0].description
  Reload Page
  Wait Until Page Contains Element   xpath=//a[@ui-sref="tenderView.chat"]   20
  Click Element              xpath=//a[@ui-sref="tenderView.chat"]
  Sleep     2
  Reload Page
  Sleep     2
  ${question_description}=     Get Webelements  xpath=//span[@class="question-description ng-binding"]
  ${description}=   Get Text    ${question_description[0]}
  [Return]  ${description}

Отримати інформацію про Questions[1].title
  Reload Page
  Wait Until Page Contains Element   xpath=//a[@ui-sref="tenderView.chat"]   20
  Click Element              xpath=//a[@ui-sref="tenderView.chat"]
  Sleep     2
  Reload Page
  Sleep     2
  ${title}=     Get Webelements     xpath=//span[@class="user ng-binding"]
  ${resp}=   Get Text   ${title[1]}
  [Return]  ${resp}

Отримати інформацію про Questions[1].description
  ${description}=   Get Webelements     xpath=//span[@class="question-description ng-binding"]
  ${resp}=   Get Text   ${description[1]}
  Log To Console    ${resp}
  [Return]  ${resp}

Отримати інформацію про Questions[2].title
  Reload Page
  Wait Until Page Contains Element   xpath=//a[@ui-sref="tenderView.chat"]   20
  Click Element              xpath=//a[@ui-sref="tenderView.chat"]
  Sleep     2
  Reload Page
  Sleep     2
  ${title}=     Get Webelements     xpath=//span[@class="user ng-binding"]
  ${resp}=   Get Text   ${title[2]}
  Log To Console    ${resp}
  [Return]  ${resp}

Отримати інформацію про Questions[2].description
  ${description}=   Get Webelements     xpath=//span[@class="question-description ng-binding"]
  ${resp}=   Get Text   ${description[2]}
  Log To Console    ${resp}
  [Return]  ${resp}

Отримати інформацію про Questions[3].title
  Reload Page
  Wait Until Page Contains Element   xpath=//a[@ui-sref="tenderView.chat"]   20
  Click Element              xpath=//a[@ui-sref="tenderView.chat"]
  Sleep     2
  Reload Page
  Sleep     2
  ${title}=     Get Webelements     xpath=//span[@class="user ng-binding"]
  ${resp}=   Get Text   ${title[3]}
  Log To Console    ${resp}
  [Return]  ${resp}

Отримати інформацію про Questions[3].description
  ${description}=   Get Webelements     xpath=//span[@class="question-description ng-binding"]
  ${resp}=   Get Text   ${description[3]}
  Log To Console    ${resp}
  [Return]  ${resp}

Відповісти на запитання
   [Arguments]      @{ARGUMENTS}
   [Documentation]
   ...      ${ARGUMENTS[0]} == username
   ...      ${ARGUMENTS[1]} == ${tender_uaid}
   ...      ${ARGUMENTS[2]} == ${item_index} # smth strange
   ...      ${ARGUMENTS[3]} == ${answer_id}
   Sleep    40
   Reload Page
   ${answer}=     Get From Dictionary   ${ARGUMENTS[2].data}  answer
   Click Element        xpath=//a[@ui-sref="tenderView.chat"]
   Sleep    3
   # Try to answer - try to find correct xpath for answering Round ((
   ${answer_row}=   Get Webelement   xpath=//div[@class="col-xs-10 col-sm-10"][contains(., '${ARGUMENTS[3]}')]
   Log To Console   ${answer_row}
   Mouse Over       ${answer_row}    # should show answer btn
   Sleep    1
   ${answer_round}=     Get Webelement     xpath=//div[@class="answer mouseenter"]  # Interacting with answer btn
   Sleep    1
   Click Element    ${answer_round}
   Sleep    2
   Input Text       xpath=//textarea[@ng-model="chatData.message"]   ${answer}
   Click Element    xpath=//button[@ng-click="sendAnswer()"]
   Sleep    2

Отримати інформацію із документа по індексу
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...       ${ARGUMENTS[0]} ==  user_role
  ...       ${ARGUMENTS[1]} ==  auction_id
  ...       ${ARGUMENTS[2]} ==  index
  ${documents}=     Get Webelements     xpath=//div[@class="type bold ng-scope"]
  ${document_type}=     Get Text    ${documents[${ARGUMENTS[2]}]}
  ${description}=   convert to string    ${document_type.split(' / ')[-1]}
  Run Keyword And Return If   u'${description}' == u'Юридична Інформація Майданчиків'   convert_nt_string_to_common_string   ${description}
  Log To Console    doc text = ${document_type}
  Log To Console    doc type = ${description}
  [Return]      ${document_type}

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
  Run Keyword If      'Можливість' in '${TEST NAME}'    Click Element       xpath=//input[@name="bid-valid"]      # Validation of bid
  Click Element       xpath=//button[@ng-click="placeBid()"]
  Sleep     3
  Reload Page
  Wait Until Page Contains Element      xpath=//div[@class="bid-placed make-bid ng-scope"]
  Sleep     2
  Run Keyword If      'Неможливість' in '${TEST NAME}'    Reload Page
  Run Keyword If      'Неможливість' in '${TEST NAME}'    Wait Until Page Contains Element    xpath=//div[@class="alert alert-warning ng-binding ng-scope"]
  ${alert}=     Run Keyword If      'Неможливість' in '${TEST NAME}'    Get Matching Xpath Count    xpath=//div[@class="alert alert-warning ng-binding ng-scope"]
  Run Keyword If      'Неможливість' in '${TEST NAME}'    Click Element   xpath=//a[@ng-click="cancelBid()"]
  Sleep     2
  Run Keyword If      'Неможливість' in '${TEST NAME}'    Wait Until Page Contains Element   xpath=//button[@ng-click="cancelBid()"]
  Run Keyword If      'Неможливість' in '${TEST NAME}'    Click Element   xpath=//button[@ng-click="cancelBid()"]
  ${resp}=      Run Keyword If   'Неможливість' in '${TEST NAME}'    Run Keyword If   '${alert}' == '1'    '${False}'
  ${resp}=      Run Keyword If   'Можливість' in '${TEST NAME}'   Get text    xpath=//h3[@class="ng-binding"]
  Log To Console    response - ${resp}
  [Return]     ${resp}

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
  Sleep     2
  Reload Page
  Sleep     5
  ${value_raw}=     Get Text   xpath=//h3[@class="ng-binding"]
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

Завантажити фінансову ліцензію
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[0]} ==  file
  ...    ${ARGUMENTS[1]} ==  tenderId
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
  Sleep     2
  Click Element       xpath=//button[@ng-click="upload()"]
  Sleep     10

Завантажити документ в ставку
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[1]} ==  file
  ...    ${ARGUMENTS[2]} ==  tenderId
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

Змінити документ в ставці
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[1]} ==  file
  ...    ${ARGUMENTS[2]} ==  tenderId
  Click Element       xpath=//a[@ui-sref="tenderView.documents"]
  Wait Until Page Contains Element    xpath=//button[@ng-click="uploadDocument()"]
  ${replaces}=      Get Webelements     xpath=//a[@ng-model="$parent.$parent.replaceFiles"]
  Execute Javascript     ${replaces[1]}.click()
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
  Sleep     2
  # Waiting for auction viewer link
  : FOR   ${INDEX}   IN RANGE    1    50
  \   reload page
  \   Log To Console   y-   no_newline=true
  \   sleep     40
  \   ${count}=   Get Matching Xpath Count   xpath=//a[@class="auction-link ng-binding"]
  \   ${link}=    Get Element Attribute      xpath=//a[@target="_blank"]@href
  \   Exit For Loop If   '${count}' > '0' and '${link}' != 'None'
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
  Sleep     3
  # Waiting for auction participant link
  : FOR   ${INDEX}   IN RANGE    1    50
  \   reload page
  \   Log To Console   -x   no_newline=true
  \   sleep     40
  \   ${count}=   Get Matching Xpath Count   xpath=//a[@class="auction-link ng-binding"]
  \   ${link}=    Get Element Attribute      xpath=//a[@target="_blank"]@href
  \   Exit For Loop If   '${count}' > '1' and '${link}' != 'None'
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
  ${return_value}=   Отримати текст із поля і показати на сторінці  auctionPeriod.startDate
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
  Run Keyword If    '${TEST NAME}' == 'Можливість підтвердити оплату першого кандидата'   Click Element  xpath=//div[@class="col-xs-4 status ng-binding pending-payment"]
  Run Keyword If    '${TEST NAME}' == 'Можливість підтвердити оплату другого кандидата'   Click Element  xpath=//div[@class="col-xs-4 status ng-binding pending-payment"]
#  Run Keyword If    '${TEST NAME}' != 'Можливість підтвердити оплату першого кандидата'   Click Element  xpath=//div[@class="col-xs-4 status ng-binding pending-verification"]  # old design
#  Run Keyword If    '${TEST NAME}' != 'Можливість підтвердити оплату другого кандидата'   Click Element  xpath=//div[@class="col-xs-4 status ng-binding pending-verification"]  # old design
  Sleep     2
  Focus          xpath=//button[@ng-click="decide('active')"]
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
  # Need to find all the documents in the bid
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]}  ==  username
  ...      ${ARGUMENTS[1]}  ==  auction_uaid
  ...      ${ARGUMENTS[2]}  ==  docs_number - 0
  Sleep     60
  # Docs count inside the bid awaiting for Accept
  Reload Page
  Wait Until Page Contains Element      xpath=//a[@ui-sref="tenderView.auction"]    10
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]
  Wait Until Page Contains Element      xpath=//div[@class="col-xs-4 status ng-binding pending"]    10
  Click Element     xpath=//div[@class="col-xs-4 status ng-binding pending"]
  Sleep     60
  ${docs_number}=    Get Matching Xpath Count     xpath=//div[@class="type ng-binding"][contains(text(), 'Auction protocol')]
  Log To Console    Number of docs - '${docs_number}'
  [Return]   ${docs_number}

Отримати дані із документу пропозиції
  [Arguments]  ${username}  ${tender_uaid}  ${bid_index}  ${document_index}  ${field}
  ${doc_title}=     Get WebElements    xpath=//div[contains(text(), 'Auction protocol')]
  ${title}=         Run Keyword If     '${doc_title}' > '0'     Convert To String   auctionProtocol
  Log To Console    ${title}
  [Return]  ${title}

Скасування рішення кваліфікаційної комісії
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]}  ==  username
  ...      ${ARGUMENTS[1]}  ==  auction_uaid
  ...      ${ARGUMENTS[2]}  ==  docs_number - 0
  log to console  arg-0 - '${ARGUMENTS[0]}'
  log to console  arg-1 - '${ARGUMENTS[1]}'
  log to console  arg-2 - '${ARGUMENTS[2]}'
# Mooving inside accepted winner to make him PAIN!!!
  Sleep     2
  Click Element  xpath=//a[@ui-sref="tenderView.auction"]
  Reload Page
  Sleep     2
  Click Element     xpath=//div[@class="col-xs-4 status ng-binding active"]
  Sleep     2
  Wait Until Page Contains Element      xpath=//button[@ng-click="decide('unsuccessful')"]
  Click Element     xpath=//button[@ng-click="decide('unsuccessful')"]
  Sleep     2
  Wait Until Page Contains Element      xpath=//button[@ng-click="disapprove()"]
  Click Element     xpath=//button[@ng-click="disapprove()"]
  Sleep     2
  Log To Console    'Winner - rejected'

# Winner rejection totally - 1
Завантажити документ рішення кваліфікаційної комісії
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]}  ==  user_name
  ...      ${ARGUMENTS[1]}  ==  file_path
  ...      ${ARGUMENTS[2]}  ==  auction_uaid
  Run Keyword If    'дискваліфікувати' in '${TEST_NAME}'   Rejection Protocol
  Run Keyword If    'дискваліфікувати' in '${TEST_NAME}'   Execute Javascript  $('button[ng-file-select=""]').click()
  Run Keyword If    'дискваліфікувати' in '${TEST_NAME}'   Choose File    xpath=//input[@type="file"]    ${ARGUMENTS[1]}
  Run Keyword If   'Можливість завантажити' in '${TEST_NAME}'    Accept Protocol
  Run Keyword If   'Можливість завантажити' in '${TEST_NAME}'    Execute Javascript  $('button[ng-file-select=""]').click()
  Run Keyword If   'Можливість завантажити' in '${TEST_NAME}'    Choose File    xpath=//input[@type="file"]    ${ARGUMENTS[1]}


Rejection Protocol
  Reload Page
  Sleep     2
  Click Element  xpath=//a[@ui-sref="tenderView.auction"]
  Sleep     2
  Click Element  xpath=//div[@class="col-xs-4 status ng-binding pending"]
  Sleep     2
  # Operate for pop-up window
  Wait Until Page Contains Element   xpath=//button[@ng-click="decide('unsuccessful')"]
  ${btns}=  Get Webelements   xpath=//button[@ng-click="decide('unsuccessful')"]
  Log To Console    ${btns}
  Click Element    ${btns[-1]}

Accept Protocol
  Reload Page
  Sleep     2
  Click Element  xpath=//a[@ui-sref="tenderView.auction"]
  Sleep     2
  Click Element  xpath=//div[@class="col-xs-4 status ng-binding pending"]
  Sleep     2
  Click Element  xpath=//button[@ng-click="decide('active')"]

# Winner rejection totally - 2
Дискваліфікувати постачальника
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]}  ==  user_name
  ...      ${ARGUMENTS[1]}  ==  file_path
  ...      ${ARGUMENTS[2]}  ==  auction_uaid
  # Total Rejection We take part of test from Upload decision KeyWord.
  Sleep     2
  # Confirm looser
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]
  Sleep     2
#  ${active_participants}=    Get Webelements    xpath=//div[@class="col-xs-4 status ng-binding active"]
#  Run Keyword If    '${active_participants}' > '0'    Click Element     xpath=//div[@class="col-xs-4 status ng-binding active"]
  ${waiting_active}=    Get Webelements     xpath=//div[@class="col-xs-4 status ng-binding pending-verification"]
  Run Keyword If     '${waiting_active}' > '0'       Click Element     xpath=//div[@class="col-xs-4 status ng-binding pending-verification"]  # Old design
  Sleep     2
#  Wait Until Page Contains Element   xpath=//button[@ng-click="disapprove()"]
  Wait Until Page Contains Element   xpath=//button[@ng-click="decide('unsuccessful')"]     # new design
  Click Element     xpath=//button[@ng-click="decide('unsuccessful')"]      # new design
  Sleep     2
  Click Element     xpath=//button[@ng-click="disapprove()"]
  Sleep     2
  Log To Console    Looser will stay alive


Завантажити угоду до тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]}  ==  user_name
  ...      ${ARGUMENTS[1]}  ==  auction_uaid
  ...      ${ARGUMENTS[2]}  ==  some_number -1
  ...      ${ARGUMENTS[3]}  ==  file_path
  Sleep     2
  Click Element  xpath=//a[@ui-sref="tenderView.auction"]
  Sleep     2
  Wait Until Page Contains Element  xpath=//button[@ng-click="upload.uploadContract(lot.awardId, lot.contractId)"]
  Click Element  xpath=//button[@ng-click="upload.uploadContract(lot.awardId, lot.contractId)"]
  Sleep     2
  Wait Until Page Contains Element  xpath=//button[@ng-file-select=""]
  Execute Javascript  $('button[ng-file-select=""]').click()
  Choose File    xpath=//input[@type="file"]    ${ARGUMENTS[3]}
  Select From List By Value    xpath=//select[@id="documentType"]      contractSigned
  Sleep     2
  Click Element     xpath=//button[@ng-click="upload()"]
  Sleep     15
  Reload Page
  Sleep     2

Завантажити протокол аукціону
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]}  ==  user_name
  ...      ${ARGUMENTS[1]}  ==  auction_uaid
  ...      ${ARGUMENTS[2]}  ==  file_path
  ...      ${ARGUMENTS[3]}  ==  docs_number
  Run Keyword If    '${ARGUMENTS[0]}' != 'Newtend_Viewer'   Click Element    xpath=//a[@href="/"]
  Run Keyword If    '${ARGUMENTS[0]}' == 'Newtend_Viewer'   Go To    http://ea-trunk.newtend.com/provider/
  Sleep     2
  ${auction_number}=    Convert To String   ${ARGUMENTS[1]}
  Input Text        xpath=//input[@type="search"]     ${auction_number}
  Click Element     xpath=//div[@ng-click="search()"]
  Sleep     2
  Wait Until Page Contains Element   xpath=//a[@ui-sref="tenderView.overview({id: tender.id})"]   10
  Sleep     2
  Click Element                      xpath=//a[@ui-sref="tenderView.overview({id: tender.id})"]
  Sleep     5
  Click Element     xpath=//a[@ui-sref="tenderView.documents"]
  Sleep     2
  Wait Until Page Contains Element      xpath=//button[@ng-click="uploadDocument()"]
  Click Element     xpath=//button[@ng-click="uploadDocument()"]
  Sleep     2
  Select From List By Value     xpath=//select[@id="documentOf"]   tender
  Sleep     2
  Select From List By Value     xpath=//select[@id="documentType"]   auctionProtocol
  Sleep     2
  Wait Until Page Contains Element  xpath=//button[@ng-file-select=""]  10
  Execute Javascript  $('button[ng-file-select=""]').click()
  Sleep     2
  Choose File    xpath=//input[@type="file"]    ${ARGUMENTS[2]}
  Sleep     5
  Click Element     xpath=//button[@ng-click="upload()"]
  Sleep     60
  Reload Page
  Sleep     3

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
  Select From List By Value    xpath=//select[@id="cancel-reason"]   ${ARGUMENTS[2]}
  # Document attach
  # Mega Hack for documents Upload
  Execute Javascript  $('span[class="attach-title ng-binding"]').click()
  Sleep     3
  Choose File       xpath=//input[@type="file"]    ${ARGUMENTS[3]}
  Sleep     3
  Input Text        xpath=//textarea[@id="document-description"]    ${ARGUMENTS[4]}
  Sleep     2
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
  ${return_value}=   Отримати текст із поля і показати на сторінці  cancellations[0].status
  ${return_value}=   convert_Nt_String_To_Common_String     ${return_value}
  Log To Console     Auction data - ${return_value}
  [Return]      ${return_value}


Отримати інформацію про cancellations[0].reason
  ${raw_text}=      Get Webelements     xpath=//div[@class="col-xs-9 ng-binding"]
  ${text}=          Get Text         ${raw_text[-1]}
  Log To Console    ${text}
  [Return]          ${text}

Отримати інформацію із документа    # Document Title
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...       ${ARGUMENTS[0]} == username
  ...       ${ARGUMENTS[1]} == auction_uaid
  ...       ${ARGUMENTS[2]} == doc_id
  ...       ${ARGUMENTS[3]} == field
  # ${username}  ${tender_uaid}  ${doc_id}  ${field}
  Run Keyword If   '${ARGUMENTS[0]}' != 'Newtend_Viewer'    Click Element     xpath=//a[@ui-sref="tenderView.documents"]
  Sleep     3
  Run Keyword If   '${ARGUMENTS[0]}' != 'Newtend_Viewer'    Wait Until Page Contains Element   xpath=//a[@class="ng-binding"]
  Sleep     2
  Run Keyword And Return If    '${ARGUMENTS[3]}' == 'title'    Get Text   xpath=//a[contains(text(), '${ARGUMENTS[2]}')]
  Run Keyword And Return If    '${ARGUMENTS[3]}' == 'description'   Get Text   xpath=//div[contains(., '${ARGUMENTS[2]}')]//div[@class="description ng-binding"]
  [Return]

Отримати документ
  [Arguments]  ${username}  ${tender_uaid}  ${doc_id}
  ${file_name}=   Get Text   xpath=//a[contains(text(), '${doc_id}')]
  Log To Console    file name - ${file_name}
  ${url}=   Get Element Attribute   xpath=//a[contains(text(), '${doc_id}')]@href
  Log To Console   URL - ${url}
  download_file   ${url}  ${file_name}  ${OUTPUT_DIR}
  [Return]  ${file_name}

# ========== Auction Cancellation ============
# === New Awarding process words ===
# === Tender owner ===
Завантажити протокол аукціону в авард
  [Arguments]   @{ARGUMENTS}
  [Documentation]
  ...       ${ARGUMENTS[0]} == username
  ...       ${ARGUMENTS[1]} == auction_uaid
  ...       ${ARGUMENTS[2]} == auction_protocol_path
  # Navigate to trades tab
  log to console  arg0 - '${ARGUMENTS[0]}'
  log to console  arg1 - '${ARGUMENTS[1]}'
  log to console  arg2 - '${ARGUMENTS[2]}'
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]
  Sleep     2
  Wait Until Page Contains Element     xpath=//div[@class="col-xs-4 status ng-binding pending-verification"]
  Click Element     xpath=//div[@class="col-xs-4 status ng-binding pending-verification"]
  Sleep     2
  Click Element     xpath=//button[@ng-click="finishVerification(bidAward, tender)"]
  Focus             xpath=//div[@class="bids-modal ng-scope"]
  Wait Until Page Contains Element   xpath=//div[@ng-file-select=""]  10
  Execute Javascript    $('span[class="attach-title ng-binding"]').click()
  Sleep     2
  Choose File       xpath=//input[@type="file"]    ${ARGUMENTS[2]}
  Sleep     5
  Click Element     xpath=//button[@ng-click="vm.setAwardVerified(vm.files[0], vm.award, vm.tender)"]
  Sleep     30


Підтвердити наявність протоколу аукціону
  [Arguments]   @{ARGUMENTS}
  [Documentation]
  ...       ${ARGUMENTS[0]} == auction_uaid
  ...       ${ARGUMENTS[1]} == index
  Log To Console    arg0 - '${ARGUMENTS[0]}'
  Log To Console    arg1 - '${ARGUMENTS[1]}'
  Log To Console    'it's ok'
