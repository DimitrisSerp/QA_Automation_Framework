*** Settings ***
Documentation     In this suite are implemented the following tasks:
...
...               - _0001_ : Task 1 - Implementation of filtering functionality which will be used to filter soccer scheduled events. This feature was implemented to support all possible match filters changing _match_id_ string, as mentioned in _Locators.json_ file.
...               - _0002_: Task 2 - Implementation of functionality that indicates when a scheduled event goes live. We use functionality of Task 5 to record these events in XML file.
...               - _0003_: Task 3 and 4 - Implementation of functionality that indicates if a scheduled event is on_time, delayed, or dropped. Implementated in one and single Test with keywords that cover both tasks.
...               -_0004_: Task 5 - Track delayed and dropped matches
Suite Setup       Setup Test Environment
Suite Teardown    Teardown Test Environment
Test Teardown     Go to Live Schedule Page
Resource          ../Resources/System/Setup.resource
Resource          ../Resources/PortalPages/LiveBetting.resource
Resource          ../Resources/PortalPages/LiveSchedule.resource
Resource          ../Resources/Reports/XML.resource

*** Test Cases ***
NOV-0000-0001-Show only Soccer Matches
    Filter Scheduled Matches    soccer

NOV-0000-0002-Indicate if a scheduled match went live
    [Documentation]    Filters both sceduled and live pages by specific match id. This id should be consistent with Locators.json file on Settings folder. Checks for scheduled events, waits until the scheduled time if it hasn't passed, checks if event appears in live page and report events turned to live with timestamps.
    @{match_status}    Create List
    Filter Scheduled Matches    soccer
    ${Scheduled_matches}=    Get Scheduled Matches
    ${start_time}    Get Current Date    result_format=%H:%M:%S
    ${start_datetime}    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    FOR    ${match}    IN    @{Scheduled_matches}
        ${scheduled_time}=    Set Variable    ${match}[time]
        ${nrlz_scheduled_time}    Normalize Scheduled Time    ${scheduled_time}
        ${time_to_wait}    Get Time To Wait    ${start_time}    ${nrlz_scheduled_time}
        Wait    ${time_to_wait}    Wait for match to go live
        ${match_update}    Check Match Status    ${match}    soccer
        ${scheduled_time_utc}    Add Time To Date    ${start_datetime}    ${nrlz_scheduled_time} minutes    result_format=%d-%m-%Y %H:%M
        Set To Dictionary    ${match_update}    time=${scheduled_time_utc}
        Append To List    ${match_status}    ${match_update}
    END
    #Scheduled Matches Marked with status
    ${Scheduled_matches}=    Set Variable    ${match_status}
    Generate Report for Scheduled Events    Task 2    ${Scheduled_matches}

NOV-0000-0003-Indicate if a scheduled match went live and mark delays
    [Documentation]    Filters both sceduled and live pages by specific match id. This id should be consistent with Locators.json file on Settings folder. Checks for scheduled events, waits until the scheduled time if it hasn't passed, checks if event appears in live page and handles delays as on_time, delayed or dropped.
    @{match_status}    Create List
    Filter Scheduled Matches    soccer
    ${Scheduled_matches}=    Get Scheduled Matches
    ${start_time}    Get Current Date    result_format=%H:%M:%S
    ${start_datetime}    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    FOR    ${match}    IN    @{Scheduled_matches}
        ${scheduled_time}=    Set Variable    ${match}[time]
        ${nrlz_scheduled_time}    Normalize Scheduled Time    ${scheduled_time}
        ${time_to_wait}    Get Time To Wait    ${start_time}    ${nrlz_scheduled_time}
        Wait    ${time_to_wait}    Wait for match to go live
        ${match_update}    Check Match Status    ${match}    soccer    True
        ${scheduled_time_utc}    Add Time To Date    ${start_datetime}    ${nrlz_scheduled_time} minutes    result_format=%d-%m-%Y %H:%M
        Set To Dictionary    ${match_update}    time=${scheduled_time_utc}
        Append To List    ${match_status}    ${match_update}
    END
    #Scheduled Matches Marked with status
    ${Scheduled_matches}=    Set Variable    ${match_status}
    Generate Report of Events With Marks    Task3_4    ${match_status}

NOV-0000-0004-Indicate delayed and dropped matches
    [Documentation]    Filters both sceduled and live pages by specific match id. This id should be consistent with Locators.json file on Settings folder. Checks for scheduled events, waits until the scheduled time if it hasn't passed, checks if event appears in live page and records delayed or dropped events.
    @{match_status}    Create List
    Filter Scheduled Matches    soccer
    Pause Logging
    ${Scheduled_matches}=    Get Scheduled Matches
    ${start_time}    Get Current Date    result_format=%H:%M:%S
    ${start_datetime}    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    FOR    ${match}    IN    @{Scheduled_matches}
        ${scheduled_time}=    Set Variable    ${match}[time]
        ${nrlz_scheduled_time}    Normalize Scheduled Time    ${scheduled_time}
        ${time_to_wait}    Get Time To Wait    ${start_time}    ${nrlz_scheduled_time}
        Wait    ${time_to_wait}    Wait for match to go live
        ${match_update}    Check Match Status    ${match}    soccer    True
        ${scheduled_time_utc}    Add Time To Date    ${start_datetime}    ${nrlz_scheduled_time} minutes    result_format=%d-%m-%Y %H:%M
        Set To Dictionary    ${match_update}    time=${scheduled_time_utc}
        IF    "${match_update}[status]"=="delayed" or "${match_update}[status]"=="dropped"
            Append To List    ${match_status}    ${match_update}
        END
    END
    #Scheduled Matches Marked with status
    ${Scheduled_matches}=    Set Variable    ${match_status}
    Unpause Logging
    Generate Report of Delays and Drops    Task5    ${match_status}
    [Teardown]
