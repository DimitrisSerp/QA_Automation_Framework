*** Settings ***
Documentation     Library contains low level keywords that may be used by any other higher level
...
...               ================
...               *Library Keywords*
...               ================
...
...               Action keywords
...               | `Build Locator From Template` |
...               |`Pause Logging`|
...               |`Unpause Logging`|
Library           SeleniumLibrary
Library           String

*** Keywords ***
Build Locator From Template
    [Arguments]    ${template}    &{named}
    [Documentation]    It takes as argument a Locator containing wildchard templates as _${template}_ and the values that will replace templates as _&{named}_ dictionary. Useful keyword for dynamic locators that will be built on the fly.
    ...
    ...    Examples:
    ...    | Build Locator From Template | ${lc_LOCATORS}[btn-test] | row=1 | column=2 |
    ...    | Build Locator From Template | ${lc_LOCATORS}[btn-test] | id=test |
    ${locator}    Format String    ${template}    &{named}
    Log    Locator template: '${template}' <- &{named} -> '${locator}'
    [Return]    ${locator}

Pause Logging
    [Documentation]    Pauses all logs
    ...
    ...    Sets _LOG_LEVEL_ variable to *NONE*.
    ...
    ...    After execution the value of Suite Variable _old_log_level_ is set to last *LOG_LEVEL*.
    ...
    ...    Examples:
    ...    | Pause Logging |
    Set Suite Variable    ${old_log_level}    ${LOG_LEVEL}    children=true
    IF    ${{ $LOG_LEVEL not in ['DEBUG', 'TRACE'] }}
    Set Log Level    NONE
    END

Unpause Logging
    [Documentation]    Restores log level to the last stored
    ...
    ...    Uses the last stored log level that is stored in Suite Variable _old_log_level_.
    ...
    ...    After execution the value of Suite Variable _old_log_level_ is set to *INFO*.
    ...
    ...    Examples:
    ...    | Unpause Logging |
    ${level}    Get Variable Value    $old_log_level    INFO
    Set Log Level    ${old_log_level}
    [Teardown]    Set Suite Variable    ${old_log_level}    INFO    children=true
