*** Settings ***
Documentation     Library contains keywords for common checks on portal pages
...
...               ================
...               *Library Keywords*
...               ================
...
...               Validation keywords
...               | `Is Element In Page` |
...               | `Is Not Element In Page` |
Library           SeleniumLibrary
Resource          ../System/Waits.resource

*** Keywords ***
Is Element In Page
    [Arguments]    ${element}
    [Documentation]    Returns True if element is in page one or more times else False
    ...
    ...    *Args*
    ...    - _element_ : the element to search
    ...
    ...    *Examples*
    ...    | ${is_in_page} = | Is Element In Page | ${lc_LOCATORS}[btn-close] |
    ${count}    SeleniumLibrary.Get Element Count    ${element}
    ${isInPage}    Evaluate    ${count} > 0
    [Return]    ${isInPage}    # True if exist else False

Is Not Element In Page
    [Arguments]    ${element}
    [Documentation]    Returns True if element is not in page else False
    ...
    ...    *Args*
    ...    - _element_ : the element to search
    ...
    ...    *Examples*
    ...    | ${is_not_in_page} = | Is Not Element In Page | ${lc_LOCATORS}[btn-close] |
    ${isInPage}    Is Element In Page    ${element}
    ${isNotInPage}    Set Variable If    ${isInPage}    ${False}    ${True}
    [Return]    ${isNotInPage}    # True if not exist else False
