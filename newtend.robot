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
${locator.view.items[0].classification.scheme}      id=classifier-0
${locator.view.items[0].classification.id}      id=classifier-0
${locator.view.QUESTIONS[0].title}          xpath=//span[@class="user ng-binding"]
${locator.view.QUESTIONS[0].description}    xpath=//span[@class="question-description ng-binding"]
${locator.view.QUESTIONS[0].date}           xpath=//span[@class="date ng-binding"]
${locator.view.items[0].unit.name}          xpath=//span[@class="unit ng-binding"]
${locator.view.items[0].quantity}           id=quantity-0
${locator.view.items[0].description}        id=view-item-description-0
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
  Input text   id=view-email   ${USERS.users['${ARGUMENTS[0]}'].login}
  Input text   id=password   ${USERS.users['${ARGUMENTS[0]}'].password}
  Click Element   id=edit-tender-btn
  sleep     2
  log to console   Success logging in as Some one - ${ARGUMENTS[0]}

Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data
# Initialisation. Getting values from Dictionary
  log to console    Start creating procedure

  ${title}=         Get From Dictionary   ${ARGUMENTS[1].data}               title
  ${description}=   Get From Dictionary   ${ARGUMENTS[1].data}               description
  ${budget}=        Get From Dictionary   ${ARGUMENTS[1].data.value}         amount
  ${guarantee}=     get from dictionary   ${ARGUMENTS[1].data.guarantee}     amount
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

  Wait Until Page Contains Element   xpath=//a[@href="#/create-tender/singlelot/belowThreshold"]   100
  Click Link                         xpath=//a[@href="#/create-tender/singlelot/belowThreshold"]
# Selecting DGF Financial asset or DGF Other assets
  Run keyword if   '${mode}' == 'dgfFinancialAssets'    select from list by value     xpath=//select[@id="tenderProcedure"]       dgfFinancialAssets
  Run keyword if   '${mode}' == 'dgfOtherAssets'    select from list by value     xpath=//select[@id="tenderProcedure"]       dgfOtherAssets
  click element     id=attach-docs-btn

  log to console    Selecting Some procedure ${mode}

# Input fields tender
  Input text   ${locator.title}              ${title}
  Input text   ${locator.description}        ${description}
  ${budget_string}      convert to string    ${budget}
  Input text   ${locator.value.amount}       ${budget_string}
  Click Element    id=with-nds
  ${step_rate_string}   convert to string     ${step_rate}
  Input text   ${locator.minimalStep.amount}  ${step_rate_string}
  ${guarantee_string}   convert to string     ${guarantee}
  Input text    ${locator.guaranteeamount}    ${guarantee_string}
# Add Item(s)
  Input text    ${locator.items[0].description}     ${item_description}
  Input text    ${locator.items[0].quantity}        ${item_quantity}
  click element   ${locator.items[0].unit.name}
  click element   xpath=//a[contains(text(), '${unit_name}')]
# Selecting classifier
  click element   ${locator.items[0].classification.scheme}
  sleep     5
  input text      id=classifier-search-field    ${classification_id}
  sleep     5
  click element     xpath=//span[contains(text(), '${classification_id}')]
  click element     id=select-classifier-btn

# Add delivery address
  click element     ${locator.items[0].deliveryAddress}
  sleep     2
  input text        ${locator.delivery_zip}      ${deliveryaddress_postalcode}
  input text        ${locator.delivery_region}   ${deliveryaddress_region}
  input text        ${locator.delivery_town}     ${deliveryaddress_locality}
  input text        ${locator.delivery_address}  ${deliveryaddress_streetaddress}
  click element     ${locator.delivery_save}

# Auction Start date block
  ${start_date_date}  get substring   ${start_date}  0   10
  ${hours}=   Get Substring   ${start_date}   11   13
  ${minutes}=   Get Substring   ${start_date}   14   16
  Input text   ${locator.tenderPeriod.endDate}      ${start_date_date}
  Input text   xpath=//input[@ng-change="updateHours()"]     ${hours}
  Input text   xpath=//input[@ng-change="updateMinutes()"]   ${minutes}

# Save Auction - publish to CDB
  Click Element                      ${locator.save}
  Wait Until Page Contains Element   xpath=//div[@id="attach-docs-modal"]   30
  Click Element                      id=no-docs-btn
# Get Ids
  Wait Until Page Contains Element   xpath=//div[@class="title"]   30
  ${tender_uaid}=         Get Text   xpath=//div[@class="title"]
#  ${Ids}=        Convert To String   ${tender_UAid}
#  Run keyword if   '${mode}' == 'multi'   Set Multi Ids   ${tender_UAid}
#  [return]  ${tender_uaid}
  [return]  ${TENDER_UAID}

#Set Multi Ids
#  [Arguments]  @{ARGUMENTS}
#  [Documentation]
#  ...      ${ARGUMENTS[0]} ==  ${tender_UAid}
#  ${current_location}=      Get Location
#  ${id}=    Get Substring   ${current_location}   -41   -9
#  ${Ids}=   Create List     ${tender_UAid}   ${id}

#Set datetime
#  [Arguments]  @{ARGUMENTS}
#  [Documentation]
#  ...      ${ARGUMENTS[0]} ==  control_id
#  ...      ${ARGUMENTS[1]} ==  date
##Pick Date
#  Click Element       xpath=//input[@id="${ARGUMENTS[0]}"]/../span[@class="calendar-btn"]
#  Wait Until Page Contains Element            xpath=//td[@class="text-center ng-scope"]   30
#  ${datapicker_id}=   Get Element Attribute   xpath=//input[@id="${ARGUMENTS[0]}"]/..//td[@class="text-center ng-scope"]@id
#  ${datapicker_id}=   Get Substring           ${datapicker_id}   0   -1
#  ${date_index}=      newtend_date_picker_index   ${ARGUMENTS[1]}
#  ${datapicker_id}=   Convert To String       ${datapicker_id}${date_index}
#  Click Element       xpath=//input[@id="${ARGUMENTS[0]}"]/..//td[@id="${datapicker_id}"]/button
##Set time
#  ${hous}=   Get Substring   ${ARGUMENTS[1]}   11   13
#  ${minutes}=   Get Substring   ${ARGUMENTS[1]}   14   16
#  Input text   xpath=//input[@id="${ARGUMENTS[0]}"]/../..//input[@ng-model="hours"]   ${hous}
#  Input text   xpath=//input[@id="${ARGUMENTS[0]}"]/../..//input[@ng-model="minutes"]   ${minutes}

#Додати придмет
#  [Arguments]  @{ARGUMENTS}
#  [Documentation]
#  ...      ${ARGUMENTS[0]} ==  items_n
#  ...      ${ARGUMENTS[1]} ==  index
### Get values for item
#  ${items_description}=   Get From Dictionary   ${ARGUMENTS[0]}                          description
#  ${quantity}=      Get From Dictionary   ${ARGUMENTS[0]}                                quantity
#  ${cpv}=           Convert To String     Картонки
#  ${dkpp_desc}=     Get From Dictionary   ${ARGUMENTS[0].additionalClassifications[0]}   description
#  ${dkpp_id}=       Get From Dictionary   ${ARGUMENTS[0].additionalClassifications[0]}   id
#  ${unit}=          Get From Dictionary   ${ARGUMENTS[0].unit}                           name
#  ${deliverydate_end_date}=   Get From Dictionary   ${ARGUMENTS[0].deliveryDate}   endDate
#  ${countryName}=     Get From Dictionary   ${ARGUMENTS[0].deliveryAddress}   countryName
#  ${ZIP}=             Get From Dictionary   ${ARGUMENTS[0].deliveryAddress}   postalCode
#  ${region}=          Get From Dictionary   ${ARGUMENTS[0].deliveryAddress}   region
#  ${locality}=        Get From Dictionary   ${ARGUMENTS[0].deliveryAddress}   locality
#  ${streetAddress}=   Get From Dictionary   ${ARGUMENTS[0].deliveryAddress}   streetAddress
#
#  Set datetime   end-date-delivery${ARGUMENTS[1]}         ${deliverydate_end_date}
# Set CPV
#  Wait Until Page Contains Element   id=classifier1${ARGUMENTS[1]}
#  Click Element                      id=classifier1${ARGUMENTS[1]}
#  Wait Until Page Contains Element   xpath=//input[@class="ng-pristine ng-untouched ng-valid"]   100
#  Input text                         xpath=//input[@class="ng-pristine ng-untouched ng-valid"]   ${cpv}
#  Wait Until Page Contains Element   xpath=//span[contains(text(),'${cpv}')]   20
#  Click Element                      xpath=//input[@class="ng-pristine ng-untouched ng-valid"]
#  Click Element                      xpath=//button[@class="btn btn-default btn-lg pull-right choose ng-binding"]
## Set ДКПП
#  Click Element                      id=classifier2${ARGUMENTS[1]}
#  Wait Until Page Contains Element   xpath=//input[@class="ng-pristine ng-untouched ng-valid"]   100
#  Input text                         xpath=//input[@class="ng-pristine ng-untouched ng-valid"]   ${dkpp_desc}
#  Wait Until Page Contains Element   xpath=//span[contains(text(),'${dkpp_id}')]   100
#  Click Element                      xpath=//span[contains(text(),'${dkpp_id}')]/../..//input[@class="ng-pristine ng-untouched ng-valid"]
#  Click Element                      xpath=//button[@class="btn btn-default btn-lg pull-right choose ng-binding"]
# Set Delivery Address
#  Click Element                      id=deliveryAddress${ARGUMENTS[1]}
#  Wait Until Page Contains Element   xpath=//input[@ng-model="deliveryAddress.postalCode"]   20
#  Input text                         xpath=//input[@ng-model="deliveryAddress.postalCode"]   ${ZIP}
#  Input text                         xpath=//input[@ng-model="deliveryAddress.region"]   ${region}
#  Input text                         xpath=//input[@ng-model="deliveryAddress.locality"]   ${locality}
#  Input text                         xpath=//input[@ng-model="deliveryAddress.streetAddress"]   ${streetAddress}
#  Click Element                      xpath=//button[@class="btn btn-lg single-btn ng-binding"]

Додати багато придметів
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items
  ${Items_length}=   Get Length   ${items}
  : FOR    ${INDEX}    IN RANGE    1    ${Items_length}
  \   Click Element   ${locator.edit.add_item}
  \   Додати придмет   ${items[${INDEX}]}   ${INDEX}

Завантажити документ
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  ${Complain}
  Fail   Тест не написаний

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
  log to console   Searching for UFOs - ${ARGUMENTS[1]}
  Switch browser   ${ARGUMENTS[0]}
  Run Keyword If   '${ARGUMENTS[0]}' == 'Newtend_Owner'   click element    xpath=//a[@href="#/home/?pageNum=1&query=&status=&userOnly=&procurementMethodType="]
  sleep     2
  ${auction_number}=    convert to string   ${ARGUMENTS[1]}
  Input text   xpath=//input[@type="search"]     ${auction_number}
  click element     xpath=//div[@ng-click="search()"]
  sleep     2
  wait until page contains element   xpath=(//a[@class="row tender-info ng-scope"])   10
  Sleep   2
  Click Element                      xpath=(//a[@class="row tender-info ng-scope"])

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
  sleep  1
  ${return_value}=   Get Text  ${locator.view.${field_name}}
  [return]  ${return_value}

отримати інформацію про title
  ${title}=   отримати текст із поля і показати на сторінці   title
  [return]  ${title}

Отримати інформацію про status
  reload page
  ${return_value}=   Отримати текст із поля і показати на сторінці   status
  ${return_value}=   convert_nt_string_to_common_string     ${return_value}
  log to console    ${return_value}
  [Return]  ${return_value}

отримати інформацію про description
  ${description}=   отримати текст із поля і показати на сторінці   description
  [Return]  ${description}

отримати інформацію про auctionId
  ${tenderId}=   отримати текст із поля і показати на сторінці   auctionId
  [return]  ${tenderId}

отримати інформацію про value.amount
  ${valueAmount}=   отримати текст із поля і показати на сторінці   value.amount
  ${valueAmount}=   Convert To Number   ${valueAmount.split(' ')[0]}
  log to console   value amount - ${valueAmount}
  [Return]  ${valueAmount}

отримати інформацію про minimalStep.amount
  ${minimalStepAmount}=   отримати текст із поля і показати на сторінці   minimalStep.amount
  ${minimalStepAmount}=   Convert To Number   ${minimalStepAmount.split(' ')[0]}
  [return]  ${minimalStepAmount}

Отримати інформацію про value.currency
  ${valueCurrency}=       отримати текст із поля і показати на сторінці    value.currency     #  xpath=//label[@for="budget"]
  ${valueCurrency}=       Get Substring     ${valueCurrency}    -4      -1
  log to console    ${valueCurrency}
  [return]   ${valueCurrency}

# NDS
Отримати інформацію про value.valueAddedTaxIncluded
  ${return_value}=   Отримати текст із поля і показати на сторінці   value.valueAddedTaxIncluded       #  xpath=//label[@for="with-nds"]
  ${return_value}=   convert_nt_string_to_common_string      ${return_value}
  log to console        ${return_value}
  [Return]  ${return_value}

# ========Newtend end=========

#Внести зміни в тендер
#  [Arguments]  @{ARGUMENTS}
#  [Documentation]
#  ...      ${ARGUMENTS[0]} ==  username
#  ...      ${ARGUMENTS[1]} ==  id
#  ...      ${ARGUMENTS[2]} ==  fieldname
#  ...      ${ARGUMENTS[3]} ==  fieldvalue
#  Switch browser   ${ARGUMENTS[0]}
#  Click button     ${locator.edit_tender}
#  Wait Until Page Contains Element   ${locator.edit.${ARGUMENTS[2]}}   20
#  Input Text       ${locator.edit.${ARGUMENTS[2]}}   ${ARGUMENTS[3]}
#  Click Element    ${locator.save}
#  Wait Until Page Contains Element   ${locator.${ARGUMENTS[2]}}    20
#  ${result_field}=   отримати текст із поля і показати на сторінці   ${ARGUMENTS[2]}
#  Should Be Equal   ${result_field}   ${ARGUMENTS[3]}

отримати інформацію про procuringEntity.name
  [Arguments]   ${ARGUMENTS}
  [Documentation]
  ...       ${ARGUMENTS[0]} == auction_uaid
  ...       ${ARGUMENTS[1]} == username
  ${procuringEntity_name}=   отримати текст із поля і показати на сторінці   procuringEntity.name
  run keyword if  '${ARGUMENTS[1]}' == 'tender_owner'   update_data_for_newtend    ${procuringEntity_name}
  log to console  ${procuringEntity_name}
  [return]  ${procuringEntity_name}

отримати інформацію про enquiryPeriod.endDate
  ${enquiryPeriodEndDate}=   отримати текст із поля і показати на сторінці   enquiryPeriod.endDate
  [return]  ${enquiryPeriodEndDate}

отримати інформацію про tenderPeriod.startDate
  ${tenderPeriodStartDate}=   отримати текст із поля і показати на сторінці   tenderPeriod.startDate
  [return]  ${tenderPeriodStartDate}

отримати інформацію про tenderPeriod.endDate
  ${tenderPeriodEndDate}=   отримати текст із поля і показати на сторінці   tenderPeriod.endDate
  log to console    ${tenderPeriodEndDate}
  ${return_value}=   convert_newtend_date_to_iso_format   ${tenderPeriodEndDate}
#  ${return_value}=   get_time_with_offset   ${return_value.split('.')[0]}
  [return]  ${return_value}
#  [return]  ${tenderPeriodEndDate}

отримати інформацію про enquiryPeriod.startDate
  ${enquiryPeriodStartDate}=   отримати текст із поля і показати на сторінці   enquiryPeriod.StartDate
  [return]  ${enquiryPeriodStartDate}

# Comperison of Item names fields
Отримати інформацію із предмету
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uaid
  ...      ${ARGUMENTS[2]} ==  item_id
  ...      ${ARGUMENTS[3]} ==  field_name
   Run Keyword And Return  Отримати інформацію із ${ARGUMENTS[3]}
#  [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${field_name}

переглянути текст із поля і показати на сторінці
  [Arguments]   ${field_name}
  sleep  1
  ${return_value}=   Get Text  ${locator.view.${field_name}}
  [return]  ${return_value}

отримати інформацію із description
# Відображення опису номенклатур тендера
  ${description_raw}=   переглянути текст із поля і показати на сторінці   items[0].description
  ${description_1}=   Get substring     ${description_raw}  0   11
  ${description_2}=   convert_nt_string_to_common_string  ${description_raw.split(': ')[-1]}
  ${description}=   catenate  ${description_1}  ${description_2}
  log to console    ${description_1}
  log to console    ${description_2}
  [return]  ${description}

отримати інформацію із items[0].deliveryDate.endDate
  ${deliveryDate_endDate}=   переглянути текст із поля і показати на сторінці   items[0].deliveryDate.endDate
  [return]  ${deliveryDate_endDate}

отримати інформацію про items[0].deliveryLocation.latitude
  Fail  Не реалізований функціонал

отримати інформацію про items[0].deliveryLocation.longitude
  Fail  Не реалізований функціонал

### Delivery Address
#отримати інформацію про items[0].deliveryAddress.countryName
#  ${Delivery_Address}=   отримати текст із поля і показати на сторінці   items[0].deliveryAddress
#  [return]  ${Delivery_Address.split(', ')[1]}
#
#отримати інформацію про items[0].deliveryAddress.postalCode
#  ${Delivery_Address}=   отримати текст із поля і показати на сторінці   items[0].deliveryAddress
#  [return]  ${Delivery_Address.split(', ')[0]}
#
#отримати інформацію про items[0].deliveryAddress.region
#  ${Delivery_Address}=   отримати текст із поля і показати на сторінці   items[0].deliveryAddress
#  [return]  ${Delivery_Address.split(', ')[2]}
#
#отримати інформацію про items[0].deliveryAddress.locality
#  ${Delivery_Address}=   отримати текст із поля і показати на сторінці   items[0].deliveryAddress
#  [return]  ${Delivery_Address.split(', ')[3]}
#
#отримати інформацію про items[0].deliveryAddress.streetAddress
#  ${Delivery_Address}=   отримати текст із поля і показати на сторінці   items[0].deliveryAddress
#  ${Delivery_Address}=   Get Substring   ${Delivery_Address}=    0   -2
#  [return]  ${Delivery_Address.split(', ')[4]}

##CAV
Отримати інформацію із classification.scheme
# Відображення схеми класифікації номенклатур тендера - CAV
  ${classificationScheme_newtend}=   переглянути текст із поля і показати на сторінці   items[0].classification.scheme.title
  ${classificationScheme}=  convert_nt_string_to_common_string      ${classificationScheme_newtend}
  [return]  ${classificationScheme}

отримати інформацію із classification.id
  ${classification_id}=   переглянути текст із поля і показати на сторінці   items[0].classification.scheme
  [return]  ${classification_id.split(' - ')[0]}

отримати інформацію із classification.description
#  Відображення опису класифікації номенклатур тендера
  ${classification_description_raw}=   переглянути текст із поля і показати на сторінці   items[0].classification.scheme
  ${classification_description}=    convert_nt_string_to_common_string      ${classification_description_raw.split(' - ')[-1]}
  log to console  ${classification_description.split(' - ')[-1]}
  [return]  ${classification_description.split(' - ')[-1]}

##item
отримати інформацію із unit.name
  ${unit_name}=   переглянути текст із поля і показати на сторінці   items[0].unit.name
  Run Keyword And Return If  '${unit_name}' == 'килограммы'   Convert To String   кілограм
  [return]  ${unit_name}

Отримати інформацію із unit.code
  Fail  Не реалізований функціонал
#  ${unit_code}=   переглянути текст із поля і показати на сторінці   items[0].unit.code
#  [return]  ${unit_code}

отримати інформацію із quantity
  ${quantity}=   переглянути текст із поля і показати на сторінці   items[0].quantity
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
  Click Element   xpath=//a[contains(text(), "Уточнения")]
  Wait Until Page Contains Element   xpath=//button[@class="btn btn-lg btn-default question-btn ng-binding ng-scope"]   20
  Click Element   xpath=//button[@class="btn btn-lg btn-default question-btn ng-binding ng-scope"]
  Wait Until Page Contains Element   xpath=//input[@ng-model="title"]   10
  Input text   xpath=//input[@ng-model="title"]   ${title}
  Input text    xpath=//textarea[@ng-model="message"]   ${description}
  Click Element   xpath=//div[@ng-click="sendQuestion()"]
  Wait Until Page Contains    ${description}   20

Оновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} == username
  ...      ${ARGUMENTS[1]} == ${TENDER_UAID}
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Reload Page
#  Wait Until Page Contains   ${ARGUMENTS[1]}   20

отримати інформацію про QUESTIONS[0].title
  Wait Until Page Contains Element   xpath=//span[contains(text(), "Уточнения")]   20
  Click Element              xpath=//span[contains(text(), "Уточнения")]
  Wait Until Page Contains   Вы не можете задавать вопросы    20
  ${resp}=   отримати текст із поля і показати на сторінці   QUESTIONS[0].title
  [return]  ${resp}

отримати інформацію про QUESTIONS[0].description
  ${resp}=   отримати текст із поля і показати на сторінці   QUESTIONS[0].description
  [return]  ${resp}

отримати інформацію про QUESTIONS[0].date
  ${resp}=   отримати текст із поля і показати на сторінці   QUESTIONS[0].date
  ${resp}=   Change_day_to_month   ${resp}
  [return]  ${resp}

# === Bid Making === Works fine
Подати цінову пропозицію
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} == username
  ...      ${ARGUMENTS[1]} == tender_uaid
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
  ${amount_bid}=    convert to integer  ${amount}
  clear element text  xpath=//input[@name="amount"]
  input text    xpath=//input[@name="amount"]    ${amount_bid}
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

Отримати інформацію із пропозиції
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} == username
  ${value_raw}=     get text   xpath=//h3[@title=""]
  log to console    ${value_raw}
  ${value_num}=     get substring  ${value_raw}  0   -4
  log to console    ${value_num}
  ${value}=     convert to integer  ${value_num}
  [return]  ${value}

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
    ${updated_bid}=     convert to integer   ${ARGUMENTS[3]}
    log to console   Updatetd bid amount - ${updated_bid}
    Input Text              xpath=//input[@name="amount"]         ${updated_bid}
#    ${agree}=   Get Matching Xpath Count     xpath=//input[@name="agree"]
#    run keyword if  '${agree}' == '1'     Click element   xpath=//input[@name="agree"]
    sleep   3
    Click Element       xpath=//button[@ng-click="changeBid()"]
    sleep   3
    reload page

Завантажити документ в ставку
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[1]} ==  file
  ...    ${ARGUMENTS[2]} ==  tenderId
  Click Element       xpath=//a[@ui-sref="tenderView.documents"]
  Wait until page contains element    xpath=//button[@ng-click="uploadDocument()"]
  Click element       xpath=//button[@ng-click="uploadDocument()"]
  Click element       xpath=//button[@ng-model="file"]
  sleep     3
  Choose file         xpath=//input[@type="file"]    ${ARGUMENTS[1]}
  Click element         xpath=//button[@ng-click="upload()"]
# ==================
# === Links for auction ===
Отримати посилання на аукціон для глядача
  [Arguments]  @{ARGUMENTS}
  reload page
  sleep     3
  Click element     xpath=//a[@ui-sref="tenderView.auction"]
  Wait until page contains element      xpath=//a[@class="auction-link ng-binding"]     10
  ${result}=    Get Element Attribute  xpath=//a[@target="_blank"]@href
  ${result}=    convert to string  ${result}
  log to console    ${result}
  [return]  ${result}


Отримати посилання на аукціон для учасника
  [Arguments]  @{ARGUMENTS}
  reload page
  sleep     3
  Click element     xpath=//a[@ui-sref="tenderView.auction"]
  Wait until page contains element      xpath=//a[@class="auction-link ng-binding"]     10
  ${result}=    Get Element Attribute  xpath=//a[@target="_blank"]@href
  ${result}=    convert to string  ${result}
  log to console    ${result}
  [return]  ${result}
# =========================


Change_day_to_month
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]}  ==  date
  ${day}=   Get Substring   ${ARGUMENTS[0]}   0   2
  ${month}=   Get Substring   ${ARGUMENTS[0]}  3   6
  ${rest}=   Get Substring   ${ARGUMENTS[0]}   5
  ${return_value}=   Convert To String  ${month}${day}${rest}
  [return]  ${return_value}

#
Отримати інформацію про auctionPeriod.startDate
  [Arguments]  ${element}  ${item}
  Wait For Element With Reload    ${tender_data_${element}}    1
  ${start_date} =   Отримати дату та час    ${element}    1    ${item}
  ${result} =    get_time_with_offset    ${start_date}
  [return]  ${result}
#
Отримати дату та час
  log to console   Searching for UFOs - ${ARGUMENTS[0]}
  Go to     http://ea-trunk.newtend.com/provider/#/home/
  sleep     2
  ${auction_number}=    convert to string   ${ARGUMENTS[0]}
  Input text   xpath=//input[@type="search"]     ${auction_number}
  click element     xpath=//div[@ng-click="search()"]
  sleep     2
  ${date}=  отримати текст із поля і показати на сторінці  xpath=//span[@ng-if="tender.data.auctionPeriod"]
  ${date}=  get_time_with_offset      ${date}
  log to console  ${date}
  [return]  ${date}

Отримати інформацію про auctionPeriod.endDate
  Fail  На майданчику newtend не відображається поле Дата завершення аукціону

Підтвердити постачальника
  [Arguments]  ${username}  ${tender_uaid}  ${award_num}
  click element  xpath=//a[@ui-sref="tenderView.auction"]
  sleep     2
  click element  xpath=//div[@class="col-xs-4 status ng-binding pending"]
  sleep     2
  click element  xpath=//button[@ng-click="decide('active')"]
  sleep     2
  click element  xpath=//button[@ng-click="accept()"]
  log to console    Its ok - qualified

# Fourth scenario edited
Підтвердити підписання контракту
  [Arguments]  ${username}  ${tender_uaid}  ${award_num}
  click element  xpath=//a[@ui-sref="tenderView.auction"]
  sleep     2
  click element  xpath=//button[@ng-click="closeBids(lot.awardId, lot.contractId)"]
  sleep     2
  input text   id=contractNumber    Contruct signed
  click element  xpath=//button[@ng-click="closeBids()"]
