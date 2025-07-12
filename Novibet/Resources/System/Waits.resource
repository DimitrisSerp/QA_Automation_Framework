*** Settings ***
Documentation     Library contains keywords to wait until something happens or stops
...
...               ================
...               *Library Keywords*
...               ================
...
...               Action keywords
...               |`Wait`|
...               | `Wait Until Page Contains Item` |
...               | `Wait Until Page Does Not Contains Item` |
...               | `Wait Until Page Element is Visible` |
...               Most of keywords are wrappers for 'SeleniumLibrary.Wait Until Page Contains Element' with pre-set _timeout_ and _error message_.
...
...               Validation keywords
...               | `Page Should Contain Item` |
...               | `Page Should Not Contain Item` |
...
...               ================
...               *Library Variables*
...               ================
...
...               - _WAIT_TIMEOUT_: Time to wait before keyword fail (default:10s).
Library           SeleniumLibrary

*** Variables ***
${WAIT_TIMEOUT}    15s    # Used by all custom 'Wait' KWs



*** Keywords ***
Wait
    [Arguments]    ${time}=${WAIT_TIMEOUT}    ${reason}=''
    [Documentation]    Waits some time befoce continue
    ...
    ...    Wrapper for 'Buildin.Sleep' with pre-set _timeout_ and _wait message_
    ...
    ...    Examples:
    ...    | Wait |
    ...    | Wait | 5s | |
    ...    | Wait | 20s | Wait the page to load |
    Sleep    ${time}    reason=${reason}

Wait Until Page Contains Item
    [Arguments]    ${element}    ${timeout}=${WAIT_TIMEOUT}
    [Documentation]    Waits some time until the asked element is in page
    ...
    ...    Wrapper for 'SeleniumLibrary.Wait Until Page Contains Element' with pre-set _timeout_ and _error message_
    ...
    ...    Examples:
    ...    | Wait Until Page Contains Item | locator | |
    ...    | Wait Until Page Contains Item | locator | 20s |
    Wait Until Page Contains Element    ${element}    timeout=${timeout}    error=Can not locate element '${element}'

Wait Until Page Does Not Contains Item
    [Arguments]    ${element}    ${timeout}=${WAIT_TIMEOUT}    ${limit}=${None}
    [Documentation]    Waits some time until the asked element is in page
    ...
    ...    Wrapper for 'SeleniumLibrary.Wait Until Page Does Not Contain Element' with pre-set _timeout_ and _error message_
    ...
    ...    Examples:
    ...    | Wait Until Page Does Not Contains Item | locator | |
    ...    | Wait Until Page Does Not Contains Item | locator | 20s |
    ...    | Wait Until Page Does Not Contains Item | locator | 20s | limit=1 |
    Wait Until Page Does Not Contain Element    ${element}    timeout=${timeout}    error=Element '${element}' is on page after timeout    limit=${limit}

Wait Until Page Element Is Visible
    [Arguments]    ${element}    ${timeout}=${WAIT_TIMEOUT}
    [Documentation]    Waits some time until the asked element is visible
    ...
    ...    Wrapper for 'SeleniumLibrary.Wait Until Element Is Visible' with pre-set _timeout_ and _error message_
    ...
    ...    Examples:
    ...    | Wait Until Page Element Is Visible | locator | |
    ...    | Wait Until Page Element Is Visible | locator | 20s |
    Wait Until Element Is Visible    ${element}    timeout=${timeout}    error=Page element '${element}' is not visible after time ${timeout}

Page Should Contain Item
    [Arguments]    ${element}    ${timeout}=${WAIT_TIMEOUT}    ${error}=${None}
    [Documentation]    Waits some time until the asked element is in page
    ...
    ...    Wrapper for 'SeleniumLibrary.Wait Until Page Contains Element' with pre-set _timeout_ and _error message_
    ...
    ...    Examples:
    ...    | Page Should Contain Item | locator | |
    ...    | Page Should Contain Item | locator | 20s |
    ...    | Page Should Not Contain Item | locator | 20s | error=Element is not in page |
    IF    $error != $None
    Wait Until Page Contains Element    ${element}    timeout=${timeout}    error=${error}
    ELSE
    Wait Until Page Contains Element    ${element}    timeout=${timeout}    error=Page does not contain element '${element}'
    END

Page Should Not Contain Item
    [Arguments]    ${element}    ${timeout}=${WAIT_TIMEOUT}    ${error}=${None}
    [Documentation]    Waits some time until the asked element is in page
    ...
    ...    Wrapper for 'SeleniumLibrary.Wait Until Page Does Not Contain Element' with pre-set _timeout_ and _error message_
    ...
    ...    Examples:
    ...    | Page Should Not Contain Item | locator | |
    ...    | Page Should Not Contain Item | locator | 20s |
    ...    | Page Should Not Contain Item | locator | 20s | error=Element is in page |
    IF    $error != $None
    Wait Until Page Does Not Contain Element    ${element}    timeout=${timeout}    error=${error}
    ELSE
    Wait Until Page Does Not Contain Element    ${element}    timeout=${timeout}    error=Element '${element}' is on page after timeout
    END
