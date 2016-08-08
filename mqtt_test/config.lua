-- file : config.lua
local module = {}

module.SSID = {}  
module.SSID["<SSID>"] = "<KEY>"

module.HOST = "<mqtthost>"
module.PORT = 1883
module.ID = node.chipid()

module.SENSOR_PIN = 7
module.LED_PIN = 8

module.ENDPOINT = "netfalo/"
return module
