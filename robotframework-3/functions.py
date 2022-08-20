# script with functions which serves as Keywords for the Test Suite


from jnpr.junos import Device
from jnpr.junos.utils.config import Config
import xml.etree.ElementTree as ET


def connect_to_device(host, user, pwd, port):
    dev = Device(host=host, user=user, password=pwd, port=port)
    dev.open()
    return dev


def teardown(device):
    device.close()


def intf_up_count(device):
    intf_xml = device.rpc.get_interface_information(terse=True)
    physical_up_count = intf_xml.xpath(".//physical-interface[oper-status='\nup\n']")
    logical_count = intf_xml.xpath(".//physical-interface/logical-interface[oper-status='\nup\n']")
    return len(physical_up_count)+len(logical_count)


def ospf_nbr_count(device):
    ospf_xml = device.rpc.get_ospf_neighbor_information()
    full_nbr_count = ospf_xml.xpath(".//ospf-neighbor[ospf-neighbor-state='Full']")
    return len(full_nbr_count)


def bgp_up_count(device):
    bgp_xml = device.rpc.get_bgp_summary_information()
    total_peers = bgp_xml.findtext(".//peer-count")
    down_peers = bgp_xml.findtext(".//down-peer-count")
    return int(total_peers)-int(down_peers)


def sys_alarm_check(device):
    alarm_xml = device.rpc.get_system_alarm_information()
    alarm_count = alarm_xml.findtext(".//active-alarm-count")
    return int(alarm_count)


def cfg_back(device, cfg_format):
    conf_xml = device.rpc.get_config(options={'format': cfg_format})
    conf_str = ET.tostring(conf_xml)
    conf_list = conf_str.decode('UTF-8').splitlines()[1:-1]
    hostname = device.facts['hostname']
    with open(f"{hostname}_backup", "w") as f:
        for line in conf_list:
            f.write(f"{line}\n")
    return hostname


def configuration(device, config_vars):
    with Config(device, mode='private') as cu:
        cu.load(template_path='config.conf', template_vars=config_vars, merge=True, format='set')
        diff = cu.diff()
        result = cu.commit()
        return result, diff
