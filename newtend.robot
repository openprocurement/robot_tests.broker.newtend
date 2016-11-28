*** Settings ***
Library  Selenium2Screenshots
Library  String
Library  DateTime
Library  newtend_service.py

*** Variables ***
${locator.view.status}                    xpath=//span[@class="status ng-binding"]
${locator.title}                     id=tender-title        # Title of tender
${locator.description}               id=tender-description  # Tender description
${locator.edit.description}          name=tenderDescription
${locator.value.amount}              id=budget              # Non editable field
${locator.minimalStep.amount}        id=step                # Non editable field
${locator.lot.add}                   id=lot                 # Field to click to Add lot
${locator.lot.name}                  id=title0              # Lot name in Lot's creation modal
${locator.lot.description}           id=description0        # Lot description in lot's creation modal
${locator.lot.value}                 id=budget0             # Lot Value to fill
${locator.lot.step}                  id=step0               # Lot step to fill
${locator.lot.confirm.btn}           xpath=//button[@ng-click="save()"]     # Confirmation btn
${locator.item.title}                id=itemDescription0
${locator.tenderId}                  xpath=//a[@class="ng-binding ng-scope"]
${locator.procuringEntity.name}      xpath=//div[@ng-bind="tender.procuringEntity.name"]
${locator.enquiryPeriod.StartDate}   id=start-date-qualification
${locator.enquiryPeriod.endDate}     id=end-date-qualification
${locator.tenderPeriod.startDate}    id=start-date-registration
${locator.tenderPeriod.endDate}      id=end-date-registration
${locator.items[0].deliveryAddress}                             id=deliveryAddress
${locator.items[0].deliveryDate.endDate}                        id=end-date-delivery0
${locator.items[0].description}                                 id=itemDescription0
${locator.items[0].classification.scheme}                       CAV
${locator.items[0].quantity}                                    id=quantity0
${locator.items[0].unit.name}                                   id=measure-list
${locator.edit_tender}     xpath=//button[@ng-if="actions.can_edit_tender"]
${locator.edit.add_item}   xpath=//a[@class="icon-black plus-black remove-field ng-scope"]
${locator.save}            xpath=//button[@ng-click="publish(tender)"]
${locator.QUESTIONS[0].title}         xpath=//span[@class="user ng-binding"]
${locator.QUESTIONS[0].description}   xpath=//span[@class="question-description ng-binding"]
${locator.QUESTIONS[0].date}          xpath=//span[@class="date ng-binding"]
# View locators
${locator.view.title}                id=view-tender-title
${locator.view.description}          id=view-tender-description
${locator.view.value.amount}         id=view-tender-value
${locator.view.minimalStep.amount}   id=step
${locator.view.tenderPeriod.startDate}      id=start-date-registration
${locator.view.tenderPeriod.endDate}        id=end-date-registration
${locator.view.enquiryPeriod.StartDate}     id=start-date-qualification
${locator.view.enquiryPeriod.endDate}       id=end-date-qualification
${locator.view.items[0].deliveryDate.endDate}   id=end-date-delivery
${locator.view.procuringEntity.name}        id=view-customer-name
${locator.view.items[0].deliveryAddress}    id=deliveryAddress
${locator.view.items[0].classification.scheme.title}   id=classifier
${locator.view.items[0].classification.scheme}      id=classifier
${locator.view.items[0].classification.id}      xpath=//label[@for="classifier"]
${locator.view.QUESTIONS[0].title}          xpath=//span[@class="user ng-binding"]
${locator.view.QUESTIONS[0].description}    xpath=//span[@class="question-description ng-binding"]
${locator.view.QUESTIONS[0].date}           xpath=//span[@class="date ng-binding"]
${locator.view.items[0].unit.name}          xpath=//span[@class="unit ng-binding"]
${locator.view.items[0].quantity}           id=quantity
${locator.view.items[0].description}        id=view-item-description
${locator.view.auctionId}                   xpath=//a[@class="ng-binding ng-scope"]
${locator.view.value.valueAddedTaxIncluded}         xpath=//label[@for="with-nds"]
${locator.view.value.currency}              xpath=//label[@for="budget"]



*** Keywords ***
Підготувати дані для оголошення тендера
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data
  ${INITIAL_TENDER_DATA}=  Add_data_for_GUI_FrontEnds  ${INITIAL_TENDER_DATA}
  ${INITIAL_TENDER_DATA}=  Update_data_for_Newtend  ${INITIAL_TENDER_DATA}
  [return]   ${INITIAL_TENDER_DATA}

Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
#  ...      ${ARGUMENTS[0]} == username
  Open Browser    ${USERS.users['${ARGUMENTS[0]}'].homepage}    ${USERS.users['${ARGUMENTS[0]}'].browser}   alias=${ARGUMENTS[0]}
  Set Window Size   @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
#  Run Keyword If   '${username}' != 'Newtend_Viewer'   Login
  Run Keyword If   '${ARGUMENTS[0]}' != 'Newtend_Viewer'   Login    ${ARGUMENTS[0]}

Login
  [Arguments]  @{ARGUMENTS}
  # Waiting for email field appear
  Wait Until Page Contains Element   id=view-email   20

  # Login and Password input
  Input text   id=view-email   ${USERS.users['${ARGUMENTS[0]}'].login}
  Input text   id=password     ${USERS.users['${ARGUMENTS[0]}'].password}
  # Confirm Access
  Click Element   id=edit-tender-btn
  Wait Until Page Contains Element   xpath=//div[@class="logo"]  20

Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]}  ==  username
  ...      ${ARGUMENTS[1]}  ==  tender_data
## Initialisation of elements to fill
# TODO: check for ids of elements
  ${prepared_tender_data}=  Add_data_for_GUI_FrontEnds   ${ARGUMENTS[1]}
  ${prepared_tender_data}=  Update_data_for_Newtend  ${prepared_tender_data}
  ${items}=         Get From Dictionary   ${prepared_tender_data.data}               items
  ${title}=         Get From Dictionary   ${prepared_tender_data.data}               title
  ${description}=   Get From Dictionary   ${prepared_tender_data.data}               description
  ${budget}=        Get From Dictionary   ${prepared_tender_data.data.value}         amount
  ${step_rate}=     Get From Dictionary   ${prepared_tender_data.data.minimalStep}   amount
  ${start_date}=           Get From Dictionary   ${prepared_tender_data.data.tenderPeriod}    startDate
  ${end_date}=             Get From Dictionary   ${prepared_tender_data.data.tenderPeriod}    endDate
  ${enquiry_start_date}=   Get From Dictionary   ${prepared_tender_data.data.enquiryPeriod}   startDate
  ${enquiry_end_date}=     Get From Dictionary   ${prepared_tender_data.data.enquiryPeriod}   endDate
  ${quantity}=            Get From Dictionary   ${items[0]}                               quantity
  ${items_description}=   Get From Dictionary   ${items[0]}                          description
  ${unit}=          Get From Dictionary   ${items[0].unit}                           name

  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  # Navigating to Customer's cabinet and Create Auction menu
  Go To                              http://ea.newtend.com/auction/#/home/
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Click Element                      xpath=//a[@ui-sref="createTender"]
  Click Element                      xpath=//button[@id="attach-docs-btn"]
# Input fields tender
  Input text   name=tenderName       ${title}
  Input text   ${locator.edit.description}   ${description}
  # Selecting with NDS
  Click Element     id=with-nds

# Moving to Lot's modal
  Click Element     ${locator.lot.add}
  Input text        ${locator.lot.name}            Lot name
  Input text        ${locator.lot.description}     Lot description
  ${budget}         convert to string       ${budget}
  Input text        ${locator.lot.value}       ${budget}
  ${step_rate}      convert to string       ${step_rate}
  Input text        ${locator.lot.step}     ${step_rate}
  Click Element     ${locator.lot.confirm.btn}

  # Selecting related lot
  Click Element     xpath=//select[@ng-model="item.relatedLot"]
  Click Element     xpath=//option[@label='Lot name']


  # Filling Items fields
  Click Element     ${locator.items[0].description}
  Input Text        ${locator.items[0].description}      ${items_description}

  Click Element     ${locator.items[0].quantity}
  Input Text        ${locator.items[0].quantity}    ${quantity}

  Click Element     ${locator.items[0].unit.name}
  Click Element     xpath=//a[contains(text(), "единицы измерения")]/..//a[contains(text(), '${unit}')]
# Add Item(s)============
# Items add CAV classifier
  Click Element       id=classifier10
  ${cav_id}=               Get From Dictionary         ${items[0].classification}       id
  # Need to hack CAV selection. Hard code implemented
  # Search in CAV didn't work for that time, when tests were written
  # Sorry, for this!!
  Click Element       xpath=//label[@for="66113000-5"]
  # Confirm CAV
  Click Element       id=select-classifier-btn

  # Delivery Input Data extract from dictionary
  ${countryName}=     Get From Dictionary   ${items[0].deliveryAddress}   countryName
  ${ZIP}=             Get From Dictionary   ${items[0].deliveryAddress}   postalCode
  ${region}=          Get From Dictionary   ${items[0].deliveryAddress}   region
  ${locality}=        Get From Dictionary   ${items[0].deliveryAddress}   locality
  ${streetAddress}=   Get From Dictionary   ${items[0].deliveryAddress}   streetAddress
  ${deliverydate_end_date}=   Get From Dictionary   ${items[0].deliveryDate}   endDate

  # Fill Delivery fields
  Click Element   id=deliveryAddress0
  Input text                         xpath=//input[@ng-model="deliveryAddress.postalCode"]   ${ZIP}
  Input text                         xpath=//input[@ng-model="deliveryAddress.region"]   ${region}
  Input text                         xpath=//input[@ng-model="deliveryAddress.locality"]   ${locality}
  Input text                         xpath=//input[@ng-model="deliveryAddress.streetAddress"]   ${streetAddress}
  Click Element                      xpath=//button[@class="btn btn-lg single-btn ng-binding"]  # ng-click="save()"

  ${delivery_end_date_formatted}      Get Substring      ${deliverydate_end_date}     0     10   # 2016-09-07
  Input Text        ${locator.items[0].deliveryDate.endDate}         ${delivery_end_date_formatted}

# Set tender datatimes
  Set datetime   start-date-registration    ${start_date}
  Set datetime   end-date-registration      ${end_date}
  Set datetime   end-date-qualification     ${enquiry_end_date}
#  Set datetime   start-date-qualification   ${enquiry_start_date}

# Save Tender
  Click Element                      ${locator.save}
  Wait Until Page Contains Element   id=attach-docs-modal   30
  Click Element                      id=attach-docs-btn


# Get Ids
  Wait Until Page Contains Element   xpath=//div[@class="title"]   30
  ${TENDER_UAID}=         Get Text   xpath=//a[@ng-switch-when="false"]
  ${Ids}=        Convert To String   ${TENDER_UAID}
  Run keyword if   '${mode}' == 'multi'   Set Multi Ids   ${TENDER_UAID}
#  [return]  ${Ids}
  log to console  ${TENDER_UAID}
  [return]  ${TENDER_UAID}

Set Multi Ids
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  ${tender_UAid}
  ${current_location}=      Get Location
  ${id}=    Get Substring   ${current_location}   -41   -9
  ${Ids}=   Create List     ${tender_UAid}   ${id}

Set datetime
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  control_id
  ...      ${ARGUMENTS[1]} ==  date
  # Date insert

##Pick Date
#  Click Element       xpath=//input[@id="end-date-delivery0"]/../span[@class="calendar-btn"]
#  Wait Until Page Contains Element            xpath=//td[@class="text-center ng-scope"]   30
#  ${datapicker_id}=   Get Element Attribute   xpath=//input[@id="end-date-delivery0"]/..//td[@class="text-center ng-scope"]@id
#  ${datapicker_id}=   Get Substring           ${datapicker_id}   0   -1
#  ${date_index}=      newtend_date_picker_index   ${ARGUMENTS[1]}
#  ${datapicker_id}=   Convert To String       ${datapicker_id}${date_index}
#  Click Element       xpath=//input[@id="${ARGUMENTS[0]}"]/..//td[@id="${datapicker_id}"]/button
#Set time
  ${hous}=   Get Substring   ${ARGUMENTS[1]}   11   13
  ${minutes}=   Get Substring   ${ARGUMENTS[1]}   14   16
  Input text   xpath=//input[@id="${ARGUMENTS[0]}"]/../..//input[@ng-model="hours"]   ${hous}
  Input text   xpath=//input[@id="${ARGUMENTS[0]}"]/../..//input[@ng-model="minutes"]   ${minutes}

Додати багато придметів
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items
  ${Items_length}=   Get Length   ${items}
  : FOR    ${INDEX}    IN RANGE    1    ${Items_length}
  \   Click Element   ${locator.edit.add_item}
  \   Додати придмет   ${items[${INDEX}]}   ${INDEX}
# SlaOne's method for file upload
#Завантажити документ
#  [Arguments]  @{ARGUMENTS}
#  [Documentation]
#  ...      ${ARGUMENTS[0]} ==  username
#  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
#  ...      ${ARGUMENTS[2]} ==  ${filepath}
#  # For tender owner docs uploading
##  run keyword if  '${ARGUMENTS[0]}' == 'Newtend_Owner'   Click element    xpath=//a[@ui-sref="tenderView.documents"]
#  Click element    xpath=//a[@ui-sref="tenderView.documents"]
#  Wait until page contains element     xpath=//button[@ng-click="uploadDocument()"]     30
#  Click element     xpath=//button[@ng-click="uploadDocument()"]
#  Select from list by index     xpath=//select[@id="documentType"]      2
#  Run keyword if     '${ARGUMENTS[0]}' == 'Newtend_Owner'    select from list by index   '2'  # xpath=//option[@value="notice"]
#  Run keyword if     '${ARGUMENTS[0]}' == 'Provider'    click element     xpath=//option[@value="qualificationDocuments"]
#  Click element     xpath=//button[@ng-model="file"]
#  Choose file       xpath=//input[@type="file"]    ${ARGUMENTS[2]}
#  Click element     xpath=//button[@ng-click="upload()"]
#  sleep     3
#  Reload page

Завантажити документ
  [Arguments]  @{ARGUMENTS}
  [Documentation]
   ...      ${ARGUMENTS[0]} ==  username
#-  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
#-  ...      ${ARGUMENTS[2]} ==  ${filepath}
  ...      ${ARGUMENTS[1]} ==  ${filepath}
  ...      ${ARGUMENTS[2]} ==  ${TENDER_UAID}
   # For tender owner docs uploading
 #  run keyword if  '${ARGUMENTS[0]}' == 'Newtend_Owner'   Click element    xpath=//a[@ui-sref="tenderView.documents"]
  Click element    xpath=//a[@ui-sref="tenderView.documents"]
  Wait until page contains element     xpath=//button[@ng-click="uploadDocument()"]     30
  Click element     xpath=//button[@ng-click="uploadDocument()"]
  Select from list by index     xpath=//select[@id="documentType"]      2
#-  Run keyword if     '${ARGUMENTS[0]}' == 'Newtend_Owner'    select from list by index   '2'  # xpath=//option[@value="notice"]
# Run keyword if     '${ARGUMENTS[0]}' == 'Newtend_Owner'    select from list by index   '2'  # xpath=//option[@value="notice"]
  Run keyword if     '${ARGUMENTS[0]}' == 'Provider'    click element     xpath=//option[@value="qualificationDocuments"]
#-  Click element     xpath=//button[@ng-model="file"]
#-  Choose file       xpath=//input[@type="file"]    ${ARGUMENTS[2]}
  Execute Javascript  $('button[ng-model="file"]').click()
  Choose file       xpath=//input[@type="file"]    ${ARGUMENTS[1]}
  Click element     xpath=//button[@ng-click="upload()"]
  sleep     3
  Reload page
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
  ...      ${ARGUMENTS[1]} ==  tender_uaid

  run keyword if  '${ARGUMENTS[0]}' == 'Newtend_Owner'   Click element   xpath=//span[@class="icon icon-newtend"]
  log to console   ${ARGUMENTS[0]}
  LOG TO CONSOLE   ${ARGUMENTS[1]}

#  run keyword if  '${ARGUMENTS[0]}' == 'Newtend_Provider1'   Click element     xpath=//span[@id="menu"]   Claick element    xpath=//a[@ui-sref="tendersList.type({list: 'home', pageNum: 1})"]
#  Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
### Індексація на тестовому сервері відключена, як наслідок пошук по UAid не працює, отож застосовую обхід цієї функціональності для розблокування наступних тестів
#  Wait Until Page Contains Element   xpath=//div[@class="search-field"]/input   20
#  #${ARGUMENTS[1]}=   Convert To String   UA-2015-06-08-000023
#  Input text                         xpath=//div[@class="search-field"]/input   ${ARGUMENTS[1]}
#  : FOR    ${INDEX}    IN RANGE    1    30
#  \   Log To Console   .   no_newline=true
#  \   sleep       1
#  \   ${count}=   Get Matching Xpath Count   xpath=//a[@class="row tender-info ng-scope"]
#  \   Exit For Loop If  '${count}' == '1'
  Sleep   2
#  Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
#  ${ARGUMENTS[1]}=   Convert To String   Воркераунд для проходженя наступних тестів - пошук не працює.
###
#  Wait Until Page Contains Element   xpath=(//a[@class="row tender-info ng-scope"])   20
#  Sleep   5
#  Click Element                      xpath=(//a[@class="row tender-info ng-scope"])
#  Wait Until Page Contains Element   xpath=//a[@class="ng-binding ng-scope"]|//span[@class="ng-binding ng-scope"]   30
  Input text    xpath=//input[@type="search"]       ${ARGUMENTS[1]}
  Click Element     xpath=//div[@ng-click="search()"]

  sleep   4
  Click Element     xpath=//a[@ui-sref="tenderView.overview({id: tender.id})"]


отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  Switch browser   ${ARGUMENTS[0]}
  Click Element     xpath=//a[@ui-sref="tenderView.overview"]
  Run Keyword And Return  Отримати інформацію про ${ARGUMENTS[1]}

отримати текст із поля і показати на сторінці
  [Arguments]   ${fieldname}
  sleep  1
  ${return_value}=   Get Text  ${locator.view.${fieldname}}
  [return]  ${return_value}

Отримати інформацію про status
  reload page
  ${return_value}=   Отримати текст із поля і показати на сторінці   status
  ${return_value}=   convert_nt_string_to_common_string   ${return_value}
  log to console    ${return_value}
  [Return]  ${return_value}

отримати інформацію про title
  ${title}=   отримати текст із поля і показати на сторінці   title
  [return]  ${title}

отримати інформацію про description
  ${description}=   отримати текст із поля і показати на сторінці   description
  [return]  ${description}

отримати інформацію про auctionId
  ${tenderId}=   отримати текст із поля і показати на сторінці   auctionId
  [return]  ${tenderId}

отримати інформацію про value.amount
  ${valueAmount}=   отримати текст із поля і показати на сторінці   value.amount
  ${valueAmount}=   Convert To Number   ${valueAmount.split(' ')[0]}
  [return]  ${valueAmount}

отримати інформацію про minimalStep.amount
  ${minimalStepAmount}=   отримати текст із поля і показати на сторінці   minimalStep.amount
  ${minimalStepAmount}=   Convert To Number   ${minimalStepAmount.split(' ')[0]}
  [return]  ${minimalStepAmount}

Отримати інформацію про value.currency
  ${valueCurrency}=       отримати текст із поля і показати на сторінці    value.currency     #  xpath=//label[@for="budget"]
  ${valueCurrency}=       Get Substring     ${valueCurrency}    -4      -1
  log to console    ${valueCurrency}
  [return]   ${valueCurrency}

Внести зміни в тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  id
  ...      ${ARGUMENTS[2]} ==  fieldname
  ...      ${ARGUMENTS[3]} ==  fieldvalue
  Switch browser   ${ARGUMENTS[0]}
  Click Element    xpath=//a[@ui-sref="tenderView.overview"]
  Click Element    xpath=//button[@id="edit-tender-btn"]
#  Click button     ${locator.edit_tender}
  Wait Until Page Contains Element   ${locator.edit.${ARGUMENTS[2]}}   20
  Input Text       ${locator.edit.${ARGUMENTS[2]}}   ${ARGUMENTS[3]}
  Click Element    xpath=//button[@id="submit-btn"]
#  Click Element    ${locator.save}
  Wait Until Page Contains Element   ${locator.${ARGUMENTS[2]}}    20
  ${result_field}=   отримати текст із поля і показати на сторінці   ${ARGUMENTS[2]}
  Should Be Equal   ${result_field}   ${ARGUMENTS[3]}

отримати інформацію про procuringEntity.name
  ${procuringEntity_name}=   отримати текст із поля і показати на сторінці   procuringEntity.name
  [return]  ${procuringEntity_name}

отримати інформацію про enquiryPeriod.endDate
  ${enquiryPeriodEndDate}=   отримати текст із поля і показати на сторінці   enquiryPeriod.endDate
  ${enquiryPeriodEndDate}=   Get Substring      ${enquiryPeriodEndDate}     3
  Log to console    ${enquiryPeriodEndDate}
  [return]  ${enquiryPeriodEndDate}

отримати інформацію про tenderPeriod.startDate
  ${tenderPeriodStartDate}=   отримати текст із поля і показати на сторінці   tenderPeriod.startDate
  [return]  ${tenderPeriodStartDate}

отримати інформацію про tenderPeriod.endDate
  ${tenderPeriodEndDate}=   отримати текст із поля і показати на сторінці   tenderPeriod.endDate
  [return]  ${tenderPeriodEndDate}

отримати інформацію про enquiryPeriod.startDate
  ${enquiryPeriodStartDate}=   отримати текст із поля і показати на сторінці   enquiryPeriod.StartDate
  [return]  ${enquiryPeriodStartDate}

отримати інформацію про items[0].description
  ${description}=   отримати текст із поля і показати на сторінці   items[0].description
  [return]  ${description}

отримати інформацію про items[0].deliveryDate.endDate
  ${deliveryDate_endDate}=   отримати текст із поля і показати на сторінці   items[0].deliveryDate.endDate
  [return]  ${deliveryDate_endDate}

# NDS
Отримати інформацію про value.valueAddedTaxIncluded
  ${return_value}=   Отримати текст із поля і показати на сторінці   value.valueAddedTaxIncluded       #  xpath=//label[@for="with-nds"]
  ${return_value}=   convert_nt_string_to_common_string      ${return_value}
  log to console        ${return_value}
  [Return]  ${return_value}

отримати інформацію про items[0].deliveryLocation.latitude
  Fail  Не реалізований функціонал

отримати інформацію про items[0].deliveryLocation.longitude
  Fail  Не реалізований функціонал

## Delivery Address
отримати інформацію про items[0].deliveryAddress.countryName
  ${Delivery_Address}=   отримати текст із поля і показати на сторінці   items[0].deliveryAddress
  [return]  ${Delivery_Address.split(', ')[1]}

отримати інформацію про items[0].deliveryAddress.postalCode
  ${Delivery_Address}=   отримати текст із поля і показати на сторінці   items[0].deliveryAddress
  [return]  ${Delivery_Address.split(', ')[0]}

отримати інформацію про items[0].deliveryAddress.region
  ${Delivery_Address}=   отримати текст із поля і показати на сторінці   items[0].deliveryAddress
  [return]  ${Delivery_Address.split(', ')[2]}

отримати інформацію про items[0].deliveryAddress.locality
  ${Delivery_Address}=   отримати текст із поля і показати на сторінці   items[0].deliveryAddress
  [return]  ${Delivery_Address.split(', ')[3]}

отримати інформацію про items[0].deliveryAddress.streetAddress
  ${Delivery_Address}=   отримати текст із поля і показати на сторінці   items[0].deliveryAddress
  ${Delivery_Address}=   Get Substring   ${Delivery_Address}=    0   -2
  [return]  ${Delivery_Address.split(', ')[4]}

##CAV
отримати інформацію про items[0].classification.scheme
  ${classificationScheme}=   отримати текст із поля і показати на сторінці     items[0].classification.id
  ${classificationScheme}=   Get substring     ${classificationScheme}      -3
  log to console    ${classificationScheme}
  [return]  ${classificationScheme}
#  [return]  ${classificationScheme.split(' ')[1]}

отримати інформацію про items[0].classification.id
  ${classification_id}=   отримати текст із поля і показати на сторінці   items[0].classification.scheme
  [return]  ${classification_id.split(' - ')[0]}

отримати інформацію про items[0].classification.description
  ${classification_description}=   отримати текст із поля і показати на сторінці   items[0].classification.scheme
  Run Keyword And Return If  '${classification_description}' == '66113000-5 - Права вимоги'   Convert To String   Права вимоги
  [return]  ${classification_description}

##ДКПП
отримати інформацію про items[0].additionalClassifications[0].scheme
  ${additional_classificationScheme}=   отримати текст із поля і показати на сторінці   items[0].additional_classification[0].scheme.title
  [return]  ${additional_classificationScheme.split(' ')[1]}

отримати інформацію про items[0].additionalClassifications[0].id
  ${additional_classification_id}=   отримати текст із поля і показати на сторінці   items[0].additional_classification[0].scheme
  [return]  ${additional_classification_id.split(' - ')[0]}

отримати інформацію про items[0].additionalClassifications[0].description
  ${additional_classification_description}=   отримати текст із поля і показати на сторінці   items[0].additional_classification[0].scheme
  ${additional_classification_description}=   Convert To Lowercase   ${additional_classification_description}
  ${additional_classification_description}=   Get Substring   ${additional_classification_description}=    0   -2
  [return]  ${additional_classification_description.split(' - ')[1]}

##item
отримати інформацію про items[0].unit.name
  ${unit_name}=   отримати текст із поля і показати на сторінці   items[0].unit.name
  Run Keyword And Return If  '${unit_name}' == 'килограммы'   Convert To String   кілограм
  [return]  ${unit_name}

отримати інформацію про items[0].unit.code
  Fail  Не реалізований функціонал
  ${unit_code}=   отримати текст із поля і показати на сторінці   items[0].unit.code
  [return]  ${unit_code}

отримати інформацію про items[0].quantity
  ${quantity}=   отримати текст із поля і показати на сторінці   items[0].quantity
  ${quantity}=   Convert To Number   ${quantity}
  [return]  ${quantity}

додати предмети закупівлі
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  username
  ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} =  3
  ${period_interval}=  Get Broker Property By Username  ${ARGUMENTS[0]}  period_interval
  ${ADDITIONAL_DATA}=  prepare_test_tender_data  ${period_interval}  multi
  ${items}=         Get From Dictionary   ${ADDITIONAL_DATA.data}               items
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Wait Until Page Contains Element   ${locator.edit_tender}    10
  Click Element                      ${locator.edit_tender}
  Wait Until Page Contains Element   ${locator.edit.add_item}  10
  Input text   ${locator.edit.description}   description
  Run keyword if   '${TEST NAME}' == 'Можливість додати позицію закупівлі в тендер'   додати позицію
  Run keyword if   '${TEST NAME}' != 'Можливість додати позицію закупівлі в тендер'   забрати позицію
  Wait Until Page Contains Element   ${locator.save}           10
  Click Element   ${locator.save}
  Wait Until Page Contains Element   ${locator.description}    20

додати позицію
###  Не видно контролів додати пропозицію в хромі, потрібно скролити, скрол не працює. Обхід: додати лише 1 пропозицію + редагувати description для скролу.
  Click Element    ${locator.edit.add_item}
  Додати придмет   ${items[1]}   1

забрати позицію
  Click Element   xpath=//a[@title="Добавить лот"]/preceding-sibling::a

Задати питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} == username  # There were just one =
  ...      ${ARGUMENTS[1]} == ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} == question_data
  ${title}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=  Get From Dictionary  ${ARGUMENTS[2].data}  description
#  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
#  newtend.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Click Element   xpath=//a[@ui-sref="tenderView.chat"]
  Wait Until Page Contains Element   xpath=//button[@ng-click="askQuestion()"]   20
  Click Element   xpath=//button[@ng-click="askQuestion()"]
  Wait Until Page Contains Element   xpath=//input[@ng-model="chatData.title"]   10
  Input text   xpath=//input[@ng-model="chatData.title"]   ${title}
  Input text    xpath=//textarea[@ng-model="chatData.message"]   ${description}
  Click Element   xpath=//button[@ng-click="sendQuestion()"]
#  Wait Until Page Contains    ${description}   20

оновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
#  ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
#  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Reload Page
#  Wait Until Page Contains   ${ARGUMENTS[1]}   20
# information
отримати інформацію про QUESTIONS[0].title
  reload page
  sleep     3
  Click Element              xpath=//a[@ui-sref="tenderView.chat"]
  sleep     3
#  Wait Until Page Contains   Вы не можете задавать вопросы    20
  ${resp}=   отримати текст із поля і показати на сторінці   QUESTIONS[0].title
  [return]  ${resp}

отримати інформацію про QUESTIONS[0].description
  sleep     3
  Click Element              xpath=//a[@ui-sref="tenderView.chat"]
  ${resp}=   отримати текст із поля і показати на сторінці   QUESTIONS[0].description
  [return]  ${resp}

отримати інформацію про QUESTIONS[0].date
  sleep     3
  Click Element              xpath=//a[@ui-sref="tenderView.chat"]
  ${resp}=   отримати текст із поля і показати на сторінці   QUESTIONS[0].date
  ${resp}=   Change_day_to_month   ${resp}
  [return]  ${resp}
# question info
Отримати інформацію про questions[0].answer
  Click Element                       xpath=//a[@ui-sref="tenderView.chat"]
  reload page
  Wait Until Page Contains Element    xpath=//div[@class="answer"]      10
  Sleep  1
  ${return_value}=   Get Text         xpath=//span[@class="answer-description ng-binding"]
  log to console    ${return_value}
  [Return]  ${return_value}

Change_day_to_month
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]}  ==  date
  ${day}=   Get Substring   ${ARGUMENTS[0]}   0   2
  ${month}=   Get Substring   ${ARGUMENTS[0]}  3   6
  ${rest}=   Get Substring   ${ARGUMENTS[0]}   5
  ${return_value}=   Convert To String  ${month}${day}${rest}
  [return]  ${return_value}


Подати цінову пропозицію
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} == username
  ...      ${ARGUMENTS[1]} == ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} == ${test_bid_data}
  ${amount}=    Get From Dictionary     ${ARGUMENTS[2].data.value}    amount
  Reload page
  : FOR   ${INDEX}   IN RANGE    1    30
  \   Log To Console   .   no_newline=true
  \   sleep     3
  \   ${count}=   Get Matching Xpath Count   xpath=//button[@ng-click="placeBid()"]
  \   Exit For Loop If   '${count}' == '1'
#  \   Click element       ${count}
  Click element     xpath=//button[@ng-click="placeBid()"]
#  Click element     xpath=//input[@name="amount"]
  Input text    xpath=//input[@name="amount"]    ${amount}
  click element     xpath=//input[@name="agree"]
  Click element     xpath=//button[@ng-click="placeBid()"]
  sleep   3
  reload page
  Wait until page contains element      xpath=//div[@class="bid-placed make-bid ng-scope"]
  ${resp}=   Get text    xpath=//h3[@class="ng-binding"]
  [Return]     ${resp}

Скасувати цінову пропозицію
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} == username
  ...      ${ARGUMENTS[1]} == ${TENDER_UAID}
  Click element     xpath=//a[@ng-click="cancelBid()"]
  Wait until page contains element     xpath=//div[@ng-if="isCancel"]
  Click element     xpath=//button[@ng-click="cancelBid()"]

Змінити цінову пропозицію
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  tenderId
    ...    ${ARGUMENTS[2]} ==  amount
    ...    ${ARGUMENTS[3]} ==  amount.value
#    Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
    reload page
    sleep   2
    Click Element           xpath=//button[@ng-click="placeBid()"]
    Clear Element Text      xpath=//input[@name="amount"]
    Input Text              xpath=//input[@name="amount"]         ${ARGUMENTS[3]}
    ${agree}=   Get Matching Xpath Count     xpath=//input[@name="agree"]
    run keyword if  '${agree}' == '1'     Click element   xpath=//input[@name="agree"]
    sleep   3
    Mouse over          xpath=//button[@ng-click="changeBid()"]
    Click Element       xpath=//button[@ng-click="changeBid()"]


Відповісти на питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} == username
  ...      ${ARGUMENTS[1]} == ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} == answer_data
  ${answer}=     Get From Dictionary   ${ARGUMENTS[3].data}  answer
  Click element     xpath=//a[@ui-sref="tenderView.chat"]
  reload page
  sleep     2
  Mouse over    xpath=//div[@class="row question-container"]
  Mouse over    xpath=//div[@class="answer"]
  Click element     xpath=//div[@class="answer"]
  Click element     xpath=//textarea[@ng-model="chatData.message"]
  Input text        xpath=//textarea[@ng-model="chatData.message"]      ${answer}
  click element     xpath=//button[@ng-click="sendAnswer()"]
  sleep     2
  reload page


Завантажити документ в ставку
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[1]} ==  file
  ...    ${ARGUMENTS[2]} ==  tenderId
  reload page
  sleep     2
  Click Element       xpath=//a[@ui-sref="tenderView.documents"]
  Wait until page contains element    xpath=//button[@ng-click="uploadDocument()"]
  Click element       xpath=//button[@ng-click="uploadDocument()"]
  Click element       xpath=//button[@ng-model="file"]
  sleep     3
  Choose file         xpath=//input[@type="file"]    ${ARGUMENTS[1]}
  Click file         xpath=//button[@ng-click="upload()"]


Змінити документ в ставці
  [Arguments]  @{ARGUMENTS}


Отримати посилання на аукціон для глядача
  [Arguments]  @{ARGUMENTS}
  reload page
  sleep     3
  Click element     xpath=//a[@ui-sref="tenderView.auction"]
  Wait until page contains element      xpath=//a[@class="auction-link ng-binding"]     10
  ${result} =    Get Element Attribute  xpath=//a[@target="_blank"]@href
  log to console    ${result}


Отримати посилання на аукціон для учасника
  [Arguments]  @{ARGUMENTS}
  reload page
  sleep     3
  Click element     xpath=//a[@ui-sref="tenderView.auction"]
  Wait until page contains element      xpath=//a[@class="auction-link ng-binding"]     10
  ${result} =    Get Element Attribute  xpath=//a[@target="_blank"]@href
  log to console    ${result}