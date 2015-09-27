import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    width: parent.width
    height: Theme.itemSizeMedium

    onClicked: {
        // TODO: BEAN - Plugin Tracks currently not supported
        player.setTracksToPlay(ListView.view.model)
        player.setCurrentIndex(index)

        var track = ListView.view.model.get(index)
        app.showSoundCloudTrackPage({"model": track})
    }

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
                    right: durationLabel.left
                    rightMargin: Theme.paddingMedium
                }
                font.pixelSize: Theme.fontSizeSmall
                color: highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                truncationMode: TruncationMode.Fade
                text: artist
            }

            Label {
                id: durationLabel
                anchors.right: parent.right
                font.pixelSize: Theme.fontSizeSmall
                color: highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                text: durationString
            }
        }
    }
}
