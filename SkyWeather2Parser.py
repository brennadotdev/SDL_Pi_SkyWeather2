#
# Parse the JSON blob from rtl_433 into usable weather data
#

def parseFromRtl433(rtlJson):
    
    parsedTemperature = round(((((rtlJson["temperature"] - 400)/10.0) - 32.0)/(9.0/5.0)), 2)
    parsedLight = rtlJson["light"]
    if (parsedLight >= 0x1fffa):
        parsedLight = parsedLight | 0x7fff0000

    parsedUvIndex =rtlJson["uv"]
    if (parsedUvIndex >= 0xfa):
        parsedUvIndex = parsedUvIndex | 0x7f00
    
    return {
        "timestamp": rtlJson["time"],
        "temperature": parsedTemperature,
        "humidity": rtlJson["humidity"],
        "sunlight": {
            "visible": parsedLight,
            "uvIndex": round(parsedUvIndex/10.0, 1 )
        },
        "wind": {
            "speed": round(rtlJson["avewindspeed"]/10.0, 1),
            "gust": round(rtlJson["gustwindspeed"]/10.0, 1),
            "direction": rtlJson["winddirection"]
        },
        "rain": {
          "total": round(rtlJson["cumulativerain"]/10.0, 1)  
        },
        "barometric": {
            "temperature": 0,
            "pressure": 0,
            "trend": 0
        },
        "aqi": 0,
        "battery": "OK" if rtlJson['batterylow'] == 0 else "LOW"
    }