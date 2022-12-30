#!/bin/bash
#
# NordVPN GUI
#
# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# guelfoweb@gmail.com wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return Gianni Amato
# ----------------------------------------------------------------------------

# you can change this value with your country
default_city="Italy"

connect(){
	answer=$(zenity --forms --title "NordVPN" --text "$msg_status" --add-combo "Cities" --ok-label="Connect" --combo-values "$cities")
	if [ "$answer" ]; then
		nordvpn c $answer
	fi
}

disconnect(){
	answer=$(zenity --question --title "NordVPN" --text="<b>Do you want disconnect from NordVPN?</b>$status" --ok-label="Disconnect")
	if [ $? = 0 ]; then
		nordvpn d
	fi
}

countries(){
	cities=$(nordvpn countries | cut -d\/ -f2 | tr '\t' '\n' | sed '/^$/d')
	cities=$(echo $cities | sed 's/\s/|/g' | sed 's/^[^[:alnum:]]*//' | sed "s/^/$default_city|/")
}

start(){
	status=$(nordvpn status | cut -d\/ -f2)

	if echo $status | grep "Status: Disconnected" > /dev/null; then
		msg_status="Status: <i>Disconnected</i>"
		countries
		connect
	elif echo $status | grep "Status: Connected" > /dev/null; then
		msg_status="Status: <b>Connected</b>"
		disconnect
	else
		echo $status
	fi
}

start
