*** Settings ***
Library         functions.py
Variables       var.yml
Suite Setup     Test Suite Setup
Resource        my_keywords.robot
Suite Teardown    Test Suite Teardown

*** Test Cases ***
TC - Pre checks before the configuration change & config backup
    [Documentation]     In this testcase various network functions will be checked and matched against a given set
    ...    of ideal values. Test Case would fail if there are any mismatches

    Sanity Checks    ${conn}

    # Backup the current configuration before change
    run keyword if    ${configure.save_cfg}==True
    ...    run keyword and continue on failure    Config Backup         ${conn}    ${configure.save_format}

TC - Configuring the device
    [Documentation]    Configure the device using "config.conf" as the Jinja2 template, with variables from var.yml
    ${config_vars}    set variable    ${configure.intf1}
    run keyword and continue on failure    Configuring Device    ${conn}    ${config_vars}
    log to console    \nWait for 5sec before starting the Post checks
    sleep    5

TC - Post checks after the configuration change
    [Documentation]     In this testcase various network functions will be checked and matched against a given set
    ...    of ideal values. Test Case would fail if there are any mismatches

    Sanity Checks    ${conn}


*** Keywords ***
Test Suite Setup
    [Documentation]    To initialise connection to the device

    ${conn}    Connect To Device    ${device.ip}    ${device.user}    ${device.pwd}    ${device.port}
    Set Suite Variable            ${conn}

Sanity Checks
    [Documentation]    list of checks to run before and after a configuration change
    [Arguments]    ${conn}

    log to console    \nVerifying Interface UP count
    run keyword and continue on failure    Interface Up Count    ${conn}

    log to console    \nVerifying OSPF Neighbor UP count
    run keyword and continue on failure    Ospf Neighbor Count    ${conn}

    log to console    \nVerifying BGP Peer UP count
    run keyword and continue on failure    BGP Neighbor Count    ${conn}

    log to console    \nVerifying System Alarms
    run keyword and continue on failure    System Alarm Check    ${conn}

Test Suite Teardown
    [Documentation]    To close the connection to the device gracefully

    Teardown    ${conn}