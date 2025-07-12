*** Settings ***
Documentation     Library contains Keywords to manipulate Firefox browser
...
...               ================
...               *Library Keywords*
...               ================
...
...               Keywords to Open new browser window during Suite or Test Setup
...               | `Open Firefox In Stripped Down Mode` |
...
...               =================
...               *Library variables*
...               =================
...               - _FIREFOX_PREFERENCES_: List with Firefox browser preference to be used during call.
Library           SeleniumLibrary
Library           Collections

*** Variables ***
@{FIREFOX_OPTIONS}    # Firefox options to strip it down and make it private
&{FIREFOX_PREFERENCES}    browser.privatebrowsing.autostart=True    browser.cache.disk.enable=False    browser.cache.memory.enable=False    browser.cache.offline.enable=False    devtools.cache.disabled=False    network.cookie.cookieBehavior=5    browser.contentblocking.category="stict"    permissions.default.geo=0    permissions.default.camera=2    permissions.default.microphone=2    permissions.default.xr=2    permissions.default.desktop-notification=2    app.normandy.first_run=False    app.normandy.startupRolloutPrefs.app.update.background.scheduling.enabled=False    app.shield.optoutstudies.enabled=False    app.update.service.enabled=False    browser.discovery.enabled=False
...               browser.formfill.enable=False    browser.search.suggest.enabled=False    datareporting.healthreport.uploadEnabled=False    places.history.enabled=False    privacy.sanitize.sanitizeOnShutdown=True    toolkit.telemetry.reportingpolicy.firstRun=False    # Firefox preferences to strip it down and make it private



*** Keywords ***
Open Firefox In Stripped Down Mode
    [Arguments]    ${url}    ${headless}=${False}    ${hide_location}=${True}    ${size}=1200,800
    [Documentation]    Opens Firefox web browser with arguments that stripes down its background processes and run in private mode.    # will use Firefox in headless mode | \ \ \ # will allow pop-up to ask about location sharing | \ \ \ # Will set the window size |
    ...
    ...    _url_ is the portal url to open.
    ...
    ...    _size_ is the browser window size (default:1200,800).
    ...
    ...    If _headless_ is _True_ the browser will run in headless mode (default:False).
    ...
    ...    If _hidelocation_ is _True_ the location will not be accessible by the browser (default:True).
    ...
    ...    Uses preferences stored in library list variable ${CHROME_preferences}.
    ...
    ...    *Examples*
    ...    | Open Firefox In Stripped Down Mode | https://www.novibet.gr/live-programma |
    ...    | Open Firefox In Stripped Down Mode | https://www.novibet.gr/stoixima-live | headless=Yes |
    ...
    ...    *References*
    ...    - https://searchfox.org/mozilla-central/source/modules/libpref/init/all.js
    ...
    ...    _The additional arguments may make the start of browser slower._
    Append To List    ${FIREFOX_OPTIONS}    --width=${size.split(',')[0]}
    Append To List    ${FIREFOX_OPTIONS}    --height=${size.split(',')[1]}
    IF    ${headless}
    Append To List    ${FIREFOX_OPTIONS}    --headless
    END
    IF    ${hide_location}
    Set To Dictionary    ${FIREFOX_PREFERENCES}    permissions.default.geo    2
    END
    Log List    ${FIREFOX_OPTIONS}    level=DEBUG
    Log Dictionary    ${FIREFOX_PREFERENCES}    level=DEBUG
    ${mrg_firefox_options}    Evaluate    "; ".join(['add_argument("{}")'.format(o) for o in $FIREFOX_OPTIONS])
    ${mrg_firefox_preferences}    Evaluate    ";".join(['set_preference("{}", {})'.format(p, v) for p, v in $FIREFOX_PREFERENCES.items()])
    Log    ${mrg_firefox_preferences}    level=DEBUG
    Open Browser    ${url}    Firefox    options=${mrg_firefox_options}    ff_profile_dir=${mrg_firefox_preferences}
