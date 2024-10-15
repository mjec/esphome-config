# This is the esphome configuration for our custom HVAC controller.
# It is configured as follows:
#
#   Relay 1   on = cooling, off = heating   common = 12, normally_open = 14, normally_connected = 11
#   Relay 2   on = cooling, off = heating   common = 18, normally_open = 19, normally_connected = 17
#   Relay 3   on = fan on, off = fan auto   common = 15, normally_open = 16, normally_connected = relay_4_no
#   Relay 4   on = cooling, off = heating   common = 14, normally_open = relay_3_nc, normally_connected = (not connected)
#   Relay 5   on = zome 1 call, off = off   common = 18, normally_open = T5 (zone 1), normally_connected = (not connected)
#   Relay 6   on = zome 2 call, off = off   common = 18, normally_open = T5 (zone 2), normally_connected = (not connected)
#   Relay 7   (not connected)
#   Relay 8   (not connected)
#
# Observed system states are:
#
#   Cooling
#     - 12 connected to 14
#     - 18 connected to 19

#   Heating
#     - 12 connected to 11
#     - 18 connected to 17

#   Fan only mode
#     - 18 connected to 19      !!! TODO: check configuration here; I think this means R2 on + R1 off? Maybe?

#   Fan mode on
#     - 15 connected to 16

#   Fan mode auto
#     - 14 connected to 15, but only if cooling

#   Calling for service
#     - T5 connects to T6 for cooling; note T6 is always tied to 19
#     - T5 connects to T4 for heating; note T4 is always tied to 17
#     - Zone is determined by which T5 is connected

esphome:
  name: hvac-relays
  # This is actually an ESP8266EX with 4mb RAM running at 26 MHz
  platformio_options:
    board_build.f_cpu: 26000000L
    board_upload.maximum_size: 4194304

esp8266:
  board: esp01_1m

# Enable logging
logger:

# Enable Home Assistant API
api:
  encryption:
    key: "op://Service Accounts/hvac-relays/API encryption key"

ota:
  - platform: esphome
    password: "op://Service Accounts/hvac-relays/OTA update password"

wifi:
  ssid: "op://Private/Cordubel-IoT-NI/network name"
  password: "op://Private/Cordubel-IoT-NI/wireless network password"
  fast_connect: true

  # Enable fallback hotspot (captive portal) in case wifi connection fails
  ap:
    ssid: "op://Service Accounts/hvac-relays/Fallback hotspot SSID"
    password: "op://Service Accounts/hvac-relays/Fallback hotspot password"

captive_portal:

switch:
  - platform: template
    name: "Climate mode"
    turn_on_action: # on = cooling
      - switch.turn_on: climate_mode_relay_1
      - switch.turn_on: climate_mode_relay_2
      - switch.turn_on: climate_mode_relay_4
    turn_off_action: # off = heating
      - switch.turn_off: climate_mode_relay_1
      - switch.turn_off: climate_mode_relay_2
      - switch.turn_off: climate_mode_relay_4
    lambda: |-
      return id(climate_mode_relay_1).state && id(climate_mode_relay_1).state && id(climate_mode_relay_4).state;
  - platform: output
    id: climate_mode_relay_1
    #internal: true
    output: relay_1
  - platform: output
    id: climate_mode_relay_2
    #internal: true
    output: relay_2
  - platform: output
    id: climate_mode_relay_4
    #internal: true
    output: relay_4
  - platform: output
    name: "Fan mode" # on = on, off = auto
    output: relay_3
  - platform: output
    name: "Zone 1 call"
    output: relay_5
  - platform: output
    name: "Zone 2 call"
    output: relay_6
  - platform: output
    name: "Relay 7 (not connected)"
    output: relay_7
    disabled_by_default: true
  - platform: output
    name: "Relay 8 (not connected)"
    output: relay_8
    disabled_by_default: true

output:
  - platform: gpio
    pin: GPIO12
    id: relay_1
  - platform: gpio
    pin: GPIO14
    id: relay_2
  - platform: gpio
    pin: GPIO16
    id: relay_3
  - platform: gpio
    pin: GPIO05
    id: relay_4
  - platform: gpio
    pin: GPIO04
    id: relay_5
  - platform: gpio
    pin: GPIO00
    id: relay_6
  - platform: gpio
    pin: GPIO02
    id: relay_7
  - platform: gpio
    pin: GPIO15
    id: relay_8
