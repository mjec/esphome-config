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
  - platform: output
    name: "Relay 1"
    output: relay_1
  - platform: output
    name: "Relay 2"
    output: relay_2
  - platform: output
    name: "Relay 3"
    output: relay_3
  - platform: output
    name: "Relay 4"
    output: relay_4
  - platform: output
    name: "Relay 5"
    output: relay_5
  - platform: output
    name: "Relay 6"
    output: relay_6
  - platform: output
    name: "Relay 7"
    output: relay_7
  - platform: output
    name: "Relay 8"
    output: relay_8

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
