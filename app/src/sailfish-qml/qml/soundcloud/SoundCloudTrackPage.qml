import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.musikloud2.MusiKloud 2.0

Page {
    id: root
    objectName: "soundCloudTrackPage"

    property alias model: view.model

    allowedOrientations: Orientation.All

    // make things easy and bind model to currently played track so controllers don't need to set model explicitly
    Connections {
        target: player
        onCurrentIndexChanged: {
            view.model = player.currentTrack
        }
    }

    SoundCloudTrackView {
        id: view
    }
}

