*** Settings ***
Documentation     Library contains Keywords to be used in Live Betting page
...
...               ================
...               *Library Keywords*
...               ================
...
...               | `Go To Live Betting Page` |
...               | `Is Match Live` |
...               | `Handle Delayed Match` |
...               | `Get Time To Wait` |
...               | `Normalize Scheduled Time` |
...
...               =================
...               *Library variables*
...               =================
...               - _DROP_THRESHOLD_MINUTES_: If a match is delayed, when will be considered as dropped in minutes.
...               - _DROP_THRESHOLD_SEC_: If a match is delayed, when will be considered as dropped in seconds.
...               - _RETRY_COUNT_: If a match is delayed, how many times will be re-checked for going live.
...               - _RETRY_INTERVAL_: If a match is delayed, when will be re-checked for going live in seconds.
Library           SeleniumLibrary
Resource          ../System/LowLevelLib.resource
Library           Collections
Resource          ../System/Waits.resource
Library           DateTime

*** Variables ***
${DROP_THRESHOLD_MINUTES}    20    # Threshold of when a scheduled map is considered as dropped after goes live
${DROP_THRESHOLD_SEC}    ${DROP_THRESHOLD_MINUTES * 60}    # Threshold of when a scheduled map is considered as dropped after it goes live (in seconds)
${RETRY_COUNT}    10    # Max retry times
${RETRY_INTERVAL_SEC}    30    # Interval between retries













*** Keywords ***
Go To Live Betting Page
    [Documentation]    Opens new window in live-betting url as it is specified in _Specs.json_ .
    Go To    ${cf_SPECS}[url_live]
    Wait Until Page Contains Item    ${lc_LOCATORS['portal-pages']['live-betting']}[cntr-match]

Is Match Live
    [Arguments]    ${match_name}
    [Documentation]    Returns True if match was found in live page.
    ...
    ...    *Args*
    ...    - _match_name_ : name of match to search as a pair of home and away teams.
    ...
    ...    *Examples*
    ...    | ${is_live} = | Is Match Live | AEK-OLYMPIAKOS |
    Pause Logging
    ${category_count}    SeleniumLibrary.Get Element Count    ${lc_LOCATORS['portal-pages']['live-betting']}[cntr-category]
    FOR    ${i}    IN RANGE    1    ${category_count+1}
        ${lc_category}    Build Locator From Template    ${lc_LOCATORS['portal-pages']['live-betting']}[cntr-category-template]    index=${i}
        Scroll Element Into View    ${lc_category}
        ${lc_category_home}    Build Locator From Template    ${lc_LOCATORS['portal-pages']['live-betting']['tbl-matches']}[lbl-match-team-home]    cat=${i}
        ${el_count}    SeleniumLibrary.Get Element Count    ${lc_category_home}
        ${live_matches}    Create List
        FOR    ${j}    IN RANGE    1    ${el_count+1}
            ${lc_match_home}    Build Locator From Template    ${lc_LOCATORS['portal-pages']['live-betting']['tbl-matches']}[lbl-match-team-home-template]    cat=${i}    index=${j}
            ${lc_match_away}    Build Locator From Template    ${lc_LOCATORS['portal-pages']['live-betting']['tbl-matches']}[lbl-match-team-away-template]    cat=${i}    index=${j}
            ${match_home}    Get Text    ${lc_match_home}
            ${match_away}    Get Text    ${lc_match_away}
            ${match}    Create Dictionary    name=${match_home} - ${match_away}    status=live
            Append To List    ${live_matches}    ${match}
        END
        ${found}=    Set Variable    False
        FOR    ${match}    IN    @{live_matches}
            ${live_match_name}=    Set Variable    ${match}[name]
            IF    "${match_name}"=="${live_match_name}"
                ${found}    Set Variable    True
                Exit For Loop
            END
        END
        IF    "${found}"=="True"
            Exit For Loop
        END
    END
    Unpause Logging
    [Return]    ${found}

Handle Delayed Match
    [Arguments]    ${match}
    [Documentation]    Returns updated match dictionary if match was not directly found in live scheduled, if it was found with delay or if was not found at all.
    ...
    ...    *Args*
    ...    - _match_ : match dictionary with match info
    ...
    ...    *Examples*
    ...    | ${match_updated} = | Handle Delayed Match | {'name' : 'AEK-OLYMPIAKOS','time':'11-07-2025 17:57','status' : 'scheduled'} |
    Pause Logging
    ${start_time}=    Get Current Date    result_format=%H:%M:%S
    FOR    ${i}    IN RANGE    ${RETRY_COUNT}
        Wait    ${RETRY_INTERVAL_SEC}    Wait interval
        Go To Live Betting Page
        ${is_now_live}=    Is Match Live    ${match}[name]
        IF    '${is_now_live}' == 'True'
            Set To Dictionary    ${match}    status=delayed
            ${time_live}    Get Current Date    result_format=%d-%m-%Y %H:%M
            Set To Dictionary    ${match}    time_went_live=${time_live}
        END
        IF    '${is_now_live}' == 'True'
            Exit For Loop
        END
        ${now}    Get Current Date    result_format=%H:%M:%S
        ${elapsed}=    Subtract Time From Time    ${now}    ${start_time}
        IF    ${elapsed} >= ${DROP_THRESHOLD_SEC}
            Set To Dictionary    ${match}    status=dropped
        END
        IF    ${elapsed} >= ${DROP_THRESHOLD_SEC}
            Exit For Loop
        END
    END
    Unpause Logging
    [Return]    ${match}

Get Time To Wait
    [Arguments]    ${start_time}    ${scheduled_time}
    [Documentation]    Returns time to wait for the match that will start to be checked as a substract of stat time, and time elapsed so far. I.e. if a match will run in 15 minutes and elapsed time is 7 minutes, wait will be 8 more minutes.
    ...
    ...    *Args*
    ...    - _start_time_ : when test suite started
    ...    - _scheduled_time_: when a scheduled events is expected to be live in minutes
    ...
    ...    *Examples*
    ...    | ${time_to_wait} = | Get Time To Wait | 16:00 | 6 |
    ${time_number_secs}    Evaluate    ${scheduled_time}*60
    ${now}    Get Current Date    result_format=%H:%M:%S
    ${elapsed}=    Subtract Time From Time    ${now}    ${start_time}
    ${time_to_wait}    Evaluate    int(${${time_number_secs}-${elapsed}})
    [Return]    ${time_to_wait}

Normalize Scheduled Time
    [Arguments]    ${scheduled_time}
    [Documentation]    Returns scheduled time as a number in minutes
    ...
    ...    *Args*
    ...    - _scheduled_time_ : when event is expected to be live given from portal
    ...
    ...    *Examples*
    ...    | ${nrlz_scheduled_time} = | Normalize Scheduled Time | σε 4' |
    ${nrlz_time_number}    Split String    ${scheduled_time}
    ${nrlz_number}    Remove String    ${nrlz_time_number}[1]    '
    ${time_number}    Convert To Integer    ${nrlz_number}
    [Return]    ${time_number}
