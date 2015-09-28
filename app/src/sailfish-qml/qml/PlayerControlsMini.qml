import QtQuick 2.0
import Sailfish.Silica 1.0

DockedPanel {
    id: controlsFlickable

    width: parent.width
    height: Math.max(parent.height * 0.15, 150) // The magic number (<= 150 / 940) seems good

    contentHeight: height
    flickableDirection: Flickable.VerticalFlick

    opacity: Qt.inputMethod.visible || !open ? 0.0 : 1.0
    Behavior on opacity { FadeAnimation {duration: 300}}

    onOpenChanged: {
        if(!open && player.playing)
            player.pause()
    }

    // overwrite default behavior to prevent weird behaviour when rotating.
    Behavior on y { }

    Item {
        anchors.fill: parent

//        MouseArea {
//            id: opener
//            anchors.fill: parent
//            onClicked: appWindow.showFullControls = !appWindow.showFullControls
//        }

        Row {
            id: quickControlsItem
            width: parent.width
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingMedium
            height: parent.height
            spacing: Theme.paddingLarge

            Image {
                id: thumbnail
                width: controlsFlickable.height
                height: width
                source: player.currentTrack ? player.currentTrack.thumbnailUrl : ""
            MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (!app.isSoundCloudTrackPageVisible() && player.currentTrack) {
                           app.showSoundCloudTrackPage({"model": player.currentTrack})
                        }
                    }
                }
            }

            Column {
                id: trackInfo
                width: parent.width - thumbnail.width - Theme.paddingLarge
                height: parent.height
                spacing: (height - trackNameLabel.paintedHeight - artistsLabel.paintedHeight - controls.height) / 3
                Label {
                    id: trackNameLabel
                    width: parent.width
                    truncationMode: TruncationMode.Fade
                    text: player.currentTrack ? player.currentTrack.title : ""
                }
                Label {
                    id: artistsLabel
                    width: parent.width
                    font.pixelSize: Theme.fontSizeSmall
                    truncationMode: TruncationMode.Fade
                    color: Theme.secondaryColor
                    text: player.currentTrack ? player.currentTrack.artist : ""
                }

                Row {
                    id: controls
                    width: parent.width
                    property real itemWidth: width / 3

//                    IconButton {
//                        width: controls.itemWidth
//                        anchors.verticalCenter: parent.verticalCenter
//                        icon.source: spotifySession.currentTrack ? (spotifySession.currentTrack.isStarred ? ("image://theme/icon-m-favorite-selected")
//                                                                                                          : ("image://theme/icon-m-favorite"))
//                                                                 : ""
//                        enabled: !spotifySession.offlineMode
//                        onClicked: spotifySession.currentTrack.isStarred = !spotifySession.currentTrack.isStarred
//                    }

                    IconButton {
                        width: controls.itemWidth
                        anchors.verticalCenter: parent.verticalCenter
                        icon.source: "image://theme/icon-m-previous"
                        onClicked: player.previous()
                    }

                    IconButton {
                        width: controls.itemWidth
                        anchors.verticalCenter: parent.verticalCenter
                        icon.source: player.playing ? "image://theme/icon-m-pause"
                                                              : "image://theme/icon-m-play"
                        onClicked: player.playing ? player.pause() : player.play()
                    }

                    IconButton {
                        width: controls.itemWidth
                        anchors.verticalCenter: parent.verticalCenter
                        icon.source: "image://theme/icon-m-next"
                        onClicked: player.next()
                    }
                }
            }
        }
    }

//    PushUpMenu {
//        Row {
//            width: parent.width

//            Switch {
//                id: shuffleSwitch
//                width: parent.width * 0.5
//                anchors.bottom: parent.bottom
//                icon.source: "image://theme/icon-m-shuffle"
//                onCheckedChanged: spotifySession.shuffle = checked
//                Component.onCompleted: checked = spotifySession.shuffle;
//            }

//            Switch {
//                id: repeatSwitch
//                width: parent.width * 0.5
//                anchors.bottom: parent.bottom
//                icon.source: "image://theme/icon-m-repeat"
//                onCheckedChanged: spotifySession.repeat = checked
//                Component.onCompleted: checked = spotifySession.repeat;
//            }
//        }
//    }
}
