*** Settings ***
Documentation     Library contains Keywords to manipulate Google Chrome browser
...
...               ================
...               *Library Keywords*
...               ================
...
...               Keywords to Open new browser window during Suite or Test Setup
...               | `Open Chrome In Stripped Down Mode` |
...
...               =================
...               *Library variables*
...               =================
...               Bellow variables are applicable only for Google Chrome browser
...               - _CHROME_OPTIONS_: List with Chrome browser options to be used during call.
...               - _CHROME_EXPERIMENTAL_OPTIONS_: List with Chrome browser options to be used during call.
Library           SeleniumLibrary
Library           Collections

*** Variables ***
@{CHROME_OPTIONS}    --incognito    --enable-automation    --test-type=\webdriver    --start-maximized    --hide-scrollbars    --aggressive-cache-discard    --disable-cache    --disable-application-cache    --disable-offline-load-stale-cache    --disk-cache-size\=0    --media-cache-size\=0    --bwsi    --no-first-run    --disable-default-apps    --disable-plugins-discovery    --disable-notifications    --disable-infobars
...               --disable-prompt-on-repost    --disable-breakpad    --disable-background-downloads    --disable-background-mode    --disable-extensions    --disable-plugins    --disable-gpu    --disable-translate    --dns-prefetch-disable    --no-experiments    --no-pings    --no-referrers    --disable-accelerated-video    --disable-3d-apis    # Chrome options to stip it down and make it ingognito
@{CHROME_EXPERIMENTAL_OPTIONS}    enable-logging    load-extension    disable-popup-blocking    disable-remote-fonts    force-devtools-available



*** Keywords ***
Open Chrome In Stripped Down Mode
    [Arguments]    ${url}    ${headless}=${False}    ${hide_location}=${True}    ${size}=1200,800
    [Documentation]    Opens Chrome web browser with arguments that stripes down its background processes and run in incognito mode.    # will use Chrome in headless mode | \ \ \ # will allow pop-up to ask about location sharing | \ \ \ # Will set the window size |
    ...
    ...    _url_ is the portal url to open.
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
    ...    | Open Chrome In Stripped Down Mode | https://www.novibet.gr/live-programma |
    ...    | Open Chrome In Stripped Down Mode | https://www.novibet.gr/stoixima-live | headless=Yes |
    ...
    ...
    ...    *References*
    ...    - https://github.com/GoogleChrome/chrome-launcher/blob/master/docs/chrome-flags-for-tools.md
    ...    - https://peter.sh/experiments/chromium-command-line-switches
    ...    - https://github.com/peledies/chrome-no-cache
    ...    - https://superuser.com/a/516582
    ...    - https://chromedriver.chromium.org/capabilities
    ...
    ...    _The additional arguments may make the start of browser slower._
    Append To List    ${CHROME_OPTIONS}    --window-size\=${size.strip()}
    IF    ${hide_location}
    Append To List    ${CHROME_OPTIONS}    --deny-permission-prompts
    END
    IF    ${headless}
    Append To List    ${CHROME_OPTIONS}    --headless
    END
    Log List    ${CHROME_OPTIONS}    level=DEBUG
    Log List    ${CHROME_EXPERIMENTAL_OPTIONS}    level=DEBUG
    ${mrg_chrome_options}    Evaluate    "; ".join(['add_argument("{}")'.format(a) for a in $CHROME_OPTIONS])
    ${mrg_chrome_options}    Catenate    SEPARATOR=;${SPACE}    ${mrg_chrome_options}    add_experimental_option("excludeSwitches", ${CHROME_EXPERIMENTAL_OPTIONS})
    Log    ${mrg_chrome_options}    level=DEBUG
    Open Browser    ${url}    Chrome    options=${mrg_chrome_options}
