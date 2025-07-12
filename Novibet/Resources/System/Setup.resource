*** Settings ***
Documentation     Library contains Keywords to be used in Test Suite or Test Case Setup and Teardown
...
...               ================
...               *Library Keywords*
...               ================
...
...               Combined keywords
...               | `Setup Test Environment` |
...               | `Teardown Test Environment` |
...
...               Keywords to Open whatever is needed during Suite or Test Setup
...               | `Open New Browser Window` |
...
...               Keywords to Close whatever is open on Suite or Test Teardown
...               | `Close All Browser Windows` |
...
...               =================
...               *Library variables*
...               =================
...               - _BROWSER_: The browser to be used in tests (default:chrome).
...               - _BROWSER_MAXIMIZED_: If is `Yes` the browser window will be maximized \ (default:Yes)
...               - _BROWSER_STRIPPED_: If is 'Yes' then a stripped down version of Chrome browser will be used (default:No).
...               - _TEST_ENVIRONMENT_SETTINGS_DIR_: The directory which contains configuration files of the project
...
...               Bellow variables will be used only if `BROWSER_STRIPPED=Yes`
...               - _BROWSER_HEADLESS_: If is 'Yes' then headless version of browser will be used (default:No).
...               - _BROWSER_WINDOW_SIZE_: The browser window size (default:1200,800).
...               - _BROWSER_HIDE_LOCATION_: If is 'Yes' then the browser will not be informed about the location of the user (default:Yes).
Library           OperatingSystem
Resource          ../Browsers/Browser.resource
Resource          Loaders.resource
Resource          NoiseCancellation.resource
Resource          LowLevelLib.resource

*** Variables ***
${BROWSER}        chrome
${BROWSER_MAXIMIZED}    Yes    # Yes := Maximized browser window ANY other value will keep original size
${BROWSER_STRIPPED}    No    # Yes := Run chrome with settings incognito settings ANY other value will run chrome with normal settings
${BROWSER_HEADLESS}    No    # Yes := Run browser in headless mode ANY other value will run with GUI
${BROWSER_WINDOW_SIZE}    1200,800    # Used by Keyword 'Open Chrome In Stripped Down Mode'
${BROWSER_HIDE_LOCATION}    Yes    # Yes := Do not prompt for location access ANY other value will allow prompt pop-up
${TEST_ENVIRONMENT_SETTINGS_DIR}    ${CURDIR}${/}..${/}..${/}Settings    # Path to dir with environment settings










*** Keywords ***
Setup Test Environment
    [Arguments]    ${portal_url}=${None}
    [Documentation]    Prepares Test Environment by reading EUT configuration and opens a new browser windows without loading any page if not asked.
    ...
    ...    _portal_url_ is the url to open. If not given a blank page will open.
    ...
    ...    The default values will be used for parameters _BROWSER_, _BROWSER_HEADLESS_, _BROWSER_MAXIMIZED_, _BROWSER_STRIPPED_ and _BROWSER_HIDE_LOCATION_.
    ...
    ...    Using this KW is the same as using the following
    ...    | `Load Settings For Environment Under Test` |
    ...    | `Open New Browser Window` | url=${url} |
    ...
    ...    *Examples*
    ...    | Setup Test Environment |
    ...    | Setup Test Environment | portal_url=https://www.novibet.gr/live-programma |
    Pause Logging
    Load Portal Locators    ${TEST_ENVIRONMENT_SETTINGS_DIR}    Locators.json
    Load Portal Specs    ${TEST_ENVIRONMENT_SETTINGS_DIR}    Specs.json
    IF    ${portal_url}==${None}
    Open New Browser Window    url=${cf_SPECS}[url_schedule]
    ELSE
    Open New Browser Window    url=${portal_url}
    END
    Close Cookies Prompt
    Close Registration Prompt
    Unpause Logging

Teardown Test Environment
    [Arguments]    ${keep_cookies}=${False}
    [Documentation]    Shuts down Test Environment by closes all open browser windows without reporting any error.
    ...
    ...    Using this KW is the same as using the following
    ...    | `Close All Browser Windows` | keep_coocies=${keep_cookies} |
    ...
    ...    *Examples*
    ...    | Teardown Test Environment |
    ...    | Teardown Test Environment | keep_cookies=True |
    Close All Browser Windows    keep_coocies=${keep_cookies}

Close All Browser Windows
    [Arguments]    ${keep_cookies}=${False}    # If False all stored cookies will be deleted
    [Documentation]    The Test closure keyword that closes all browser windows and does not report any error.
    ...
    ...    If _keep_cookies_ is not _True_ all cookies of all opened browsers will be deleted.
    ...
    ...    *Examples*
    ...    | Close All Browser Windows |
    ...    | Close All Browser Windows | keep_cookies=${False} |
    IF    not $keep_cookies
    Run Keyword And Ignore Error    Delete Cookies From All Opened Browsers
    END
    Run Keyword And Ignore Error    Close All Open Browser Windows

Open New Browser Window
    [Arguments]    ${url}=${None}
    [Documentation]    Opens a new browser windows.
    ...
    ...    _url_ is the url to open. If not given a blank page will open.
    ...
    ...    The default values will be used for parameters _BROWSER_, _BROWSER_HEADLESS_, _BROWSER_MAXIMIZED_, _BROWSER_STRIPPED_ and _BROWSER_HIDE_LOCATION_.
    ...
    ...    *Examples*
    ...    | Open New Browser Window |
    ...    | Open New Browser Window | https://www.novibet.gr/live-programma |
    ${br_stripped}    Set Variable    ${{True if '${BROWSER_STRIPPED.lower().strip()}' == 'yes' else False}}
    ${br_headless}    Set Variable    ${{True if '${BROWSER_HEADLESS.lower().strip()}' == 'yes' else False}}
    ${br_hide_location}    Set Variable    ${{True if '${BROWSER_HIDE_LOCATION.lower().strip()}' == 'yes' else False}}
    ${br_maximized}    Set Variable    ${{True if '${BROWSER_MAXIMIZED.lower().strip()}' == 'yes' else False}}
    IF    ${br_stripped}
    Browser.Open Browser In Stripped Down Mode    url=${url}    browser=${BROWSER.strip()}    headless=${br_headless}    hide_location=${br_hide_location}    size=${BROWSER_WINDOW_SIZE.strip()}
    ELSE
    Browser.Open Browser In Normal Mode    url=${url}    browser=${BROWSER.strip()}    maximized=${br_maximized}
    END
