*** Settings ***
Documentation     Library contains keywords for loading configuration components needed for test suite run
...
...               ================
...               *Library Keywords*
...               ================
...
...               | `Build Configuration File Path` |
...               | `Load Portal Locators` |
...               | `Load Portal Specs` |
Library           OperatingSystem
Resource          Readers.resource

*** Variables ***
${lc_LOCATORS}    ${EMPTY}    # Will be filled later with the locators for page items





${cf_SPECS}       ${EMPTY}    # Will be filled later with the specs of portal page




*** Keywords ***
Build Configuration File Path
    [Arguments]    ${path}    ${file}
    [Documentation]    Builds path to configuration file.    # Config/locators.json |
    ...
    ...    _path_ is the path to directory with configuration files
    ...
    ...    _file_ is the name of file to read
    ...
    ...    Examples:
    ...    | ${filepath} | Build Configuration File Path | Config | Locators.json |
    ${nrz_path}    Normalize Path    ${path}
    ${path_to_file}    Join Path    ${nrz_path}    ${file}
    [Return]    ${path_to_file}

Load Portal Locators
    [Arguments]    ${path}    ${file}
    [Documentation]    Reads locators for portal page items from file.    # Suite Variable _lc_LOCATORS_ contains the locators for portal page items read from file _Settings/EUT/locators.json_ |
    ...
    ...    KW reads locators for portal page items from _file_ as dictionary and set it to the *Suite Varable* _lc_LOCATORS_ to be used later by other KWs.
    ...
    ...    _path_ is the path to directory with settings
    ...
    ...    _file_ is the name of the file to read
    ...
    ...    _info_: This Keyword should be used only in Suite Setup since it reads the file and stores the paths in Suite level dictionary variable. Works even if used inside Test Case but it will slow the Test down because of the multiple read of the same file.
    ...
    ...    Examples:
    ...    | Load Portal Locators | Settings | locators.json |
    ${path_to_file}    Build Configuration File Path    ${path}    ${file}
    Load File To Suite Variable    ${path_to_file}    \${lc_LOCATORS}

Load Portal Specs
    [Arguments]    ${path}    ${file}
    [Documentation]    Reads specs for portal page from file.    # Suite Variable _lc_LOCATORS_ contains the locators for portal page items read from file _Settings/EUT/locators.json_ |
    ...
    ...    KW reads specs for portal page from _file_ as dictionary and set it to the *Suite Varable* _cf_SPECS_ to be used later by other KWs.
    ...
    ...    _path_ is the path to directory with settings
    ...
    ...    _file_ is the name of the file to read
    ...
    ...    _info_: This Keyword should be used only in Suite Setup since it reads the file and stores the paths in Suite level dictionary variable. Works even if used inside Test Case but it will slow the Test down because of the multiple read of the same file.
    ...
    ...    Examples:
    ...    | Load Portal Specs | Settings | Specs.json |
    ${path_to_file}    Build Configuration File Path    ${path}    ${file}
    Load File To Suite Variable    ${path_to_file}    \${cf_SPECS}
