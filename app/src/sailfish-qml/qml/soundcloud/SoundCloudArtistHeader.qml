import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: artistHeader
    width: parent.width
    height: Theme.itemSizeLarge * 3

    property alias title: header.title
    property alias trackCount: trackCountText.text
    property alias setsCount: setsCountCountText.text
    property alias followersCount: followersCountText.text
    property alias artistPicture: coverImage.source
    property alias backgroundPicture: backgroundImage.source
    property bool favorite: false
    property bool busy: false

    signal favorited

    Rectangle {
        width: parent.width
        height: parent.height
        color: Theme.highlightBackgroundColor
        opacity: 0.1
        visible: !backgroundImage.visible
    }

    Image {
        id: backgroundImage
        width: parent.width
        height: parent.height
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
        opacity: status == Image.Ready ? 0.4 : 0.0
        source: coverImage.source
    }

    PageHeader {
        id: header
    }

    Row {
        spacing: Theme.paddingMedium
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.leftMargin: Theme.horizontalPageMargin
        height: parent.height - header.height

        Image {
            id: coverImage
            height: parent.height - Theme.paddingLarge - Theme.paddingMedium
            width: height
            asynchronous: true
            fillMode: Image.PreserveAspectCrop
            clip: true
        }

        Column {
            id: desc
            width: parent.width - coverImage.width - Theme.paddingMedium

            Label {
                id: trackCountText
                width: parent.width
                font.pixelSize: Theme.fontSizeSmall
                truncationMode: TruncationMode.Fade
                visible: text.length > 0
                color: Theme.highlightColor
            }
            Label {
                id: setsCountCountText
                width: parent.width
                font.pixelSize: Theme.fontSizeSmall
                truncationMode: TruncationMode.Fade
                visible: text.length > 0
                color: Theme.highlightColor
            }
            Label {
                id: followersCountText
                width: parent.width
                font.pixelSize: Theme.fontSizeSmall
                truncationMode: TruncationMode.Fade
                visible: text.length > 0
                color: Theme.highlightColor
            }
        }
    }
    IconButton {
        id: favorite
        anchors {
            right: parent.right
            rightMargin: Theme.paddingLarge
            bottom: parent.bottom
            bottomMargin: Theme.paddingLarge
        }
        icon.source: artistHeader.favorite ? "image://theme/icon-m-favorite-selected" : "image://theme/icon-m-favorite"
        onClicked: favorited()
    }
}
