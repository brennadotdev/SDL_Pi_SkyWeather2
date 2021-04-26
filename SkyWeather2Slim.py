import paho.mqtt.client as mqtt
import time
import sys
import getopt
import json
import SkyWeather2Parser


def main(host):
    client = mqtt.Client()
    client.connect(host, 1883 , 60)
    client.loop_start()

    for line in sys.stdin:
        if ("FT020T" in line):
            client.publish("sw2/data", json.dumps(SkyWeather2Parser.parseFromRtl433(json.loads(line))))

    time.sleep(2)
    client.loop_stop()

if __name__ == "__main__":
    short_options = "h:"
    long_options = ["host="]
    host = "localhost"
    try:
        full_cmd_arguments = sys.argv
        argument_list = full_cmd_arguments[1:]
        arguments, values = getopt.getopt(argument_list, short_options, long_options)
        for argument, value in arguments:
            if (argument in ("-h", "--host")):
                host = value
    except getopt.error as err:
        print(str(err))
        sys.exit(2)
    main(host)