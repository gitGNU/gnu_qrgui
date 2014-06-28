#!/bin/bash
#
# Copyright (C) 2014 Joshua Wells
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#Setup

#The icon that appears in the dialog boxes and the window selector.
#Using the `dirname $0` part looks for the icon in the directory that the
#script is in, not the directory it is run from.
ICON=`dirname $0`/qricon.png

#It's much easier to change the program version number when
#it's closer to the top.
VERSIONNUMBER="1.1"

#Enter different text below and the whole program is rebranded.
TITLE="Qrgui"

function checkIfCanceled
  {
    #Checks if the window was closed/canceled by looking
    #for exit code 1, if so, the program is closed.
    if  [ $? = 1 ]
      then
        exit 1;
    fi
  }

#Checks if qrencode is installed.
qrencode -o /dev/null "Test"

if  [ $? = 127 ]; then
    echo -e "The QR code generator, qrencode, is not installed.";
    zenity --info \
           --window-icon=$ICON \
           --title="$TITLE" \
           --width=400 \
           --text="The QR code generator, qrencode, is not installed. It must be installed for Qrgui to work.

Try installing it with your preferred package manager."
    exit 1;
fi

#Print name and copyright information.
echo "$TITLE $VERSIONNUMBER"
echo "Copyright (C) 2014 Joshua Wells"
echo "This is free software; see README for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."

QRSTRING=$(zenity --entry \
                  --title="$TITLE" \
                  --window-icon=$ICON \
                  --text="Enter text to encode into a QR code." \
                  --width=300)

checkIfCanceled

# Makes an empty variable to compare to QRSTRING to check for empty text entry.
BLANK=""

#Compares QRSTRING to BLANK to see if text entry field is blank.
#If the field is blank, make a dialog box showing the error.
if [ $QRSTRING = $BLANK ]; then
    zenity --error \
           --width=270 \
           --title="$TITLE" \
           --window-icon=$ICON \
     --text="The text entry field cannot be blank. $TITLE will now close." \
           --timeout=4
           echo -e "\nExiting $TITLE..."
           exit 1;
fi

#Sets the variable FILENAME to the name and path to save the QR code.
FILENAME=$(zenity --file-selection \
              --window-icon=$ICON \
              --title="Save QR Code - $TITLE" \
              --save \
              --confirm-overwrite)

checkIfCanceled

#Generates the QR code.
qrencode -o "$FILENAME" "$QRSTRING"

#Checks if QR code was generated successfully.
if  [ $? = 0 ]; then

    echo -e "\nQR code generated successfully"
    exit 0;

  else

    echo -e "\nAn error occurred."
    exit 1;
fi

