# imports
# Check for user imports
from __future__ import print_function
import config

import state
import SkyCamera


#Establish WeatherSTEMHash
if (config.USEWEATHERSTEM == True):
    state.WeatherSTEMHash = SkyCamera.SkyWeatherKeyGeneration(config.STATIONKEY)

    print("config.STATIONKEY=", config.STATIONKEY)
else:
    print("config.USEWEATHERSTEM is false, will not attempt to publish to WeatherSTEM")

if (config.WeatherUnderground_Camera_Present):
    print("config.WeatherUnderground_Camera_DeviceId=", config.WeatherUnderground_Camera_DeviceId)
    print("config.WeatherUnderground_Camera_UploadKey=", config.WeatherUnderground_Camera_UploadKey)
else:
    print("config.WeatherUnderground_Camera_Present is false, will not attempt to publish image to WeatherUnderground")
# test SkyWeather Camera and WeatherSTEM
SkyCamera.useSkyCamera()
