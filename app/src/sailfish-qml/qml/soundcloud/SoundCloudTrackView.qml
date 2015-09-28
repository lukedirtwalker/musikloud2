import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.musikloud2.MusiKloud 2.0

import QtGraphicalEffects 1.0

SilicaFlickable {
    id: page
    anchors.fill: parent

    property Track model

    PullDownMenu {
        MenuItem {
            text: visible && !model.favourited ? qsTr("Like") : qsTr("Unlike")
            visible: model.favourited !== undefined
            onClicked: {
                if (model.favourited) model.unfavourite()
                else model.favourite()
            }
        }
        MenuItem {
            text: qsTr("Add to Playlist")
            onClicked: {
                // TODO
            }
        }
    }


    Flickable {
        id: bgFlick
        width: page.width
        height: page.height
        contentWidth: image.width
        contentHeight: image.height
        interactive: false
        boundsBehavior: Flickable.StopAtBounds
        clip: true

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
            property int _scaling: Math.ceil(page.height > page.width ? page.height / sourceSize.height : page.width / sourceSize.width)
            height: sourceSize.height * _scaling
            width: sourceSize.width * _scaling
            source: model.largeThumbnailUrl
            smooth: true
            visible: false
            onStatusChanged: {
                // Workaround to refresh the blur
                // FIXME remove once it works without
                if (status === Image.Ready) {
                    blur.source = null
                    blur.source = image
                }
            }
        }

        FastBlur {
            id: blur
            anchors.fill: image
            source: image
            radius: 50
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
            visible: model.favouriteCount !== undefined

            Label {
                anchors.centerIn: parent
                id: likes
                font.pixelSize: Theme.fontSizeSmall
                text: parent.visible ? "<3: " + model.favouriteCount : ""
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
            id: trackSlider
            anchors.centerIn: parent
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
                    if (!trackSlider.pressed)
                        trackSlider.value = player.position / 1000
                }
            }
        }
    }
}
