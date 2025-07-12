*** Settings ***
Documentation     Library contains Keywords to read JSON file.
...
...               ================
...               *Library Keywords*
...               ================
...
...               | `Parse JSON File` |
...               | `Load JSON File` |
Library           OperatingSystem
Library           Collections

*** Variables ***
${NoKeyError}     Error:NoKeyError    # Default value if an asked key is not in JSON data
${SETTINGS_FILE_TYPE}    json    # Defult type for settings files





*** Keywords ***
Parse JSON File
    [Arguments]    ${file}
    [Documentation]    Returns the contents of a specified JSON file as dictionary.
    ...
    ...    This keyword reads the specified file and returns the contents. The file's encoding should be UTF-8.
    ...
    ...    _file_ is the file to read
    ...
    ...    Examples:
    ...    | ${data} | Parse JSON File | /home/users/file.json |
    ${data}    Get File    ${file}    utf-8
    &{key_vals}    Evaluate    json.loads($data)    json
    IF    '${LOG_LEVEL}' == 'DEBUG'
    Log Dictionary    dictionary=&{key_vals}    level=DEBUG
    END
    [Return]    &{key_vals}

Load JSON File
    [Arguments]    ${file}
    [Documentation]    Returns the content of the secified JSON file as dictionary.
    ...
    ...    _file_ is the JSON file to be parsed.
    ...
    ...    Examples:
    ...    | &{locators} | Load JSON File | locators.json |
    &{data}    Parse JSON File    ${file}
    [Return]    &{data}

Load File To Dictionary
    [Arguments]    ${file}
    [Documentation]    Returns the content of the secified file as dictionary.
    ...
    ...    _file_ is the full path to file to be parsed.
    ...
    ...    Examples:
    ...    | &{data} | Load File To Dictionary | Conf${/}locators.json |
    IF    '${SETTINGS_FILE_TYPE.strip().lower()}' == 'json'
    &{data}    Load JSON File    ${file}
    ELSE
    Log    level=WARN    message=Type '${SETTINGS_FILE_TYPE.strip().lower()}' is not supported as configuration file format yet
    END
    [Return]    &{data}

Load File To Suite Variable
    [Arguments]    ${file}    ${variable}
    [Documentation]    Loads the content of the secified file to suite variable by using the preset file parser.    # Suite Variable _LOCATORS_ contains the contents of _Conf/locators.json_ JSON file |
    ...
    ...    KW reads _file_ and loads it to the *Suite Varable* _variable_ to be used later by other KWs. The variable _SETTINGS_FILE_TYPE_ is used to call the correct reader.
    ...
    ...    _file_ is the full path to file to be parsed.
    ...
    ...    _varable_ is the variable to load the contents as dictionary. This variable will be set as *Suite Variable*.
    ...
    ...    _info_: This Keyword should be used only in Suite Setup since it reads the file and stores the configuration in Suite level dictionary variable. Works even if used inside Test Case but will slow the Test down because of the multiple read of the same file.
    ...
    ...    Examples:
    ...    | Load File To Suite Variable | Conf${/}locators.json | \${LOCATORS} |
    &{data}    Load File To Dictionary    ${file}
    Set Suite Variable    ${variable}    ${data}    children=${True}
