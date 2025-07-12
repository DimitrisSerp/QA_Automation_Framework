*** Settings ***
Documentation     Library contains Keywords to be used in Live Schedule page
...
...               ================
...               *Library Keywords*
...               ================
...
...               | `Get Scheduled Matches` |
...               | `Check Match Status` |
...               | `Go to Live Schedule Page` |
Resource          ../PortalWidgets/Filters.resource
Resource          ../System/LowLevelLib.resource
Resource          LiveBetting.resource
Library           XML

*** Keywords ***
Get Scheduled Matches
    [Documentation]    Scrape the live schedule page and return football matches as a list of dictionaries.
    Pause Logging
    ${el_count}    SeleniumLibrary.Get Element Count    ${lc_LOCATORS['portal-pages']['live-schedule']['tbl-matches']}[lbl-scheduled-time]
    ${matches}    Create List
    FOR    ${el}    IN RANGE    1    ${el_count}
        ${lc_match_time}    Build Locator From Template    ${lc_LOCATORS['portal-pages']['live-schedule']['tbl-matches']}[lbl-scheduled-time-template]    index=${el}
        ${lc_match_home}    Build Locator From Template    ${lc_LOCATORS['portal-pages']['live-schedule']['tbl-matches']}[lbl-match-team-home-template]    index=${el}
        ${lc_match_away}    Build Locator From Template    ${lc_LOCATORS['portal-pages']['live-schedule']['tbl-matches']}[lbl-match-team-away-template]    index=${el}
        ${match_time}    Get Text    ${lc_match_time}
        ${match_home}    Get Text    ${lc_match_home}
        ${match_away}    Get Text    ${lc_match_away}
        ${match}    Create Dictionary    name=${match_home} - ${match_away}    time=${match_time}    status=scheduled
        Append To List    ${matches}    ${match}
    END
    Unpause Logging
    [Return]    ${matches}

Check Match Status
    [Arguments]    ${match}    ${match_id}    ${handle_delays}=False
    [Documentation]    Checks if a given match is live, delayed, or dropped and returns the marked match dictionary.
    ...
    ...    Examples:
    ...    | ${updated_match} | Check Match Status | \ {'name' : 'AEK-OLYMPIAKOS','time':'11-07-2025 17:57','status' : 'scheduled'} | True | #If handle_delays is true then match will be marked as delayed or dropped |
    ...    | ${updated_match} | Check Match Status | \ {'name' : 'AEK-OLYMPIAKOS','time':'11-07-2025 17:57','status' : 'scheduled'} | False | #If handle_delays is false then match will not be marked as delayed or dropped |
    Go To Live Betting Page
    Filter Live Matches    ${match_id}
    ${found}=    Is Match Live    ${match}[name]
    IF    '${found}' == 'True'
        IF    "${handle_delays}"=="True"
            Set To Dictionary    ${match}    status=on_time
            ${time_live}    Get Current Date    result_format=%d-%m-%Y %H:%M
            Set To Dictionary    ${match}    time_went_live=${time_live}
        ELSE
            Set To Dictionary    ${match}    status=is_live
            ${time_live}    Get Current Date    result_format=%d-%m-%Y %H:%M
            Set To Dictionary    ${match}    time_went_live=${time_live}
        END
    ELSE
        IF    "${handle_delays}"=="True"
            ${match}    Handle Delayed Match    ${match}
        ELSE
            Set To Dictionary    ${match}    status=is_not_live
            Set To Dictionary    ${match}    time_went_live=-
        END
    END
    [Return]    ${match}

Go to Live Schedule Page
    [Documentation]    Opens new window in live-betting url as it is specified in _Specs.json_ .
    Go To    ${cf_SPECS}[url_schedule]
    Wait Until Page Contains Item    ${lc_LOCATORS['portal-pages']['live-schedule']}[btn-drpdn-all-match]
