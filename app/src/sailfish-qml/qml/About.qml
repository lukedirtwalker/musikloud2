import QtQuick 2.0
import Sailfish.Silica 1.0

Page {

    SilicaFlickable {
        id: flicker

        anchors.fill: parent
        contentHeight: column.height + 2 * Theme.paddingLarge

        Column {
            id: column

            spacing: Theme.paddingLarge
            width: parent.width

            PageHeader {
                title: qsTr("About")
            }

            Image {
                id: icon

                x: parent.width / 2 - width / 2
                source: "file:///usr/share/icons/hicolor/128x128/apps/harbour-musikloud2.png"
            }

            Label {
                id: titleLabel

                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                font.pixelSize: Theme.fontSizeLarge
                text: "MusiKloud2 " + VERSION_NUMBER
            }

            Label {
                id: aboutLabel

                width: parent.width
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("A Sailfish port of the Harmattan Musikloud2 application by")
                      + "<br><br>&copy; Stuart Howarth 2015<br><br>" +
                      qsTr("This port was realised by Lukas Vogel and Andrin Bertschi")
            }
        }

        VerticalScrollDecorator {}
    }

}
