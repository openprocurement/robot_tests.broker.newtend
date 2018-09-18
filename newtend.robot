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
${locator.e_logo}                           xpath=//a[@href="#/home/?pageNum=1&query=&status=&userOnly=&procurementMethodType=&region=&amount_gte=&amount_lte=&dgf_id=&auction_start=&procuring=&lease=&quantity_lte=&quantity_gte=&saleOnly="]
# SSP Locators
${locator.asset_create}     xpath=//a[@href="#/privatization/assets/create"]
${locator.all_assets}       xpath=//a[@href="#/privatization/assets?page=1"]
${locator.my_assets}        xpath=//a[@href="#/privatization/assets?page=1&owner=true"]
${locator.all_lots}         xpath=//a[@href="#/privatization/lots?page=1"]
${locator.my_lots}          xpath=//a[@href="#/privatization/lots?page=1&owner=true"]


*** Keywords ***
Підготувати дані для оголошення тендера
  [Arguments]  ${username}  ${tender_data}  ${role_name}
  ${tender_data}=   update_data_for_newtend_new   ${role_name}   ${tender_data}
  [Return]   ${tender_data}

Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  ...      ${ARGUMENTS[0]} ==  username

  ${alias}=   Catenate   SEPARATOR=   role_    ${ARGUMENTS[0]}
  Set Global Variable   ${BROWSER_ALIAS}   ${alias}

  Open Browser
  ...      ${USERS.users['${ARGUMENTS[0]}'].homepage}
  ...      ${USERS.users['${ARGUMENTS[0]}'].browser}
  ...      alias=${BROWSER_ALIAS}
  Set Window Size   @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
  Run Keyword If   '${ARGUMENTS[0]}' != 'Newtend_Viewer'   Login    ${ARGUMENTS[0]}
  Log To Console    ''alias'' - '${BROWSER_ALIAS}'

Login
  [Arguments]  @{ARGUMENTS}
#  Logs in as Auction owner, who can create Fin auctions
  Wait Until Page Contains Element   id=password   20
  Input Text   id=view-email   ${USERS.users['${ARGUMENTS[0]}'].login}
  Input Text   id=password   ${USERS.users['${ARGUMENTS[0]}'].password}
  Click Element   id=edit-tender-btn
  Sleep     3
# Changing the Language to Ukraine
  Click Element    xpath=//a[@ng-click="vm.setLanguage('uk')"]
  Sleep     3
  Run Keyword If  '${ARGUMENTS[0]}' == 'Newtend_Owner'
  ...  Run Keywords
  ...  Click Element     xpath=//a[@class="ng-binding ng-scope dropdown-toggle"]
  ...  AND  Sleep     2
  ...  AND  Click Element     xpath=//a[@href="/auction"]
  ...  AND  Sleep     3
  Log To Console   Success logging in as Some one - ${ARGUMENTS[0]}

# ===================================
#  Small Scale Privatization create
# ===================================

# Create asset
Створити об'єкт МП
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...       ${ARGUMENTS[0]} == username
  ...       ${ARGUMENTS[1]} == tender_data
  # Filling all the fields
  Sleep     3
  Click Element             xpath=//a[@href="#/privatization/assets/create"]
  Sleep     3
  : FOR   ${I}  IN RANGE    1   5
  \   ${titles_count}=      Get Matching Xpath Count     xpath=//input[@id="asset-title"]
  \   Exit For Loop If      '${titles_count}' > '0'
  \   Sleep   3

  # SSP Main Fields
  ${sspTitileUA}=       Get From Dictionary     ${ARGUMENTS[1].data}    title
  ${sspTitileEU}=       Get From Dictionary     ${ARGUMENTS[1].data}    title_en
  ${sspTitileRU}=       Get From Dictionary     ${ARGUMENTS[1].data}    title_ru

  ${sspDecisionUA}=     Get From Dictionary     ${ARGUMENTS[1].data}     description
  ${sspDecisionEU}=     Get From Dictionary     ${ARGUMENTS[1].data}     description_en
  ${sspDecisionRU}=     Get From Dictionary     ${ARGUMENTS[1].data}     description_ru
  # Main fields fill
  Click Element     id=asset-title
  Input Text        id=asset-title          ${sspTitileUA}
  Sleep     1
  Input Text        id=asset-description    ${sspDecisionUA}
  Sleep     1

  # Decisions Extraction
  ${decisions}=        Get From Dictionary     ${ARGUMENTS[1].data}   decisions
  ${decisionDate}=     Get From Dictionary     ${decisions[0]}   decisionDate
  ${decisionID}=       Get From Dictionary     ${decisions[0]}   decisionID
  ${decisionTitle}=    Get From Dictionary     ${decisions[0]}   title
  ${decisionTitleEn}=  Get From Dictionary     ${decisions[0]}   title_en
  ${decisionTitleRu}=  Get From Dictionary     ${decisions[0]}   title_ru
  # Decisions fill
  Click Element     id=asset-create-decisions-0-decision-link-value
  Sleep    2
  Click Element     id=asset-create-decisions-0-decision-menu-item-asset
  Sleep    1
  Click Element     id=asset-create-decisions-0-id
  Input Text        id=asset-create-decisions-0-id       ${decisionID}
  Sleep     1
  Input Text        id=asset-create-decisions-0-decision-title    ${decisionTitle}
  Sleep     1
  Input Text        id=asset-create-decisions-0-decsion-date-date    ${decisionDate}
  Sleep     1

  Log To Console    -==Decisions list==- ${decisionTitleRu}

  # Items info extract
  ${item_number}=   substract             ${NUMBER_OF_ITEMS}    1
  ${item_number}=   Convert To Integer    ${item_number}
  log to console    number of items - 1 ==== '${NUMBER_OF_ITEMS}'
  : FOR   ${INDEX}  IN RANGE    0    ${NUMBER_OF_ITEMS}
  \   ${items}=         Get From Dictionary   ${ARGUMENTS[1].data}         items
  \   ${item[x]}=                       Get From List             ${items}       ${INDEX}
  \   ${item_description}=              Get From Dictionary       ${item[x]}     description
  \   Log to Console    item-0-description '${INDEX}' - '${item_description}'
  \   ${item_quantity}=                 Get From Dictionary       ${item[x]}     quantity
  \   ${item_quantity}=     Convert To String    ${item_quantity}
  \   Log To Console        units number - '${item_quantity}'
  \   ${unit}=                          Get From Dictionary       ${item[x]}     unit
  \   ${unit_code}=                     Get From Dictionary       ${unit}        code
  \   Log to console      unit code - ${unit_code}
  \   ${unit_name}=                     Get From Dictionary       ${unit}        name
  \   ${classification}=                Get From Dictionary       ${item[x]}     classification
  \   ${classification_scheme}=         Get From Dictionary       ${classification}    scheme
  \   ${classification_description}=    Get From Dictionary       ${classification}    description
  \   ${classification_id}=             Get From Dictionary       ${classification}    id
  \   ${additionalClassification}=      Get From Dictionary       ${item[x]}     additionalClassifications
  \   ${additionalClassScheme}=         Get From Dictionary       ${additionalClassification[0]}    scheme
  \   ${additionalClassDescription}=    Get From Dictionary       ${additionalClassification[0]}    description
  \   ${additionalClassId}=             Get From Dictionary       ${additionalClassification[0]}    id
  \   Log To Console    addClass ID - ${additionalClassId}
  \   ${itemAddress}=          Get From Dictionary     ${item[x]}       address
  \   ${itemAddressZip}=       Get From Dictionary     ${itemAddress}   postalCode
  \   ${itemAddressCountry}=   Get From Dictionary     ${itemAddress}   countryName
  \   ${itemAddressStreet}=    Get From Dictionary     ${itemAddress}   streetAddress
  \   ${itemAddressRegion}=    Get From Dictionary     ${itemAddress}   region
  \   ${itemAddressCity}=      Get From Dictionary     ${itemAddress}   locality
  \   ${registrationDetails}=   Get From Dictionary    ${item[x]}   registrationDetails
  \   ${registrationStatus}=    Get From Dictionary    ${registrationDetails}   status
  # Items Fill
  \   ${item_descr}=    Get Webelements     xpath=//input[@ng-model="item.description"]
  \   Input Text    ${item_descr[-1]}       ${item_description}
  \   ${item_quantity_field}=     Get Webelements     xpath=//input[@ng-model="item.quantity"]
  \   Input Text    ${item_quantity_field[-1]}    ${item_quantity}
  \   ${unit_name_field}=     Get Webelements     xpath=//a[@id="asset-create-items-0-unit-link-value"]
  \   Focus   ${unit_name_field[-1]}
  \   Click Element   ${unit_name_field[-1]}
  \   Sleep     2
  \   ${need_measure}=   Get Webelements    xpath=//a[contains(text(), '${unit_name}')]
  \   Focus           ${need_measure[-1]}
  \   Click Element   ${need_measure[-1]}
  \   Sleep     1
  # Classificators fill
  \   ${item_class}=        Get Webelement     id=asset-create-items-${INDEX}-classification-value
  \   Focus             ${item_class}
  \   Click Element     ${item_class}
  \   Sleep     4
  \   Click Element     xpath=//input[@id="classifier-search-field"]
  \   Input Text        xpath=//input[@id="classifier-search-field"]        ${classification_id}
  \   Sleep     4
  \   Click Element     xpath=//span[contains(text(), '${classification_id}')]
  \   Sleep     1
  \   Click Element     xpath=//button[@id="select-classifier-btn"]
  \   Sleep     1
  \   ${item_add_class}=    Get Webelement     id=asset-create-items-${INDEX}-classification-additional-value
  \   Click Element     ${item_add_class}
  \   Sleep     1
  \   Click Element     xpath=//input[@id="classifier-search-field"]
  \   Input Text        xpath=//input[@id="classifier-search-field"]    ${additionalClassId}
  \   Sleep  3
  \   Click Element     xpath=//span[contains(text(), '${additionalClassId}')]
  \   Sleep     1
  \   Click Element     xpath=//button[@id="select-classifier-btn"]
  \   Sleep     1
  # Address fill
  \   Click Element     id=asset-create-items-${INDEX}-address-address-str
  \   newtend.Заповнити форму адреса  ${itemAddressCountry}  ${itemAddressZip}  ${itemAddressRegion}  ${itemAddressCity}  ${itemAddressStreet}
  # Registration status fill
  \   Focus            id=asset-create-items-${INDEX}-rd-status-link-value
  \   Sleep     1
  \   Click Element    id=asset-create-items-${INDEX}-rd-status-link-value
  \   ${adaptRegistrationStatus}=    convert_nt_string_to_ssp_string      ${registrationStatus}
  \   ${status}=       Get Webelements     xpath=//a[contains(text(), '${adaptRegistrationStatus}')]
  \   Click Element    ${status[-1]}
  \   Sleep  2
  \   Run Keyword If  '${registrationStatus}' == 'complete'  Run Keywords
  \  ...  Input Text  xpath=//input[@id='asset-create-items-${item_description.split(':')[0]}-rd-id']  555
  \  ...  AND  Input Text  id=asset-create-items-${item_description.split(':')[0]}-rd-date-date  ${decisionDate}
  \  ${new_item_cross}=    Get Webelements     xpath=//a[@ng-click="vm.addItemClick()"]
  \  Run Keyword If   '${INDEX}' < '${item_number}'   Click Element    ${new_item_cross[-1]}

  # Asset Holder
  ${assetHolderName}=  Get From Dictionary     ${ARGUMENTS[1].data.assetHolder}     name
  ${assetHolder}=      Get From Dictionary     ${ARGUMENTS[1].data.assetHolder}    address
  ${holderCountry}=    Get From Dictionary     ${assetHolder}   countryName
  ${holderCity}=       Get From Dictionary     ${assetHolder}   locality
  ${holderZip}=        Get From Dictionary     ${assetHolder}   postalCode
  ${holderRegion}=     Get From Dictionary     ${assetHolder}   region
  ${holderStreet}=     Get From Dictionary     ${assetHolder}   streetAddress
  Log To Console    -== Holder country==- ${holderCountry}
  # Asset Holder Contact Point
  ${assetHolderContact}=   Get From Dictionary     ${ARGUMENTS[1].data.assetHolder}    contactPoint
  ${holderEmail}=      Get From Dictionary     ${assetHolderContact}   email
  ${holderFax}=        Get From Dictionary     ${assetHolderContact}   faxNumber
  ${holderName}=       Get From Dictionary     ${assetHolderContact}   name
  ${holderPhone}=      Get From Dictionary     ${assetHolderContact}   telephone
  ${holderUrl}=        Get From Dictionary     ${assetHolderContact}   url
  Log To Console    -== Holder Name==- ${holderName}
  # Asset Holder Identifier
  ${assetHolderID}=    Get From Dictionary     ${ARGUMENTS[1].data.assetHolder}    identifier
  ${holderID}=         Get From Dictionary     ${assetHolderID}    id
  ${holderLegalName}=  Get From Dictionary     ${assetHolderID}    legalName
  ${holderEDR}=        Get From Dictionary     ${assetHolderID}    scheme
  Sleep     1
  Focus             id=asset-create-holder-organization-name
  Click Element     id=asset-create-holder-organization-name
  Input Text        id=asset-create-holder-organization-name   ${assetHolderName}
  Sleep     1
  Click Element     xpath=//input[@id="asset-create-holder-organization-address-str"]
  # holder adress
  newtend.Заповнити форму адреса  ${holderCountry}  ${holderZip}  ${holderRegion}  ${holderCity}  ${holderStreet}
  # Asset Holder Identifier
  Input Text    id=asset-create-holder-identifiers-0-id          ${holderID}
  Input Text    id=asset-create-holder-identifiers-0-legal-name   ${holderLegalName}
  Sleep     1
  Click Element   id=asset-create-holder-identifiers-0-scheme-link-value
  Sleep     3
  Click Element   id=asset-create-holder-identifiers-0-scheme-menu-item-${holderEDR}

  # Asset Holder Addition Identifier
  Input Text    id=asset-create-holder-identifiers-additional-0-id          ${holderID}
  Input Text    id=asset-create-holder-identifiers-additional-0-legal-name   ${holderLegalName}
  Click Element   id=asset-create-holder-identifiers-additional-0-scheme-link-value
  Sleep     3
  Click Element   id=asset-create-holder-identifiers-additional-0-scheme-menu-item-${holderEDR}
  Sleep     1

  # Asset Holder Contact Point
  newtend.Ввести контакти балансоутримувача  contact-point  ${holderName}  ${holderEmail}  ${holderPhone}  ${holderFax}  ${holderUrl}

  # Asset Holder additional Contact Points
  ${assetHolderAddContPoint}=    Get From Dictionary   ${ARGUMENTS[1].data.assetHolder}  additionalContactPoints
  ${holderAddEmail}=    Get From Dictionary     ${assetHolderAddContPoint[0]}   email
  ${holderAddFax}=      Get From Dictionary     ${assetHolderAddContPoint[0]}   faxNumber
  ${holderAddName}=     Get From Dictionary     ${assetHolderAddContPoint[0]}   name
  ${holderAddPhone}=    Get From Dictionary     ${assetHolderAddContPoint[0]}   telephone
  ${holderAddUrl}=      Get From Dictionary     ${assetHolderAddContPoint[0]}   url

  # Fill Asset Holder Additional Contact Point Fields
  newtend.Ввести контакти балансоутримувача  contact-point-additional  ${holderAddName}  ${holderAddEmail}  ${holderAddPhone}
  ...  ${holderAddFax}  ${holderAddUrl}

  Focus          id=submit-btn
  Click Element  id=submit-btn
  Sleep     10
  Click Element    id=publish-btn
  Sleep     3
  Wait Until Page Contains Element   id=asset-view-asset-id   30
  ${TENDER_UAID}=         Get Text   id=asset-view-asset-id
  [Return]  ${TENDER_UAID}

Оновити сторінку з об'єктом МП
  [Arguments]  ${username}  ${tender_uaid}
  Switch browser   ${BROWSER_ALIAS}
  Reload Page
  Sleep     2

Пошук об’єкта МП по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  Log To Console   Searching for UFOs - ${ARGUMENTS[1]}
  ${obj_type}=  Set Variable  assets
  newtend.Пошук  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}  ${obj_type}

# Asset info
Отримати інформацію із об'єкта МП
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  ${field_name}
  Log To Console    -==Main Args==- @{ARGUMENTS}
  Run Keyword And Return  Отримати інформацію об'єкта про ${ARGUMENTS[2]}

Отримати інформацію об'єкта про assetID
  ${assetID}=   Get Text   id=asset-view-asset-id
  Log To Console    -==assetID==- ${assetID}
  [Return]  ${assetID}

# Date asset creation
Отримати інформацію об'єкта про date
  ${dateCreate}=    Get Text    id=asset-view-date-create
  Log To Console    -==date==- ${dateCreate}
  [Return]  ${dateCreate}

Отримати інформацію об'єкта про dateModified
  ${dateModified}=  Get Text  xpath=(//*[@id="asset-view-date-create"])[2]
  Log To Console    -==date==- ${dateModified}
  [Return]  ${dateModified}

# Rectification End date
Отримати інформацію об'єкта про rectificationPeriod.endDate
  ${rectificationEndDate}=    Get Text    id=asset-view-rp-end-date
  Log To Console    -==rectif==- ${rectificationEndDate}
  [Return]  ${rectificationEndDate}

# pending = Опубліковано. Очікування інформаційного повідомлення
Отримати інформацію об'єкта про status
  ${status}=    Get Text    id=asset-view-status
  ${t_status}=  convert_nt_string_to_ssp_string  ${status}
  Log to Console    -==trans status==- ${t_status}
  [Return]  ${t_status}

# заголовку об'єкта МП
Отримати інформацію об'єкта про title
  ${asset_title}=   Get Text    id=asset-view-title
  [Return]  ${asset_title}

# опису об'єкта МП
Отримати інформацію об'єкта про description
  ${asset_descr}=   Get Text    id=asset-view-description
  [Return]  ${asset_descr}

# найменування рішення про приватизацію об'єкта МП
Отримати інформацію об'єкта про decisions[0].title
  ${decision_title}=    Get Text    id=asset-view-decisions-title
  [Return]  ${decision_title}

# дати прийняття рішення про приватизацію об'єкта МП
Отримати інформацію об'єкта про decisions[0].decisionDate
  ${text}=     Get Text    id=asset-view-decisions-decision-date
  ${decision_date}=  Set Variable  ${text.split(': ')[1].split(' ')[0]}
  [Return]  ${decision_date}

# номера рішення про включення до переліку об'єкта МП
Отримати інформацію об'єкта про decisions[0].decisionID
  ${text}=    Get Text    id=asset-view-decisions-decision-id
  ${decisionId}=  Set Variable  ${text.split(': ')[1]}
  [Return]  ${decisionID}

# назви організації балансоутримувача об'єкта МП
Отримати інформацію об'єкта про assetHolder.name
  ${holderName}=    Get Text    id=asset-view-holder-name
  [Return]  ${holderName}

# схеми ідентифікації організації балансоутримувача
Отримати інформацію об'єкта про assetHolder.identifier.scheme
  ${text}=  Get Text    xpath=//identifier-view[@object-id="asset-view-holder-identifier"]
  ${holderScheme}=  Get Lines Containing String    ${text}   UA-EDR
  ${holderScheme}=    Set Variable    ${holderScheme.split(' ')[0]}
  [Return]  ${holderScheme}

# ідентифікатора організації балансоутримувача
Отримати інформацію об'єкта про assetHolder.identifier.id
  ${text}=  Get Text    xpath=//identifier-view[@object-id="asset-view-holder-identifier"]
  ${holderId}=  Get Lines Containing String    ${text}   UA-EDR
  ${holderId}=    Set Variable    ${holderId.split(' ')[1]}
  [Return]  ${holderID}

# схеми ідентифікації організації розпорядника
Отримати інформацію об'єкта про assetCustodian.identifier.scheme
  ${text}=    Get Text    xpath=//identifier-view[@object-id="asset-view-custodian-identifier"]
  ${custScheme}=    Get Lines Containing String    ${text}   UA-EDR
  ${custScheme}=    Set Variable    ${custScheme.split(' ')[0]}
  [Return]  ${custScheme}

# ідентифікатора організації розпорядника
Отримати інформацію об'єкта про assetCustodian.identifier.id
  ${text}=    Get Text    xpath=//identifier-view[@object-id="asset-view-custodian-identifier"]
  ${custID}=        Get Lines Containing String    ${text}   UA-EDR
  ${custID}=  Set Variable  ${custID.split(' ')[1]}
  [Return]  ${custID}

# юридичної назви організації розпорядника
Отримати інформацію об'єкта про assetCustodian.identifier.legalName
  ${custName}=  Get Text    id=NaN
  [Return]  ${custName}

# імені контактної особи організації розпорядника
Отримати інформацію об'єкта про assetCustodian.contactPoint.name
  ${custContactInfo}=   Get Text    xpath=//contact-point-view[@object-id='asset-view-custodian-contact-point']
  ${custContName}=  Get Lines Containing String	  ${custContactInfo}   Назва
  ${custContName}=  Get Substring   ${custContName}     7
  [Return]  ${custContName}

# контактного номера організації розпорядника
Отримати інформацію об'єкта про assetCustodian.contactPoint.telephone
  ${text}=   Get Text    xpath=//contact-point-view[@object-id='asset-view-custodian-contact-point']
  ${custContPhone}=  Run Keyword If  '${ROLE}' == 'tender_owner'  Get Lines Containing String  ${text}  Телефон
  ...                ELSE IF         '${ROLE}' == 'viewer'  Get Lines Containing String  ${text}  Phone
  ${custContPhone}=  Set Variable  ${custContPhone.split(': ')[1]}
  [Return]  ${custContPhone}

# адреси електронної пошти організації розпорядника
Отримати інформацію об'єкта про assetCustodian.contactPoint.email
  ${custContactInfo}=   Get Text    xpath=//contact-point-view[@object-id='asset-view-custodian-contact-point']
  ${custContEmail}=  Get Lines Containing String	  ${custContactInfo}   Електронна
  ${custContEmail}=  Get Substring  ${custContEmail}    18
  [Return]  ${custContEmail}

# типу документа про інформацію по оприлюдненню інформаційного повідомлення
Отримати інформацію об'єкта про documents[0].documentType
  ${file_path}=     Get Webelements  xpath=//a[@href="https://prozorro.sale/info/ssp_details"]
  Focus     ${file_path[-1]}
  ${file_name}=     Get Text    ${file_path[1]}
  ${t_name}=     convert_nt_string_to_ssp_string     ${file_name}
  [Return]  ${t_name}

# Active info
Отримати інформацію з активу об'єкта МП
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  ${itemId}
  ...      ${ARGUMENTS[3]} ==  ${field_name}
  Log To Console    -==Main Item Args==- @{ARGUMENTS}
  Run Keyword And Return  Отримати інформацію актива про ${ARGUMENTS[3]}   ${ARGUMENTS[2]}

# Item Description
Отримати інформацію актива про description
  [Arguments]   ${itemId}
  Sleep     2
  Log To Console    -==arg--- ${itemId}
  ${itemInfo}=   Get Webelement   xpath=//div[@class="privatization-item-list-item"][contains(., '${itemId}')]/..//div[@ng-bind="vm.item.description"]
  ${itemDescr}=     Get Text   ${itemInfo}
  [Return]  ${itemDescr}

# Item Classification scheme
Отримати інформацію актива про classification.scheme
  [Arguments]    ${itemId}
  ${itemInfo}=   Get Webelement   xpath=//div[@class="privatization-item-list-item"][contains(., '${itemId}')]/..//span[@id="classifier-scheme-"]
  ${scheme}=     Get Text    ${itemInfo}
  [Return]  ${scheme}

# item Classification ID
Отримати інформацію актива про classification.id
  [Arguments]   ${itemId}
  ${itemInfo}=   Get Webelement   xpath=//div[@class="privatization-item-list-item"][contains(., '${itemId}')]/..//span[@id="classifier-id-"]
  ${classID}=    Get Text    ${itemInfo}
  [Return]  ${classID}

Отримати інформацію актива про unit.name
  [Arguments]   ${itemId}
  ${unitName}=   Get WebElement   xpath=//div[@class="privatization-item-list-item"][contains(., '${itemId}')]/..//span[@class="unit ng-binding"]
  ${unitName}=  Get Text  ${unitName}
  ${unitName}=  convert_nt_string_to_ssp_string  ${unitName}
  Log To Console    -==unit Name==- ${unitName}
  [Return]  ${unitName}

Отримати інформацію актива про quantity
  [Arguments]   ${itemId}
  ${itemInfo}=   Get Webelement     xpath=//div[@class="privatization-item-list-item"][contains(., '${itemId}')]/..//div[@ng-bind="vm.item.quantity"]
  ${quantity}=   Get Text           ${itemInfo}
  ${quantity}=   convert_to_float   ${quantity}
  [Return]  ${quantity}

Отримати інформацію актива про registrationDetails.status
  [Arguments]   ${itemId}
  ${itemInfo}=   Get Webelement   xpath=//div[@class="privatization-item-list-item"][contains(., '${itemId}')]/..//div[@id="reg-details-status-"]
  ${iStatus}=    Get Text    ${itemInfo}
  ${iStatus}=    convert_nt_string_to_ssp_string    ${iStatus}
  [Return]  ${iStatus}

# Docs Upload Process
Завантажити ілюстрацію в об'єкт МП
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  ${image_path}
  Focus     id=document-upload-btn
  Click Element     id=document-upload-btn
  Sleep     3
  Click Element  id=asset-document-upload-document-type-link-value
  Sleep  2
  Click Element  id=asset-document-upload-document-type-menu-item-illustration
  Sleep  1
  # === Mega Hack for document Upload ===
  Execute Javascript  $('#asset-document-upload-to-upload-btn-add').click()
  Sleep  2
  Choose File         xpath=//input[@type='file']    ${ARGUMENTS[2]}
  Sleep  1
  Input Text  xpath=//input[@id='asset-document-upload-title']  ${ARGUMENTS[2].split('/')[-1]}
  Focus  id=asset-document-upload-upload-btn
  # Confirm file Upload
  Click Element  id=asset-document-upload-upload-btn
  Sleep  10

Завантажити документ в об'єкт МП з типом
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}  ${documentType}
  Click Element  id=asset-document-upload-document-type-link-value
  Sleep  2
  Click Element  id=asset-document-upload-document-type-menu-item-${documentType}
  Execute Javascript  $('#asset-document-upload-to-upload-btn-add').click()
  Sleep  2
  Choose File  xpath=//input[@type='file']  ${filepath}
  Sleep  1
  Input Text  xpath=//input[@id='asset-document-upload-title']  ${filepath.split('/')[-1]}
  Focus  id=asset-document-upload-upload-btn
  Click Element  id=asset-document-upload-upload-btn
  Sleep  10

Завантажити документ для видалення об'єкта МП
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}
  Focus  id=document-upload-btn
  Click Element  id=document-upload-btn
  Sleep  2
  newtend.Завантажити документ в об'єкт МП з типом  ${username}  ${tender_uaid}  ${filepath}  cancellationDetails
  Sleep  20

Отримати документ
  [Arguments]  ${username}  ${tender_uaid}  ${doc_id}
  ${file_name}=   Get Text   xpath=//a[contains(text(), '${doc_id}')]
  ${url}=   Get Element Attribute   xpath=//a[contains(text(), '${doc_id}')]@href
  download_file   ${url}  ${file_name}  ${OUTPUT_DIR}
  [Return]  ${file_name}

# Edit Asset
Внести зміни в об'єкт МП
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  newtend.Перейти до редагування  ${username}  ${tender_uaid}  asset
  Clear Element Text  xpath=//input[@id='asset-${fieldname}']
  Input Text  xpath=//input[@id='asset-${fieldname}']  ${fieldvalue}
  newtend.Зберегти після редагування
  Sleep  2

Внести зміни в актив об'єкта МП
  [Arguments]  ${username}  ${item_id}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  newtend.Перейти до редагування  ${username}  ${tender_uaid}  asset
  ${quantity}=  Convert To String  ${fieldvalue}
  Run Keyword If   '${fieldname}' == 'quantity'
  ...  Run Keywords
  ...  Clear Element Text  id=asset-create-${item_id}-quantity
  ...  AND  Input Text  id=asset-create-${item_id}-quantity  ${quantity}
  newtend.Зберегти після редагування
  Sleep  2

Додати актив до об'єкта МП
  [Arguments]  ${username}  ${tender_uaid}  ${item}
  newtend.Перейти до редагування  ${username}  ${tender_uaid}  asset
  Focus  id=asset-create-0-btn-add-item
  Sleep  1
  Click Element  id=asset-create-0-btn-add-item
  Sleep  2
  Input Text  xpath=//input[@id='asset-create-1-description']  ${item.description}
  Click Element  id=asset-create-1-classification-value
  Sleep  2
  Input Text  id=classifier-search-field  ${item.classification.id}
  Sleep  4
  Click Element  xpath=//span[contains(text(), '${item.classification.id}')]
  Sleep  1
  Click Element  xpath=//button[@id="select-classifier-btn"]
  Sleep  1
  ${id}=  Set Variable  ${item.description.split(':')[0]}
  ${item_quantity}=  Convert To String  ${item.quantity}
  Input Text  id=asset-create-${id}-quantity  ${item_quantity}
  Click Element  id=asset-create-1-unit-link-value
  Sleep  2
  ${unit_name_field}=  Get Webelements  xpath=//a[contains(text(), '${item.unit.name}')]
  Focus  ${unit_name_field[-1]}
  Sleep  1
  Click Element  ${unit_name_field[-1]}
  Click Element  id=asset-create-1-address-address-str
  # adreess item
  newtend.Заповнити форму адреса  ${item.address.countryName}  ${item.address.postalCode}  ${item.address.region}
  ...  ${item.address.locality}  ${item.address.streetAddress}
  Click Element  id=asset-create-1-rd-status-link-value
  Sleep  2
  ${registrationStatus}=  convert_nt_string_to_ssp_string  ${item.registrationDetails.status}
  ${reg_st_field}=  Get Webelements  xpath=//a[contains(text(), '${registrationStatus}')]
  Focus  ${reg_st_field[-1]}
  Click Element  ${reg_st_field[-1]}
  Sleep  2
  newtend.Зберегти після редагування

Отримати кількість активів в об'єкті МП
  [Arguments]  ${username}  ${tender_uaid}
  newtend.Пошук об’єкта МП по ідентифікатору  ${username}  ${tender_uaid}
  ${number_items}=  Get Matching Xpath Count  xpath=//*[text()='Опис об’єкту продажу']
  [Return]  ${number_items}

Видалити об'єкт МП
  [Arguments]  ${username}  ${tender_uaid}
  newtend.Пошук об’єкта МП по ідентифікатору  ${username}  ${tender_uaid}
  Focus  id=delete-btn
  Sleep  1
  Click Element  id=delete-btn
  Sleep  2
  Focus  id=delete-btn
  Click Element  id=delete-btn

#Lot--------------------------------------------------------------------------------------------------------------------
Створити лот
  [Arguments]  ${username}  ${tender_data}  ${asset_uaid}
  newtend.Пошук об’єкта МП по ідентифікатору  ${username}  ${asset_uaid}
  Focus  id=create-lot-btn
  Sleep  1
  Click Element  id=create-lot-btn
  Sleep  2
  Input Text  id=lot-create-0-decsion-date-date  ${tender_data.data.decisions[0].decisionDate}
  Click Element  id=lot-create-0-decision-link-value
  Sleep  1
  Click Element  id=lot-create-0-decision-menu-item-lot
  Input Text  xpath=//input[@id='lot-create-0-id']  ${tender_data.data.decisions[0].decisionID}
  Input Text  id=lot-create-sandbox-parameters   ${tender_data.data.sandboxParameters}
  Click Element  id=submit-btn
  Sleep  10
  Focus  id=set-composing-btn
  Sleep  1
  Click Element  id=set-composing-btn
  Sleep  10
  ${lot_id}=  Get Text  xpath=//*[@id="lot-view-lot-id"]/span
  [Return]  ${lot_id}

Пошук лоту по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}
  ${obj_type}=  Set Variable  lots
  newtend.Пошук  ${username}  ${tender_uaid}  ${obj_type}

Оновити сторінку з лотом
  [Arguments]  ${username}  ${tender_uaid}
  Switch browser   ${BROWSER_ALIAS}
  Reload Page
  Sleep     2

Додати умови проведення аукціону
  [Arguments]  ${username}  ${auction}  ${auction_index}  ${tender_uaid}
  Run Keyword  Додати умови проведення аукціону ${auction_index}    ${username}  ${tender_uaid}  ${auction}

Додати умови проведення аукціону 0
  [Arguments]  ${username}  ${tender_uaid}  ${auction}
  ${auction_date}=  Get From Dictionary  ${auction.auctionPeriod}  startDate
  # go auction page
  newtend.Пошук лоту по ідентифікатору  ${username}  ${tender_uaid}
  Focus  id=edit-auctions-conditions-btn
  Sleep  1
  Click Element  id=edit-auctions-conditions-btn
  Sleep  2
  # minimal step
  newtend.Ввести сумму та обрати валюту аукціону  minimal-step  ${auction.minimalStep.amount}  ${auction.minimalStep.currency}
  # auction start date
  Input Text  id=lot-auctions-auction-period-date  ${auction_date.split('T')[0]}
  Clear Element Text  xpath=//input[@ng-change='updateHours()']
  Input Text  xpath=//input[@ng-change='updateHours()']  ${auction_date.split('T')[1].split(':')[0]}
  Clear Element Text  xpath=//input[@ng-change='updateMinutes()']
  Input Text  xpath=//input[@ng-change='updateMinutes()']  ${auction_date.split('T')[1].split(':')[1]}
  # registration fee
  newtend.Ввести сумму та обрати валюту аукціону  registration-fee  ${auction.registrationFee.amount}  ${auction.registrationFee.currency}
  # amount
  newtend.Ввести сумму та обрати валюту аукціону  value  ${auction.value.amount}  ${auction.value.currency}
  # guarantee
  newtend.Ввести сумму та обрати валюту аукціону  guarantee  ${auction.guarantee.amount}  ${auction.guarantee.currency}
  # bank
  Input Text  id=lot-auctions-bank-account-bank-name  ${auction.bankAccount.bankName}
  Input Text  id=lot-auctions-bank-account-description  ${auction.bankAccount.description}
  Click Element  id=$lot-auctions-bank-account-identification-new-item-scheme-link-value
  Sleep  1
  Click Element  id=$lot-auctions-bank-account-identification-new-item-scheme-menu-item-${auction.bankAccount.accountIdentification[0].scheme}
  Input Text  xpath=//input[@name='id']  ${auction.bankAccount.accountIdentification[0].id}
  Input Text  id={{vm.objectId}-new-item-description  ${auction.bankAccount.accountIdentification[0].description}
  # save
  Click Element  xpath=(//*[@ng-click='vm.onSaveBtnClick()'])[1]
  Sleep  3

Додати умови проведення аукціону 1
  [Arguments]  ${username}  ${tender_uaid}  ${auction}
  Input Text  xpath=//input[@id='lot-auctions-tendering-duration-hidden']  ${auction.tenderingDuration}
  Input Text  xpath=//input[@object-id='lot-auctions-procurement-method-details']  ${auction.procurementMethodDetails}
  Click Element  id=set-verification-btn
  Sleep  5
  Click Element  id=set-verification-btn
  Sleep  3

Внести зміни в лот
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  newtend.Перейти до редагування  ${username}  ${tender_uaid}  lot
  Clear Element Text  id=lot-${fieldname}
  Input Text  id=lot-${fieldname}  ${fieldvalue}
  Click Element  id=btn-save
  Sleep  3

Внести зміни в актив лоту
   [Arguments]  ${username}  ${item_id}  ${tender_uaid}  ${field_name}  ${field_value}
   newtend.Перейти до редагування  ${username}  ${tender_uaid}  lot
   ${quantity}=  Convert To String  ${fieldvalue}
   Run Keyword If   '${fieldname}' == 'quantity'
   ...  Run Keywords
   ...  Clear Element Text  id=lot-items-${item_id}-quantity
   ...  AND  Input Text  id=lot-items-${item_id}-quantity  ${quantity}
   newtend.Зберегти після редагування
   Sleep  2

Внести зміни в умови проведення аукціону
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}  ${index}
  newtend.Перейти до редагування  ${username}  ${tender_uaid}  lot
  ${name_field}=  adapt_name_field  ${fieldname}
  ${value}=  Convert To String  ${fieldvalue}
  Run Keyword If  '${fieldname}' != 'auctionPeriod.startDate'  Edit amount field auctions  ${name_field}  ${value}
  Run Keyword If  '${fieldname}' == 'auctionPeriod.startDate'  Edit date auctions  ${fieldvalue}
  newtend.Зберегти після редагування

# INFO LOT
Отримати інформацію із лоту
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}
  Run Keyword And Return    Отримати інформацію із лоту про ${fieldname}

Отримати інформацію із лоту про lotID
  Run Keyword And Return    Get Text    xpath=//*[@id="lot-view-lot-id"]/span

Отримати інформацію із лоту про status
  Click Element  xpath=//button[@ng-click='vm.onSyncBtnClick()']
  Sleep  2
  ${value}=    Get Text    xpath=//*[text()='Статус']/following-sibling::div[1]/span
  Run Keyword And Return    convert_nt_string_to_ssp_string    ${value}

Отримати інформацію із лоту про date
  ${value}=   Get Text    //*[text()='Дата створення']/following-sibling::div[1]/span
  ${date}=  to_iso_date  ${value}
  [Return]  ${date}

Отримати інформацію із лоту про rectificationPeriod.endDate
  Click Element  xpath=//button[@ng-click='vm.onSyncBtnClick()']
  Sleep  2
  ${value}=    Get Text    //*[text()='Кінець періоду редагування']/following-sibling::div[1]/span/span
  ${date}=   to_iso_date  ${value}
  [Return]  ${date}

Отримати інформацію із лоту про relatedProcesses[0].relatedProcessID
  Run Keyword And Return    Get Text    xpath=//*[text()='Asset ID']/following-sibling::div[1]/span

Отримати інформацію із лоту про title
  Run Keyword And Return    Get Text    xpath=//*[text()='Найменування обʼєкту']/following-sibling::div[1]/span

Отримати інформацію із лоту про description
  Run Keyword And Return    Get Text    //*[text()='Опис обʼєкту']/following-sibling::div[1]/span

Отримати інформацію із лоту про lotHolder.name
  Run Keyword And Return    Get Text    id=lot-view-lot-holder-name

Отримати інформацію із лоту про lotHolder.identifier.scheme
  Run Keyword And Return    Get Text    id=lot-view-lot-holder-identifier-scheme

Отримати інформацію із лоту про lotHolder.identifier.id
  Run Keyword And Return    Get Text    id=lot-view-lot-holder-identifier-id

Отримати інформацію із лоту про lotCustodian.identifier.scheme
  Run Keyword And Return    Get Text    id=lot-view-lot-custodian-identifier-scheme

Отримати інформацію із лоту про lotCustodian.identifier.id
  Run Keyword And Return    Get Text    id=lot-view-lot-custodian-identifier-id

Отримати інформацію із лоту про lotCustodian.identifier.legalName
  Run Keyword And Return    Get Text    xpath=(//*[@id='NaN'])[1]

Отримати інформацію із лоту про lotCustodian.contactPoint.name
  Run Keyword And Return    Get Text    id=lot-view-lot-custodian-contact-point-name

Отримати інформацію із лоту про lotCustodian.contactPoint.telephone
  Run Keyword And Return    Get Text    id=lot-view-lot-custodian-contact-point-telephone

Отримати інформацію із лоту про lotCustodian.contactPoint.email
  Run Keyword And Return    Get Text    id=lot-view-lot-custodian-contact-point-email

Отримати інформацію із лоту про decisions[${n}].title
  ${index}=  get_index  ${n}  1
  Run Keyword And Return    Get Text    xpath=(//*[@id="lot-view-decisions-title"])[${index}]

Отримати інформацію із лоту про decisions[${n}].decisionDate
  ${index}=  get_index  ${n}  1
  ${value}=    Get Text    xpath=(//*[@id="lot-view-decisions-decision-date"])[${index}]
  [Return]    ${value.split(': ')[1].split(' ')[0]}

Отримати інформацію із лоту про decisions[${n}].decisionID
  ${index}=  get_index  ${n}  1
  ${value}=  Get Text  xpath=(//*[@id="lot-view-decisions-decision-id"])[${index}]
  [Return]    ${value.split(': ')[1]}

Отримати інформацію із лоту про dateModified
  ${value}=     Get Text    xpath=//*[text()='Дата останнього редагування']/following-sibling::div[1]/span
  [Return]  ${value}

# INFO AUCTION LOT

Отримати інформацію із лоту про auctions[${n}].procurementMethodType
  ${index}=  get_index  ${n}  1
  ${value}=  Get Text  xpath=(//*[@id="-tender-procurement-method-type"])[${index}]
  [Return]  ${value}

Отримати інформацію із лоту про auctions[${n}].status
  ${index}=  get_index  ${n}  2
  ${value}=    Get Text    xpath=(//*[text()='Статус']/following-sibling::div[1]/span)[${index}]
  [Return]  ${value}

Отримати інформацію із лоту про auctions[${n}].tenderAttempts
  ${index}=  get_index  ${n}  1
  ${value}=  Get Text  xpath=(//*[@id="-tender-attempts"])[${index}]
  Run Keyword And Return    Convert To Integer    ${value}

Отримати інформацію із лоту про auctions[${n}].value.amount
  ${index}=  get_index  ${n}  1
  ${value}=    Get Text    xpath=(//*[text()='Стартова ціна об’єкта']/following-sibling::div[1]//span)[${index}]
  Run Keyword And Return    Convert To Number   ${value.split(' ')[0]}

Отримати інформацію із лоту про auctions[${n}].minimalStep.amount
  ${index}=  get_index  ${n}  1
  ${value}=    Get Text    xpath=(//*[text()='Крок аукціону']/following-sibling::div[1]//span)[${index}]
  Run Keyword And Return    Convert To Number   ${value.split(' ')[0]}

Отримати інформацію із лоту про auctions[${n}].guarantee.amount
  ${index}=  get_index  ${n}  1
  ${value}=    Get Text    xpath=(//*[text()='Розмір гарантійного внеску']/following-sibling::div[1]//span)[${index}]
  Run Keyword And Return    Convert To Number   ${value.split(' ')[0]}

Отримати інформацію із лоту про auctions[${n}].registrationFee.amount
  ${index}=  get_index  ${n}  1
  ${value}=    Get Text    xpath=(//*[text()='Розмір реєстраційного внеску']/following-sibling::div[1]//span)[${index}]
  Run Keyword And Return    Convert To Number   ${value.split(' ')[0]}

Отримати інформацію із лоту про auctions[${n}].tenderingDuration
  Run Keyword And Return    Get Text  xpath=(//*[@id="-tender-duration"])[${n}]

Отримати інформацію із лоту про auctions[${n}].auctionPeriod.startDate
  ${index}=  get_index  ${n}  1
  ${value}=    Get Text    xpath=(//*[text()='Дата проведення аукціону']/following-sibling::div[1]//span)[${index}]
  ${data}=  to_iso_date  ${value}
  [Return]  ${data}

Отримати інформацію із лоту про auctions[${n}].auctionID
  Click Element  xpath=//button[@ng-click='vm.onSyncBtnClick()']
  Sleep  2
  ${index}=  get_index  ${n}  1
  Run Keyword And Return  Get Text  xpath=(//*[@id="-auction-id"])[${index}]

# INFO ASSET LOT
Отримати інформацію з активу лоту
  [Arguments]  ${username}  ${tender_uaid}  ${item}  ${fieldname}
  Run Keyword And Return  Отримати інформацію з активу лоту про ${fieldname}  ${item}

Отримати інформацію з активу лоту про description
  [Arguments]  ${itemId}
  Run Keyword And Return    Get Text    xpath=//div[@class="privatization-item-list-item"][contains(., '${itemId}')]/..//div[@ng-bind="vm.item.description"]

Отримати інформацію з активу лоту про classification.scheme
  [Arguments]  ${itemId}
  Run Keyword And Return    Get Text    xpath=//div[@class="privatization-item-list-item"][contains(., '${itemId}')]/..//span[@id="classifier-scheme-"]

Отримати інформацію з активу лоту про classification.id
  [Arguments]  ${itemId}
  Run Keyword And Return    Get Text    xpath=//div[@class="privatization-item-list-item"][contains(., '${itemId}')]/..//span[@id="classifier-id-"]

Отримати інформацію з активу лоту про unit.name
  [Arguments]  ${itemId}
  ${value}=     Get Text    xpath=//div[@class="privatization-item-list-item"][contains(., '${itemId}')]/..//span[@class="unit ng-binding"]
  Run Keyword And Return    convert_nt_string_to_ssp_string     ${value}

Отримати інформацію з активу лоту про registrationDetails.status
  [Arguments]  ${itemId}
  ${value}=     Get Text    xpath=//div[@class="privatization-item-list-item"][contains(., '${itemId}')]/..//div[@id="reg-details-status-"]
  Run Keyword And Return    convert_nt_string_to_ssp_string     ${value}

Отримати інформацію з активу лоту про quantity
  [Arguments]  ${itemId}
  ${value}=     Get Text    xpath=//div[@class="privatization-item-list-item"][contains(., '${itemId}')]/..//div[@ng-bind="vm.item.quantity"]
  Run Keyword And Return    Convert To Number   ${value}

Завантажити ілюстрацію в лот
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}
  Focus     id=document-upload-btn
  Click Element     id=document-upload-btn
  Sleep     3
  newtend.Завантажити документ в лот з типом  ${username}  ${tender_uaid}  ${filepath}  illustration

Завантажити документ в лот з типом
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}  ${type}
  Click Element  id=lot-document-upload-document-type-link-value
  Sleep  2
  Click Element  id=lot-document-upload-document-type-menu-item-${type}
  Execute Javascript  $('#lot-document-upload-to-upload-btn-add').click()
  Sleep  2
  Choose File  xpath=//input[@type='file']  ${filepath}
  Sleep  1
  Input Text  xpath=//input[@id='lot-document-upload-title']  ${filepath.split('/')[-1]}
  Focus  id=lot-document-upload-upload-btn
  Sleep  1
  Click Element  id=lot-document-upload-upload-btn
  Sleep  10

Завантажити документ для видалення лоту
  [Arguments]  ${username}  ${tender_uaid}  ${file_path}
  Focus     id=document-upload-btn
  Click Element     id=document-upload-btn
  Sleep  3
  newtend.Завантажити документ в лот з типом  ${username}  ${tender_uaid}  ${file_path}  cancellationDetails
  Sleep  20

Завантажити документ в умови проведення аукціону
  [Arguments]  ${username}  ${tender_uaid}  ${file_path}  ${doc_type}  ${index}
  newtend.Пошук лоту по ідентифікатору  ${username}  ${tender_uaid}
  Focus     id=edit-btn
  Click Element     id=edit-btn
  Sleep  3
  Click Element  id=lot-auction-document-upload-document-type-link-value
  Sleep  2
  Click Element  id=lot-auction-document-upload-document-type-menu-item-${doc_type}
  Execute Javascript  $('#lot-auction-document-upload-to-upload-btn-add').click()
  Sleep  2
  Choose File  xpath=//input[@type='file']  ${file_path}
  Sleep  1
  Input Text  xpath=//input[@id='lot-auction-document-upload-title']  ${filepath.split('/')[-1]}
  Focus  id=lot-auction-document-upload-upload-btn
  Sleep  1
  Click Element  id=lot-auction-document-upload-upload-btn
  Sleep  5
  Click Element  id=btn-save
  Sleep  5

Видалити лот
  [Arguments]  ${username}  ${tender_uaid}
  newtend.Пошук лоту по ідентифікатору  ${username}  ${tender_uaid}
  Click Element  xpath=//button[@ng-click='vm.onSyncBtnClick()']
  Sleep  2
  Focus  id=delete-btn
  Click Element  id=delete-btn
  Sleep  2
  Focus  id=delete-btn
  Click Element  id=delete-btn

# Procedure-------------------------------------------------------------------------------------------------------------
Активувати процедуру
  [Arguments]  ${username}  ${tender_uaid}
  newtend.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}

Пошук тендера по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}
  Run Keyword If   '${username}' == 'Newtend_Owner'    Go To    https://cdb2-dev.newtend.com/auction/#/home/?pageNum=1
  Run Keyword If   '${username}' != 'Newtend_Owner'    Go To    https://cdb2-dev.newtend.com/provider/#/home/?pageNum=1
  Sleep  2
  : FOR   ${INDEX}  IN RANGE    1   15
  \   Log To Console   .   no_newline=true
  \   Input Text  xpath=//input[@ng-model='searchData.query']  ${tender_uaid}
  \   Click Element     xpath=(//div[@ng-click="search()"])[1]
  \   Sleep  2
  \   ${auctions}=   Get Matching Xpath Count   xpath=//*[@class="title ng-binding"]
  \   Exit For Loop If  '${auctions}' > '0'
  \   Sleep  5
  \   Reload Page
  Click Element     xpath=//*[@class="title ng-binding"]
  Sleep  2

Оновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  Switch browser   ${BROWSER_ALIAS}
  Reload Page
  Sleep     2

Задати запитання на тендер
  [Arguments]  ${username}  ${auction_uaid}  ${question_data}
  newtend.Пошук тендера по ідентифікатору  ${username}  ${auction_uaid}
  Click Element  xpath=//a[@ui-sref="tenderView.chat"]
  Sleep  2
  Click Element  xpath=//button[@ng-click="askQuestion()"]
  Sleep  2
  Input Text  xpath=//input[@ng-model="chatData.title"]  ${question_data.data.title}
  Select From List By Label  xpath=//select[@name="questionOf"]  Аукціон
  Input Text  xpath=//textarea[@ng-model="chatData.message"]  ${question_data.data.description}
  Click Element   xpath=//button[@ng-click="sendQuestion()"]
  Sleep     5

Задати запитання на предмет
  [Arguments]  ${username}  ${auction_uaid}  ${item_id}  ${question_data}
  newtend.Пошук тендера по ідентифікатору  ${username}  ${auction_uaid}
  Click Element  xpath=//a[@ui-sref="tenderView.chat"]
  Sleep  2
  Click Element  xpath=//button[@ng-click="askQuestion()"]
  Sleep  2
  Input Text  xpath=//input[@ng-model="chatData.title"]  ${question_data.data.title}
  Select From List By Label  xpath=//select[@name="questionOf"]  Предмет аукціону
  Sleep     2
  ${item_name}=  Get text  xpath=//option[contains(text(), '${item_id}')]
  Select From List By Label  xpath=//select[@name="relatedItem"]  ${item_name}
  Input Text      xpath=//textarea[@ng-model="chatData.message"]   ${question_data.data.description}
  Click Element   xpath=//button[@ng-click="sendQuestion()"]
  Sleep  5

Відповісти на запитання
  [Arguments]  ${username}  ${tender_uaid}  ${answer_data}  ${question_id}
  Sleep  10
  Reload Page
  Click Element  xpath=//a[@ui-sref="tenderView.chat"]
  ${answer_row}=  Get Webelement  xpath=//div[@class="col-xs-10 col-sm-10"][contains(., '${question_id}')]
  Focus  ${answer_row}
  Mouse Over  ${answer_row}    # should show answer btn
  Sleep  1
  Click Element  xpath=//div[@class="answer mouseenter"]
  Sleep  1
  Input Text  xpath=//textarea[@ng-model="chatData.message"]  ${answer_data.data.answer}
  Click Element  xpath=//button[@ng-click="sendAnswer()"]
  Sleep  2

Скасувати закупівлю
  [Arguments]  ${username}  ${tender_uaid}  ${cancellation_reason}  ${document}  ${description}
  newtend.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Focus  xpath=//button[@id="cancel-tender-btn"]
  Click Element  xpath=//button[@id="cancel-tender-btn"]
  Sleep  2
  Select From List By Value  xpath=//select[@id="cancel-reason"]  ${cancellation_reason}
  Execute Javascript  $('span[class="attach-title ng-binding"]').click()
  Sleep  1
  Choose File  xpath=//input[@type="file"]  ${document}
  Sleep  2
  Input Text  xpath=//textarea[@id="document-description"]  ${description}
  Click Element  xpath=//div[@ng-click="delete()"]
  Sleep  15
  Reload Page

Подати цінову пропозицію
  [Arguments]  ${username}  ${auction_uaid}  ${bid}
  newtend.Пошук тендера по ідентифікатору  ${username}  ${auction_uaid}
  Click Element  xpath=//button[@ng-click='placeBid()']
  Sleep  2
  ${amount}=  Convert To String  ${bid.data.value.amount}
  Input Text  xpath=//input[@name="amount"]  ${amount}
  Click Element  xpath=//input[@name="agree"]
  Run Keyword If  'Можливість' in '${TEST NAME}'  Click Element  xpath=//input[@name="bid-valid"]
  Click Element  xpath=//button[@ng-click="placeBid()"]
  Sleep  2
  ${resp}=  Run Keyword If  'Неможливість' in '${TEST NAME}'  newtend.Скасувати невалідну ставку
  ${resp}=  Run Keyword If  'Можливість' in '${TEST NAME}'  Get text  xpath=//h3[@class="ng-binding"]
  [Return]  ${resp}

Змінити цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  Reload Page
  Sleep   2
  Click Element  xpath=//button[@ng-click="placeBid()"]
  Sleep  1
  Clear Element Text  xpath=//input[@name="amount"]
  ${value}=  Convert To String  ${fieldvalue}
  Input Text  xpath=//input[@name="amount"]  ${value}
  Click Element  xpath=//input[@name="bid-valid"]
  Click Element  xpath=//button[@ng-click="changeBid()"]
  Sleep  2

Скасувати цінову пропозицію
  [Arguments]  ${username}  ${auction_uaid}
  newtend.Пошук тендера по ідентифікатору  ${username}  ${auction_uaid}
  Click Element  xpath=//a[@ng-click="cancelBid()"]
  Wait Until Page Contains Element  xpath=//div[@ng-if="isCancel"]  5
  Click Element  xpath=//button[@ng-click="cancelBid()"]
  Sleep  3

Завантажити документ в ставку
  [Arguments]  ${username}  ${filePath}  ${tender_uaid}
  Click Element  xpath=//a[@ui-sref="tenderView.documents"]
  Sleep  2
  Click Element  xpath=//button[@ng-click="uploadDocument()"]
  Sleep  1
  Select From List By Value  xpath=//select[@id="documentType"]  commercialProposal
  Execute Javascript  $('button[ng-file-select=""]').click()
  Sleep  2
  Choose File  xpath=//input[@type="file"]  ${filePath}
  Sleep  1
  Click Element  xpath=//button[@ng-click="upload()"]
  Sleep  7
  Reload Page

Отримати посилання на аукціон для учасника
  [Arguments]  ${username}  ${tender_uaid}
  Reload Page
  ${result}=  newtend.Отримати посилання
  [Return]  ${result}

Отримати посилання на аукціон для глядача
  [Arguments]  ${username}  ${tender_uaid}
  Reload Page
  Sleep  2
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]
  ${result}=  newtend.Отримати посилання
  [Return]  ${result}

Отримати посилання
  Sleep  2
  : FOR  ${INDEX}  IN RANGE  1  50
  \  Log To Console  -x  no_newline=true
  \  ${count}=  Get Matching Xpath Count  xpath=//a[@class="auction-link ng-binding"]
  \  ${link}=  Get Element Attribute  xpath=//a[@target="_blank"]@href
  \  Exit For Loop If  '${count}' > '0' and '${link}' != 'None'
  \  Sleep  30
  \  Reload Page
  Wait Until Page Contains Element  xpath=//a[@class="auction-link ng-binding"]  10
  ${result}=  Get Element Attribute  xpath=//a[@target="_blank"]@href
  ${result}=  Convert To String  ${result}
  [Return]  ${result}

# Info procedure
Отримати інформацію із тендера
  [Arguments]  ${username}  ${tender_uaid}  ${field}
  Run Keyword And Return  Отримати інформацію із тендера про ${field}

Отримати інформацію із тендера про auctionID
  Run Keyword If  '${ROLE}' != 'tender_owner'  Run Keyword And Return  Get Text  xpath=//div[@class='title']//a
  Run Keyword If  '${ROLE}' == 'tender_owner'  Run Keyword And Return  Get Text  xpath=(//div[@class='title']//span)[1]

Отримати інформацію із тендера про procurementMethodType
  Run Keyword And Return  Get Text  xpath=//div[@class='title']//span[@class='ng-binding']

Отримати інформацію із тендера про status
  Reload Page
  Sleep  2
  ${text}=  Get Text  xpath=//div[@class='right']//span[@class='status ng-binding']
  Run Keyword And Return  convert_nt_string_to_ssp_string  ${text}

Отримати інформацію із тендера про title
  Run Keyword And Return  Get Text  id=view-tender-title

Отримати інформацію із тендера про description
  Run Keyword And Return  Get Text  id=view-tender-description

Отримати інформацію із тендера про minNumberOfQualifiedBids
  ${value}=  Get Text  id=min-number-of-qualified-bids
  Run Keyword And Return  Convert To Number  ${value}

Отримати інформацію із тендера про procuringEntity.name
  Run Keyword And Return  Get Text  id=view-customer-name

Отримати інформацію із тендера про value.amount
  ${value}=  Get Text  id=view-tender-value
  Run Keyword And Return  Convert To Number  ${value}

Отримати інформацію із тендера про minimalStep.amount
  ${value}=  Get Text  id=step
  Run Keyword And Return  Convert To Number  ${value}

Отримати інформацію із тендера про guarantee.amount
  ${value}=  Get Text  id=summ
  Run Keyword And Return  Convert To Number  ${value}

Отримати інформацію із тендера про registrationFee.amount
  ${value}=  Get Text  xpath=//div[@id='reg-fee']
  Run Keyword And Return  Convert To Number  ${value}

Отримати інформацію із тендера про tenderPeriod.endDate
  ${value}=  Get Text  xpath=//*[@id="end-date-registration"]/span
  ${date}=  to_iso_date  ${value}
  [Return]  ${date}

# Info item procedure
Отримати інформацію із предмету
  [Arguments]  ${username}  ${tender_uaid}  ${object_id}  ${field}
  Run Keyword And Return  Отримати інформацію із предмету про ${field}  ${object_id}

Отримати інформацію із предмету про description
  [Arguments]  ${item}
  Run Keyword And Return  Get Text  xpath=//div[@ng-bind='item.description'][(contains(text(), '${item}'))]

Отримати інформацію із предмету про unit.name
  [Arguments]  ${item}
  Run Keyword And Return  Get Text  xpath=//div[@ng-repeat='item in tender.items track by $index'][contains(., '${item}')]//span[@class='unit ng-binding']

Отримати інформацію із предмету про quantity
  [Arguments]  ${item}
  ${value}=  Get Text  xpath=//div[@ng-repeat='item in tender.items track by $index'][contains(., '${item}')]//div[contains(@id, 'quantity')]
  Run Keyword And Return  Convert To Number  ${value}

# Info question procedure
Отримати інформацію із запитання
  [Arguments]  ${username}  ${tender_uaid}  ${question_id}  ${field_name}
  newtend.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Click Element  xpath=//a[@ui-sref="tenderView.chat"]
  Sleep  2
  ${xpath}=  get_xpath_question  ${question_id}  ${field_name}
  Run Keyword And Return  Get Text  ${xpath}

# Info bids procedure
Отримати інформацію із пропозиції
  [Arguments]  ${username}  ${tender_uaid}  ${field}
  ${text}=  Get Text  xpath=//h3[@class="ng-binding"]
  ${value}=  Get Substring  ${text}  0  -4
  Run Keyword And Return  Convert To Number  ${value}

# Info cancellation procedure
Отримати інформацію із тендера про cancellations[0].status
  Reload Page
  Click Element  xpath=//a[@ui-sref="tenderView.auction"]
  Sleep  3
  : FOR     ${INDEX}    IN RANGE    1   15
  \  ${status}=  Get Text  xpath=//h4[@class="ng-binding"]
  \  ${return_value}=  convert_Nt_String_To_Common_String  ${status}
  \  Exit For Loop If  '${return_value}' == 'active'
  \  Sleep  3
  \  Reload Page
  ${staus}=  Get Text  xpath=//h4[@class="ng-binding"]
  Run Keyword And Return  convert_Nt_String_To_Common_String  ${status}

Отримати інформацію із тендера про cancellations[0].reason
  ${raw_text}=  Get Webelements  xpath=//div[@class="col-xs-9 ng-binding"]
  ${text}=  Get Text  ${raw_text[-1]}
  [Return]  ${text}

Отримати інформацію із документа
  [Arguments]  ${username}  ${auction_uaid}  ${doc_id}  ${field}
  Run Keyword And Return  Get Text  xpath=//a[contains(text(), '${doc_id}')]

# Awarding--------------------------------------------------------------------------------------------------------------
Отримати інформацію із тендера про auctionPeriod.startDate
  Click Element  xpath=//a[@ui-sref="tenderView.auction"]
  Sleep  2
  : FOR   ${INDEX}   IN RANGE    1    30
  \  Log To Console   .   no_newline=true
  \  ${count}=  Get Matching Xpath Count  xpath=//div[@class="ng-binding"]
  \  ${text}=   Get Text   xpath=//div[@class="ng-binding"]
  \  Exit For Loop If   '${count}' == '1' and '${text}' != ''
  \  Sleep  30
  \  Reload Page
  ${value}=   Get Text  xpath=//div[@class="ng-binding"]
  ${return_value}=  to_iso_date  ${value}
  [Return]  ${return_value}

Отримати інформацію із тендера про auctionPeriod.endDate
  Switch browser   ${BROWSER_ALIAS}
  Sleep  2
  Click Element  xpath=//a[@ui-sref="tenderView.auction"]
  Sleep  2
  : FOR   ${INDEX}   IN RANGE    1    30
  \  Log To Console   .   no_newline=true
  \  ${count}=  Get Matching Xpath Count   xpath=//div[@id="auctionEndDate"]
  \  ${text}=   Get Text   xpath=//div[@id="auctionEndDate"]
  \  Exit For Loop If  '${count}' == '1' and '${text}' != ''
  \  Sleep  30
  \  Reload Page
  ${value}=  Get Text  xpath=//div[@id="auctionEndDate"]
  ${return_value}=   to_iso_date   ${value}
  [Return]  ${return_value}

Отримати інформацію із тендера про awards[${n}].status
  Reload Page
  Sleep  2
  Click Element  xpath=//a[@ui-sref="tenderView.auction"]
  Sleep  2
  : FOR  ${INDEX}  IN RANGE  1  15
  \  ${status}=  Get Text  id=award-${n}
  \  @{wait_status}=  wait_status  ${TEST_NAME}
  \  Exit For Loop If  '${status}' in @{wait_status}
  \  Sleep  7
  \  Reload Page
  \  Sleep     2
  ${status}=  Get Text  id=award-${n}
  Run Keyword And Return  convert_nt_string_to_ssp_string  ${status}

Отримати кількість авардів в тендері
  [Arguments]  ${username}  ${tender_uaid}
  newtend.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Click Element  xpath=//a[@ui-sref="tenderView.auction"]
  Sleep  2
  ${awards_number}=   Get Matching Xpath Count   xpath=//div[@ui-sref='tenderView.bid({bidId: bid.id, lotId: lot.id})']
  ${awards_number}=  Convert To Integer  ${awards_number}
  [Return]  ${awards_number}

Скасування рішення кваліфікаційної комісії
  [Arguments]  ${username}  ${tender_uaid}  ${award_num}
  Reload Page
  Sleep  2
  newtend.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Click Element  xpath=//a[@ui-sref="tenderView.auction"]
  # Squirell in progress
  : FOR  ${INDEX}  IN RANGE  1  10
  \  ${looser}=  Get Matching Xpath Count  xpath=//div[@class="col-xs-4 status ng-binding pending-waiting"]
  \  Log To Console    LOOSERS found - ${looser}
  \  Exit For Loop If      '${looser}' > '0'
  \  Sleep  2
  \  Reload Page

  Sleep  2
  : FOR  ${INDEX}  IN RANGE  1  10
  \  Click Element  xpath=//div[@class="col-xs-4 status ng-binding pending-waiting"]
  \  Sleep  3
  \  ${take_money_btn}=    Get Matching Xpath Count      xpath=//button[@ng-click="secondCancelAward(bidAward, tender)"]
  \  Exit For Loop If  '${take_money_btn}' > '0'
  \  Sleep  2
  \  Reload Page
  Click Element  xpath=//button[@ng-click="secondCancelAward(bidAward, tender)"]
  Sleep  3
  Wait Until Page Contains Element  xpath=//div[@ng-click="vm.cancel(vm.award, vm.tender)"]
  Click Element  xpath=//div[@ng-click="vm.cancel(vm.award, vm.tender)"]
  Sleep  3

# Util_Keywords---------------------------------------------------------------------------------------------------------
Перейти до редагування
  [Arguments]  ${username}  ${tender_uaid}  ${type}
  Run Keyword If  '${type}' == 'asset'  newtend.Пошук об’єкта МП по ідентифікатору  ${username}  ${tender_uaid}
  Run Keyword If  '${type}' == 'lot'  newtend.Пошук лоту по ідентифікатору  ${username}  ${tender_uaid}
  Focus  id=edit-btn
  Sleep  1
  Click Element  id=edit-btn
  Sleep  3

Зберегти після редагування
  Focus  xpath=//*[text()='Зберегти']
  Sleep  1
  Click Element  xpath=//*[text()='Зберегти']
  Sleep  2

Пошук
  [Arguments]  ${username}  ${obj_id}  ${obj_type}
  ${obj_id}=    Convert To String   ${obj_id}
  Run Keyword If   '${username}' == 'Newtend_Owner'    Go To    https://cdb2-dev.newtend.com/auction/#/privatization/${obj_type}?page=1
  Run Keyword If   '${username}' != 'Newtend_Owner'   Go To    https://cdb2-dev.newtend.com/provider/#/privatization/${obj_type}?page=1
  Sleep  2
  : FOR   ${INDEX}  IN RANGE    1   15
  \   Log To Console   .   no_newline=true
  \   Input Text        xpath=//input[@ng-model="vm.searchQuery"]     ${obj_id}
  \   Click Element     xpath=//div[@ng-click="vm.refresh()"]
  \   Sleep  2
  \   ${auctions}=   Get Matching Xpath Count   xpath=//*[@class="title ng-binding"]
  \   Exit For Loop If  '${auctions}' > '0'
  \   Sleep  5
  \   Reload Page
  Click Element     xpath=//*[@class="title ng-binding"]
  Sleep  2

Заповнити форму адреса
  [Arguments]  ${country}  ${postalCode}  ${region}  ${locality}  ${streetAddress}
  Sleep  2
  Input Text  xpath=//input[@name="countryName"]  ${country}
  Input Text  xpath=//input[@name="postalCode"]  ${postalCode}
  Input Text  xpath=//input[@name="region"]  ${region}
  Input Text  xpath=//input[@name="locality"]  ${locality}
  Input Text  xpath=//input[@name="streetAddress"]  ${streetAddress}
  Sleep  1
  Click Element  xpath=//button[@ng-click="vm.save()"]
  Sleep  2

Ввести контакти балансоутримувача
  [Arguments]  ${type}  ${name}  ${email}  ${phone}  ${fax}  ${url}
  Focus  id=asset-create-holder-${type}-0-name
  Input Text  id=asset-create-holder-${type}-0-name  ${name}
  Input Text  id=asset-create-holder-${type}-0-email  ${email}
  Input Text  id=asset-create-holder-${type}-0-telephone  ${phone}
  Input Text  id=asset-create-holder-${type}-0-fax-number  ${fax}
  Input Text  id=asset-create-holder-${type}-0-url  ${url}
  Sleep  1

Ввести сумму та обрати валюту аукціону
  [Arguments]  ${field}  ${auction_amount}  ${currency}
  ${amount}=  Convert To String  ${auction_amount}
  Clear Element Text  id=lot-auctions-${field}-amount
  Input Text  id=lot-auctions-${field}-amount  ${amount}
  Click Element  id=lot-auctions-${field}-currency-link-value
  Sleep  1
  Click Element  id=lot-auctions-${field}-currency-menu-item-${currency}

Edit amount field auctions
  [Arguments]  ${name_field}  ${value}
  Clear Element Text  id=lot-auctions-${name_field}-amount
  Input Text  id=lot-auctions-${name_field}-amount  ${value}

Edit date auctions
  [Arguments]  ${fieldvalue}
  Clear Element Text  id=lot-auctions-auction-period-date
  Input Text  id=lot-auctions-auction-period-date  ${fieldvalue.split('T')[0]}
  ${hours}=  Get Webelements  xpath=//input[@ng-change='updateHours()']
  Clear Element Text  ${hours[-1]}
  Input Text  ${hours[-1]}  ${fieldvalue.split('T')[1].split(':')[0]}
  ${minutes}=  Get Webelements  xpath=//input[@ng-change='updateMinutes()']
  Clear Element Text  ${minutes[-1]}
  Input Text  ${minutes[-1]}  ${fieldvalue.split('T')[1].split(':')[1]}

Скасувати невалідну ставку
  ${alert}=  Get Matching Xpath Count  xpath=//div[@class="alert alert-warning ng-binding ng-scope"]
  Click Element  xpath=//a[@ng-click="cancelBid()"]
  Sleep  2
  Click Element  xpath=//button[@ng-click="cancelBid()"]
  ${resp}=  Run Keyword If  '${alert}' == '1'  '${False}'
  [Return]  ${resp}
