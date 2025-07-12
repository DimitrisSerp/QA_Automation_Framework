*** Settings ***
Documentation     Library contains Keywords to be used in Test Suite or Test Case Setup and close all unnecessary windows and prompts.
...
...               ================
...               *Library Keywords*
...               ================
...
...               | `Close Cookies Prompt` |
...               | `Close Registration Prompt` |
Resource          ../Devices/KeyboardMouse.resource
Resource          ../Validators/CommonPageValidators.resource

*** Keywords ***
Close Cookies Prompt
    [Documentation]    Accepts Cookies in order to close prompt. Validates if prompt is closed.
    Click on page Element    ${lc_LOCATORS['noise']}[btn-accept-cookies]
    ${prompt_closed}    Is Element In Page    ${lc_LOCATORS['noise']}[cntr-cookies]
    Should Not Be True    ${prompt_closed}    Prompt was not closed

Close Registration Prompt
    [Documentation]    Close registration panel. Validates if prompt is closed.
    Click on page Element    ${lc_LOCATORS['noise']}[btn-close-register]
    ${prompt_closed}    Is Element In Page    ${lc_LOCATORS['noise']}[cntr-registration]
    Should Not Be True    ${prompt_closed}    Prompt was not closed
