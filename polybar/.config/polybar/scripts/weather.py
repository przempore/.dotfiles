#!/bin/python
# -*- coding: utf-8 -*-

# Procedure
# Surf to https://openweathermap.org/city
# Fill in your CITY
# e.g. Antwerp Belgium
# Check url
# https://openweathermap.org/city/2803138
# you will the city code at the end
# create an account on this website
# create an api key (free)
# LANG included thanks to krive001 on discord


import requests
import geocoder
import time

g = geocoder.ip('me')
print(f"{g.city}")
time.sleep(35)
if "Brzesko" == g.city:
    CITY = "775183" # Brzesko
    LANG = "pl"
elif "Krakow" == g.city:
    CITY = "3094802" # Kraków
    LANG = "pl"
else:
    CITY = "2950159" # Berlin
    LANG = "en"


# CITY = "775758" # Bochnia
API_KEY = "756edce7e9d4c385ef9499a53492678c"
UNITS = "Metric"
UNIT_KEY = "C"

try:
    REQ = requests.get(f"http://api.openweathermap.org/data/2.5/weather?id={CITY}&lang={LANG}&appid={API_KEY}&units={UNITS}")
    # HTTP CODE = OK
    if REQ.status_code == 200:
        CURRENT = REQ.json()["weather"][0]["description"].capitalize()
        TEMP = int(float(REQ.json()["main"]["temp"]))
        print(f"{CURRENT}, {TEMP}°{UNIT_KEY}")
    else:
        print("Error: BAD HTTP STATUS CODE " + str(REQ.status_code))
except (ValueError, IOError):
    print("Error: Unable print the data")
