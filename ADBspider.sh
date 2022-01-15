#! /bin/bash



#========= Configurations ===========

Output_Directory="outPuts"
Read_SDcard=true
Read_Contacts=true
Read_IP_Addresses=true
Read_operator_names=true
Enable_ADB_over_TCPIP=true
TCP_port=5555

#=================================




#==================== Do not Edit below ========================================================================================

checkUSBdebugging()
{
echo "Checking USB Debugging Status on the target Device........."
check=$(adb devices)
if echo $check | grep -q -w 'device'; then
echo -e "\e[1;32m USB Debugging Enabled \e[0m"
startOperaation
elif echo $check | grep -q -w 'unauthorized'; then
echo -e "\e[1;35m Please Allow this device on the target device \e[0m"
read -p "Retry to connect (Y / N):" retry
if [[ "$retry" == "Y" || "$retry" == "y" ]]; then
checkUSBdebugging
fi
else
echo -e "\e[1;31m Device Not Connected or USB Debugging is not enabled on the target Device \e[0m"
read -p "Retry to connect (Y / N):" retry
if [[ "$retry" == "Y" || "$retry" == "y" ]]; then
checkUSBdebugging
fi
fi
}

drawLine()
{
line=""
a=0
while [ $a -lt 70 ]
do
line+="="
echo -ne "$line \r"
sleep 0.005
a=`expr $a + 1`
done
echo $line
echo " "
sleep 0.5
}

startOperaation()
{
if [ -d "./$Output_Directory" ]; then
echo "Dirctory Already Exists"
else
mkdir "./$Output_Directory"
echo "OutPut directory created."
fi


if $Read_SDcard
then
echo -e "\e[1;33m Reading SD card content list .......... \e[0m"
adb shell ls -R /sdcard > ./$Output_Directory/sdcard_content_list_$(date +"%Y_%m_%d_%I_%M_%p").txt
fi

if $Read_Contacts
then
echo -e "\e[1;33m Reading Local contacts ......... \e[0m"
adb shell content query --uri content://com.android.contacts/data --projection display_name:data1:data4:contact_id > ./$Output_Directory/local_contacts_$(date +"%Y_%m_%d_%I_%M_%p").txt
fi

if $Read_IP_Addresses
then
echo -e "\e[1;33m Reading Current IP addresses ........... \e[0m"
adb shell ifconfig > ./$Output_Directory/current_IP_addresses_$(date +"%Y_%m_%d_%I_%M_%p").txt
if $Read_operator_names
then
echo -e "\e[1;33m Reading Operator Names ........... \e[0m"
echo " " >> ./$Output_Directory/current_IP_addresses_$(date +"%Y_%m_%d_%I_%M_%p").txt
echo "--------------------------------------------------------------" >> ./$Output_Directory/current_IP_addresses_$(date +"%Y_%m_%d_%I_%M_%p").txt
adb shell getprop gsm.sim.operator.alpha >> ./$Output_Directory/current_IP_addresses_$(date +"%Y_%m_%d_%I_%M_%p").txt

fi
fi

echo -e "------------ Data Reading complete ------------"

if $Enable_ADB_over_TCPIP
then
adb tcpip $TCP_port
echo -e "\e[1;32m ADB Enabled over TCP/IP port $TCP_port \e[0m"
fi

}

printBanner()
{
cat<<EOF

 ██████╗██╗     ██╗ ██████╗██╗  ██╗███████╗                           
██╔════╝██║     ██║██╔════╝██║ ██╔╝██╔════╝                           
██║     ██║     ██║██║     █████╔╝ ███████╗                           
██║     ██║     ██║██║     ██╔═██╗ ╚════██║                           
╚██████╗███████╗██║╚██████╗██║  ██╗███████║                           
 ╚═════╝╚══════╝╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝                           
                                                                      
             █████╗ ███╗   ██╗██████╗     ██████╗ ██╗████████╗███████╗
            ██╔══██╗████╗  ██║██╔══██╗    ██╔══██╗██║╚══██╔══╝██╔════╝
            ███████║██╔██╗ ██║██║  ██║    ██████╔╝██║   ██║   ███████╗
            ██╔══██║██║╚██╗██║██║  ██║    ██╔══██╗██║   ██║   ╚════██║
            ██║  ██║██║ ╚████║██████╔╝    ██████╔╝██║   ██║   ███████║
            ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝     ╚═════╝ ╚═╝   ╚═╝   ╚══════╝
                                                                      
                                                                                                        
EOF
}

printBanner
drawLine
checkUSBdebugging

echo " "
drawLine
echo "End of the Script"
