*** Settings ***
Documentation     Library contains Keywords to manipulate browsers.
...
...               ================
...               *Library Keywords*
...               ================
...
...               Keywords to Open new browser window during Suite or Test Setup
...               | `Open Browser In Normal Mode` |
...               | `Open Browser In Stripped Down Mode` |
...
...               Keywords to close all open browser windows
...               | `Close All Open Browser Windows` |
...
...               Keywords to manipulate browser
...               | `Delete Cookies From All Opened Browsers` |
Library           SeleniumLibrary
Resource          GoogleChrome.resource
Resource          Firefox.resource

*** Variables ***





*** Keywords ***
Close All Open Browser Windows
    [Documentation]    Closes all open browser windows.
    ...
    ...    This KW is a wrapper of _SeleniumLibrary.Close All Browsers_
    ...
    ...    *Examples*
    ...    | Close All Open Browser Windows |
    Close All Browsers

Delete Cookies From All Opened Browsers
    [Documentation]    Deletes all coocies in all open browsers
    ...
    ...    *Examples*
    ...    | Delete Cookies From All Opened Browsers |
    @{browser_ids}    Get Browser Ids
    FOR    ${id}    IN    @{browser_ids}
        Switch Browser    ${id}
        Delete All Cookies
    END

Open Browser In Normal Mode
    [Arguments]    ${url}    ${browser}    ${maximized}=${True}
    [Documentation]    Opens a new web browser window.    # will use Chrome web browser | \ \ \ # will use Firefox web browser | \ \ \ # Will keep the original window size |
    ...
    ...    _url_ is the portal url to open.
    ...
    ...    _browser_ is one of the Selenium supported browsers. Value can be any of the supported by SeleniumLibrary.
    ...
    ...    If _maximized_ is _Yes_ the browser window will be maximized (default:True).
    ...
    ...    *Examples*
    ...    | Open Browser In Normal Mode | http://iot.vodafoneinnovus.com |
    ...    | Open Browser In Normal Mode | http://iot.vodafoneinnovus.com | browser=Chrome |
    ...    | Open Browser In Normal Mode | http://iot.vodafoneinnovus.com | browser=Firefox |
    ...    | Open Browser In Normal Mode | http://iot.vodafoneinnovus.com | FF | maximized=${False} |
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Open Browser    ${url}    chrome
    sleep    10sec    Wait for page to load properly
    Set Window Size    1920    1080
    IF    ${maximized}
    Maximize Browser Window
    END

Open Browser In Stripped Down Mode
    [Arguments]    ${url}    ${browser}    ${headless}=${False}    ${hide_location}=${True}    ${size}=1200,800
    [Documentation]    Opens web browser with arguments that stripes down its background processes and run in ingognito mode.    # will use Chrome in headless mode | \ \ \ # will allow pop-up to ask about location sharing | \ \ \ # Will set the window size |
    ...
    ...    _url_ is the portal url to open.
    ...
    ...    _browser_ is one of the Selenium supported browsers. Value can be any of ['Chrome'].
    ...
    ...    _size_ is the browser window size (default:1200,800).
    ...
    ...    If _headless_ is _True_ the browser will run in headless mode (default:False).
    ...
    ...    If _hidelocation_ is _True_ the location will not be accesible by the browser (default:True).
    ...
    ...    Uses options stored in library list variable ${CHROME_OPTIONS}.
    ...
    ...    *Examples*
    ...    | Open Browser In Stripped Down Mode | http://iot.vodafoneinnovus.com | Chrome |
    ...    | Open Browser In Stripped Down Mode | http://iot.vodafoneinnovus.com | Chrome | headless=Yes |
    ...    | Open Browser In Stripped Down Mode | http://iot.vodafoneinnovus.com | Chrome | hidelocation=No |
    ...    | Open Browser In Stripped Down Mode | http://iot.vodafoneinnovus.com | Chrome | size=800,600 |
    ...    | Open Browser In Stripped Down Mode | http://iot.vodafoneinnovus.com | Chrome | headless=Yes | size=800,600 |
    ...
    ...    _The additional arguments may make the start of browser slower._
    ${browser_norm}    Set Variable    ${browser.strip().lower()}
    IF    ${{$browser_norm in ['googlechrome', 'chrome', 'gc', 'headlesschrome']}}
    IF    '${browser_norm}' == 'headlesschrome'
    ${headless}    Set Variable    ${True}
    END
    Open Chrome In Stripped Down Mode    ${url}    ${headless}    ${hide_location}    ${size}
    ELSE IF    ${{$browser_norm in ['firefox', 'ff', 'headlessfirefox']}}
    IF    '${browser_norm}' == 'headlessfirefox'
    ${headless}    Set Variable    ${True}
    END
    Open Firefox In Stripped Down Mode    ${url}    ${headless}    ${hide_location}    ${size}
    ELSE
    Log    level=WARN    message=Browser '${browser}' is not supported in stripped down mode yet
    Open Browser In Normal Mode    ${url}    ${browser_norm}
    END
