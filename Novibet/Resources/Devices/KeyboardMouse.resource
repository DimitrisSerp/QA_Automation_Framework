*** Settings ***
Documentation     Library contains keywords for Keyboard and Mouse usage simulation
...
...               ================
...               *Library Keywords*
...               ================
...
...               Mouse keywords
...               | `Scroll Panel To See Element` |
...               | `Click On Page Element` |
Library           SeleniumLibrary

*** Keywords ***
Scroll Panel To See Element
    [Arguments]    ${locator}
    [Documentation]    Scroll the page until the _locator_ in visible and set focus to it
    ...
    ...    Examples:
    ...    | Scroll Panel To See an Element |
    Page Should Contain Element    ${locator}    limit=1
    Scroll Element Into View    ${locator}
    Wait Until Element is visible    ${locator}    timeout=${WAIT_TIMEOUT}
    Set Focus To Element    ${locator}

Click On Page Element
    [Arguments]    ${locator}    ${scroll}=True
    [Documentation]    Clicks on given page element
    ...
    ...    Wraper afor _SeleniumLibrary.ClickElement_ with _modifier_ and _action_chain_ False
    ...
    ...    *Args*
    ...    - _locator_: The element locator to click on
    ...    - _scroll_: If is _True_ it will scroll the element into view before the action (default:True)
    ...
    ...    Examples:
    ...    | Click On Page Element | id:button |
    ...    | Click On Page Element | id:button | scroll=False |
    Page Should Contain Element    ${locator}    limit=1
    IF    ${scroll}
    Scroll Panel To See Element    ${locator}
    END
    Click Element    ${locator}    modifier=${False}    action_chain=${False}
