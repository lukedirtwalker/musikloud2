import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    width: parent.width
    height: Theme.itemSizeMedium

    Image {
        id: thumbnail
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        width: height
        source: thumbnailUrl
        asynchronous: true
    }

    Column {
        anchors {
            left: thumbnail.right
            leftMargin: Theme.paddingMedium
            right: parent.right
            rightMargin: Theme.horizontalPageMargin
            verticalCenter: parent.verticalCenter
        }

        Label {
            width: parent.width
            color: highlighted ? Theme.highlightColor : Theme.primaryColor
            truncationMode: TruncationMode.Fade
            text: title
        }

        Item {
            width: parent.width
            height: artistLabel.height
            Label {
                id: artistLabel
                anchors {
                    left: parent.left
                    right: trackCountLabel.left
                    rightMargin: Theme.paddingMedium
                }
                font.pixelSize: Theme.fontSizeSmall
                color: highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                truncationMode: TruncationMode.Fade
                text: artist
            }

            Label {
                id: trackCountLabel
                anchors.right: parent.right
                font.pixelSize: Theme.fontSizeSmall
                color: highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                text: qsTr("%1 tracks").arg(trackCount)
            }
        }
    }
}
