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

climate:
  - &thermostat-zone
    name: "Zone 1"
    sensor: temperature_zone_1
    idle_action:
      - output.turn_off: K5
    heat_action:
      - output.turn_on: K5
    cool_action:
      - output.turn_on: K5

    # Common definitions below this point
    platform: thermostat
    min_cooling_off_time: 300s
    min_cooling_run_time: 300s
    min_heating_off_time: 300s
    min_heating_run_time: 300s
    min_fanning_off_time: 30s
    min_fanning_run_time: 30s
    min_fan_mode_switching_time: 30s
    min_idle_time: 30s
    fan_only_cooling: false

    cool_mode:
      - output.turn_on: K1
      - output.turn_on: K2
      - output.turn_on: K4
      - output.turn_on: K7
      - output.turn_on: K8
    heat_mode:
      - output.turn_off: K1
      - output.turn_off: K2
      - output.turn_off: K4
      - output.turn_on: K7
      - output.turn_on: K8
    fan_only_mode:
      - output.turn_off: K1
      - output.turn_on: K2
      - output.turn_off: K4
      - output.turn_off: K7
      - output.turn_on: K8
    off_mode:
      - output.turn_off: K3
      - output.turn_off: K4
      - output.turn_off: K7
      - output.turn_off: K8

    fan_mode_auto_action:
      - output.turn_off: K3
    fan_mode_on_action:
      - output.turn_on: K3

    fan_only_action:
      - output.turn_on: K3

    cool_deadband: 1 °F
    cool_overrun: 1 °F
    heat_deadband: 1 °F
    heat_overrun: 1 °F

    default_preset: home
    preset:
      - name: home
        default_target_temperature_low: 64 °F
        default_target_temperature_high: 69 °F
        fan_mode: auto
      - name: sleep
        default_target_temperature_low: 60 °F
        default_target_temperature_high: 65 °F
        fan_mode: auto
      - name: eco
        default_target_temperature_low: 60 °F
        default_target_temperature_high: 70 °F
        fan_mode: auto
      - name: away
        default_target_temperature_low: 58 °F
        default_target_temperature_high: 72 °F
        fan_mode: auto

  - <<: *thermostat-zone
    name: "Zone 2"
    sensor: temperature_zone_2
    idle_action:
      - output.turn_off: K6
    heat_action:
      - output.turn_on: K6
    cool_action:
      - output.turn_on: K6

sensor:
  - platform: homeassistant
    name: Zone 1 Temperature
    id: temperature_zone_1
    unit_of_measurement: "°F"
    # These sensors provde a °F value, but esphome interprets it as °C.
    # So convert C -> F and we'll get actual °F.
    filters:
      - lambda: return (x - 32.0) * (5.0/9.0);
    entity_id: sensor.sbht_003c_7e6c_temperature
  - platform: homeassistant
    name: Zone 2 Temperature
    id: temperature_zone_2
    unit_of_measurement: "°F"
    # These sensors provde a °F value, but esphome interprets it as °C.
    # So convert C -> F and we'll get actual °F.
    filters:
      - lambda: return (x - 32.0) * (5.0/9.0);
    entity_id: sensor.sbht_003c_ee92_temperature

output:
  - platform: gpio
    pin: GPIO12
    id: K1
  - platform: gpio
    pin: GPIO14
    id: K2
  - platform: gpio
    pin: GPIO16
    id: K3
  - platform: gpio
    pin: GPIO05
    id: K4
  - platform: gpio
    pin: GPIO04
    id: K5
  - platform: gpio
    pin: GPIO00
    id: K6
  - platform: gpio
    pin: GPIO02
    id: K7
  - platform: gpio
    pin: GPIO15
    id: K8
