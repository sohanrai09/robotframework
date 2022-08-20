*** Keywords ***

Interface Up Count
    [Documentation]      Keyword to check and verify number of interfaces that are UP
    [Arguments]          ${device}
    ${int_up}            Intf Up Count    ${device}
    should be equal    ${int_up}     ${interface.up_count}

Ospf Neighbor Count
    [Documentation]     Keyword to check and verify number OSPF neighbors in Full State
    [Arguments]         ${device}
    ${ospf_full}        OSPF Nbr Count    ${device}
    should be equal    ${ospf_full}     ${ospf.nbr_full}

BGP Neighbor Count
    [Documentation]    Keyword to check and verify the number of BGP Peers that are UP
    [Arguments]    ${device}
    ${bgp_up}     BGP Up Count    ${device}
    should be equal    ${bgp_up}    ${bgp.peers_up}

System Alarm Check
    [Documentation]    keyword to check and verify system alarm count
    [Arguments]    ${device}
    ${sys_alarms}    Sys Alarm Check    ${device}
    should be equal    ${sys_alarms}    ${system_alarms.active_count}

Configuring Device
    [Documentation]    keyword to make the required config changes
    [Arguments]    ${device}    ${config_vars}
    ${result}    ${diff}    Configuration     ${device}     ${config_vars}
    should be true    ${result}
    log to console    \nConfiguration applied successfully!
    log to console    \n~~~~ Config Diff ~~~~\n${diff}\n

Config Backup
    [Documentation]    keyword to save the config before making changes, format can be set, json, xml.
    [Arguments]    ${device}    ${cfg_format}
    ${filename}    Cfg Back    ${device}    ${cfg_format}
    log to console    \nBackup Filename: ${filename}\n
