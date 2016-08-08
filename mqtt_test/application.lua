-- file : application.lua
local module = {}  
m = nil

-- Sends a simple ping to the broker
local function send_temp()
    status, temp, humi, temp_deci, humi_deci = dht.read11(config.SENSOR_PIN)
    m:publish(config.ENDPOINT .. "temp/" .. config.ID, "{ \"temp\" : \"" .. temp .. "\", \"humi\" : \"" .. humi  .. "\"}" , 0, 0)
end

-- Sends my id to the broker for registration
local function register_myself()  
    m:subscribe(config.ENDPOINT .. config.ID .. "/#",0,function(conn)
        print("Successfully subscribed to data endpoint")
    end)
end

local function mqtt_start()  
    m = mqtt.Client(config.ID, 120)
    -- register message callback beforehand
    m:on("message", function(conn, topic, data) 
      if topic == config.ENDPOINT .. config.ID .. "/ON" then
          gpio.write(config.LED_PIN, gpio.HIGH)
      elseif topic == config.ENDPOINT .. config.ID .. "/OFF" then
          gpio.write(config.LED_PIN, gpio.LOW)
      end
    end)
    -- Connect to broker
    m:connect(config.HOST, config.PORT, 0, 1, function(con) 
        register_myself()
        -- And then pings each 1000 milliseconds
        tmr.stop(6)
        tmr.alarm(6, 1000, 1, send_temp)
    end) 

end

function module.start()  
  mqtt_start()
end

return module
