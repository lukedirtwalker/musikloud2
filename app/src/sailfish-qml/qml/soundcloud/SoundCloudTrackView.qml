import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.musikloud2.MusiKloud 2.0


SilicaFlickable {
    id: page
    anchors.fill: parent

    property Track model

    property SoundCloudTrack soundCloudModel

    onModelChanged: {
        try {
            // If the current track is requested through the player instance, a Track instance which has
            // Track.service == Resources.SOUNDCLOUD but is not a subclass of SoundCloudTrack is returned
            // Thus SoundCloudTrack attributes are not available
            soundCloudModel = model
        } catch (e) {
            console.log("Model has service = SOUNDClOUD but not appropriate subclass for Soundcloud attributes. " +
                        "Ignoring soundcloud attributes")
        }
    }

    function isSoundcloudModel() {
        return soundCloudModel !== 'undefined' && soundCloudModel != null
    }

    PullDownMenu {
        MenuItem {
            text: qsTr("Like")
            visible: isSoundcloudModel() && !soundCloudModel.favourited
            onClicked: {
                soundCloudModel.favourite()
            }
        }
        MenuItem {
            text: qsTr("Unlike")
            visible: isSoundcloudModel() && soundCloudModel.favourited
            onClicked: {
                soundCloudModel.unfavourite()
            }
        }
        MenuItem {
            text: qsTr("Add to Playlist")
            onClicked: {
                // TODO
            }
        }
    }

    BackgroundItem {

        Flickable {
            id: bgFlick
            width: page.width
            height: page.height
            contentWidth: image.width
            contentHeight: image.height
            interactive: false
            boundsBehavior: Flickable.StopAtBounds

            Connections {
                target: trackSlider
                onValueChanged: {
                    // in case of background image is smaller than page width, image is showing without scroll
                    var maxImgWidth = image.width > page.width ? image.width : page.width
                    bgFlick.contentX = (maxImgWidth - page.width) / (model.duration / 1000 ) * trackSlider.value
                }
            }

            Image {
                id: image
                height: page.height
                width: sourceSize.width * height / sourceSize.height
                source: model.largeThumbnailUrl
            }
        }
    }


    Column {
        anchors {
            left: parent.left
            leftMargin: Theme.horizontalPageMargin
            top: parent.top
            topMargin: Theme.horizontalPageMargin
            right: parent.right
            rightMargin: Theme.horizontalPageMargin
        }

        spacing: Theme.paddingLarge * 1.25

        Rectangle {
            width: author.width + Theme.paddingLarge
            height: author.height
            color: "black"

            Label {
                anchors.centerIn: parent
                id: author
                text: model.artist
                truncationMode: TruncationMode.Fade
            }
        }

        Rectangle {
            width: trackTitle.width  + Theme.paddingLarge
            height: trackTitle.height
            color: "black"

            Label {
                anchors.centerIn: parent
                id: trackTitle
                font.pixelSize: Theme.fontSizeLarge
                text: model.title
                truncationMode: TruncationMode.Fade
            }

        }

        Rectangle {
            width: genre.width  + Theme.paddingLarge
            height: genre.height
            color: "black"
            visible: model.genre && model.genre != ""

            Label {
                anchors.centerIn: parent
                id: genre
                font.pixelSize: Theme.fontSizeSmall
                text: model.genre
                truncationMode: TruncationMode.Fade
            }
        }

        Rectangle {
            width: likes.width  + Theme.paddingLarge
            height: likes.height
            color: "black"
            visible: isSoundcloudModel()

            Label {
                anchors.centerIn: parent
                id: likes
                visible: isSoundcloudModel()
                font.pixelSize: Theme.fontSizeSmall
                text: "<3: " + soundCloudModel.favouriteCount
                truncationMode: TruncationMode.Fade
            }
        }
    }

    Rectangle {
        id: waveContainer

        anchors {
            bottom: parent.bottom
            bottomMargin: page.height / 9 // magic number
            leftMargin: Theme.horizontalPageMargin
            left: parent.left
            rightMargin: Theme.horizontalPageMargin
            right: parent.right
        }

        height: trackSlider.height
        color: "black"

        Slider {
            anchors.centerIn: parent
            id: trackSlider
            minimumValue: 0
            stepSize: 1
            maximumValue: model.duration / 1000
            width: parent.width
            valueText: value
            handleVisible: true
            onReleased: {
                player.setPosition(value * 1000)
            }
            onValueChanged: {
                trackSlider.valueText = Utils.formatMSecs(trackSlider.value * 1000)
            }

            Connections {
                target: player
                onPositionChanged: {
                    trackSlider.value = player.position / 1000
                }
            }
        }
    }
}
