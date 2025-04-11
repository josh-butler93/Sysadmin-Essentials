def parse_nagios_status():
    performance_data = {}
    
    with open(NAGIOS_STATUS_FILE, 'r') as f:
        service_name = None
        in_servicestatus = False
        perfdata = None

        for line in f:
            line = line.strip()

            if line == "servicestatus {":
                in_servicestatus = True
                service_name = None
                perfdata = None

            elif line == "}":
                if in_servicestatus and service_name and perfdata:
                    # Extract first value only (e.g., load=0.01;5.00;10.00;0)
                    match = re.search(r'(\w+)=(\d+\.?\d*)', perfdata)
                    if match:
                        metric = match.group(1)
                        value = float(match.group(2))
                        key = f"{service_name}_{metric}"
                        performance_data[key] = value
                in_servicestatus = False

            elif in_servicestatus:
                if line.startswith("host_name="):
                    service_name = line.split("=")[1]
                elif line.startswith("performance_data="):
                    perfdata = line.split("=", 1)[1]
    
    return performance_data

# command: chmod +x nagios_to_influxdb.py
# command: python3 nagios_to_influxdb.py 
