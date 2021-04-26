import paho.mqtt.client as mqtt
import time
import sys
import json
import SkyWeather2Parser


def main():
    client = mqtt.Client()
    client.connect("192.168.50.147", 1883 , 60)
    client.loop_start()

    for line in sys.stdin:
        if ("FT020T" in line):
            client.publish("sw2/data", SkyWeather2Parser.parseFromRtl433(json.loads(line)))

    time.sleep(2)
    client.loop_stop()

if __name__ == "__main__":
    main()