*** Settings ***
Documentation     Library contains Keywords to be used in portal filtering widgets
...
...               ================
...               *Library Keywords*
...               ================
...
...               | `Filter Scheduled Matches` |
...               | `Filter Live Matches` |
...
...               =================
...               *Library variables*
...               =================
...               - _IMAGE_MATCHES_IDs_: IDs texts which are used to validate match icons
Resource          ../Devices/KeyboardMouse.resource
Resource          ../System/Waits.resource
Library           Collections
Resource          ../System/LowLevelLib.resource

*** Variables ***
&{IMAGE_MATCHES_IDs}    soccer=SOCCER_MATCH    basket=BASKETBALL_GAME    tennis=TENNIS_SINGLES_MATCH    tTennis=TABLE_TENNIS_SINGLES_MATCH    volley=VOLLEYBALL_GAME    baseball=BASEBALL_GAME    cricket=CRICKET_MATCH    lol=LEAGUE_OF_LEGENDS_MATCH    cs=COUNTER_STRIKE_GO_MATCH    dota=DOTA_MATCH    rugby=RUGBY_GAME    vtennis=VIRTUAL_TENNIS_SINGLES_MATCH    horseRace=HORSE_RACING_RACE






*** Keywords ***
Filter Scheduled Matches
    [Arguments]    ${match_id}
    [Documentation]    Filters scheduled matches shown in live-programma page. Argument should be consistent with Locator.json file
    ...
    ...    Examples:
    ...    | Filter Scheduled Matches | soccer |
    ...    | Filter Scheduled Matches | tTennis |
    Click On Page Element    ${lc_LOCATORS['portal-pages']['live-schedule']['drpdn-schedule-filters']}[btn-drpdn-all-match]
    Click On Page Element    ${lc_LOCATORS['portal-pages']['live-schedule']['drpdn-schedule-filters']}[btn-drpdn-${match_id}]
    Wait    1    Wait for filters to be applied
    Pause Logging
    ${fltr_count_scehduled}    SeleniumLibrary.Get Element Count    ${lc_LOCATORS['portal-pages']['live-schedule']['tbl-matches']}[img-scheduled-match]
    FOR    ${i}    IN RANGE    1    ${fltr_count_scehduled+1}
        ${img_id}    SeleniumLibrary.Get Element Attribute    ${lc_LOCATORS['portal-pages']['live-schedule']['tbl-matches']}[img-scheduled-match]    alt
        Should Be Equal As Strings    ${img_id}    ${IMAGE_MATCHES_IDs}[${match_id}]
    END
    Unpause Logging

Filter Live Matches
    [Arguments]    ${match_id}
    [Documentation]    Filters live matches shown in live-betting page. Argument should be consistent with Locator.json file
    ...
    ...    Examples:
    ...    | Filter Live Matches | soccer |
    ...    | Filter Live Matches | tTennis |
    Click On Page Element    ${lc_LOCATORS['portal-pages']['live-betting']['live-filters']}[btn-${match_id}]
    Wait    1    Wait for filters to be applied
    ${lc_active}    Build Locator From Template    ${lc_LOCATORS['portal-pages']['live-betting']['live-filters']}[btn-active-filter]    match_id=${IMAGE_MATCHES_IDs}[${match_id}]
    Page Should Contain Item    ${lc_active}    ${WAIT_TIMEOUT}    Filter was not applied.
