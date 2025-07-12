*** Settings ***
Documentation     Library contains Keywords for manipulating XML reports
...
...               ================
...               *Library Keywords*
...               ================
...
...               | `Generate Report for Scheduled Events` |
...               | `Generate Report of Events With Marks` |
...               | `Generate Report of Delays and Drops` |
Resource          ../PortalWidgets/Filters.resource
Resource          ../System/LowLevelLib.resource
Resource          ../PortalPages/LiveBetting.resource
Library           XML

*** Keywords ***
Generate Report for Scheduled Events
    [Arguments]    ${report_title}    ${matches}
    [Documentation]    It generates an XML report with events and when they turned live
    ...
    ...    Examples:
    ...    | Generate Report for Scheduled Events | Validation | &{match_names} |
    ${xml}=    Set Variable    <events>
    FOR    ${m}    IN    @{matches}
        ${line}=    Catenate    <event><name>${m}[name]</name><status>${m}[status]</status><scheduled_time>${m}[time]</scheduled_time><live_time>${m}[time_went_live]</live_time></event>
        ${xml}=    Catenate    ${xml}    ${line}
    END
    ${xml}=    Catenate    ${xml}    </events>
    Save Xml    ${xml}    Novibet/Outputs/${report_title}.xml

Generate Report of Events With Marks
    [Arguments]    ${report_title}    ${matches}
    [Documentation]    It generates an XML report with events, event status and timestamps.
    ...
    ...    Examples:
    ...    | Generate Report of Events With Marks | Validation | &{match_names} |
    ${xml}=    Set Variable    <events>
    FOR    ${m}    IN    @{matches}
        ${line}=    Catenate    <event><name>${m}[name]</name><status>${m}[status]</status><scheduled_time>${m}[time]</scheduled_time></event>
        ${xml}=    Catenate    ${xml}    ${line}
    END
    ${xml}=    Catenate    ${xml}    </events>
    Save Xml    ${xml}    Novibet/Outputs/${report_title}.xml

Generate Report of Delays and Drops
    [Arguments]    ${report_title}    ${matches}
    [Documentation]    It generates an XML report with events, event status and timestamps.
    ...
    ...    Examples:
    ...    | Generate Report | Validation | &{match_names} |
    Pause Logging
    ${xml}=    Set Variable    <events>
    FOR    ${m}    IN    @{matches}
        ${line}=    Catenate    <event><name>${m}[name]</name><status>${m}[status]</status><scheduled_time>${m}[time]</scheduled_time><live_time>${m}[time_went_live]</live_time></event>
        ${xml}=    Catenate    ${xml}    ${line}
    END
    ${xml}=    Catenate    ${xml}    </events>
    Save Xml    ${xml}    Novibet/Outputs/${report_title}.xml
    Unpause Logging

