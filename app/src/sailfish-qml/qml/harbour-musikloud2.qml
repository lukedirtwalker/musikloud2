import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.musikloud2.MusiKloud 2.0
import "soundcloud"

ApplicationWindow
{
    initialPage: Component { SoundCloudPage{} }

    bottomMargin: miniControls.visibleSize

    AudioPlayer {
        id: player

//        onStatusChanged: if (status == AudioPlayer.Failed) messageBox.showError(errorString);
    }

    PlayerControlsMini {
        id: miniControls
        open: player.queueCount > 0
    }
}
