import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.musikloud2.MusiKloud 2.0
import org.nemomobile.notifications 1.0
import "soundcloud"

ApplicationWindow
{
    id: app
    initialPage: Component { SoundCloudPage{} }

    bottomMargin: miniControls.visibleSize

    AudioPlayer {
        id: player

        onStatusChanged: if (status == AudioPlayer.Failed) infoBanner.showError(errorString);
    }

    PlayerControlsMini {
        id: miniControls
        open: player.queueCount > 0
    }
    Notification {
        id: infoBanner
        category: "harbour.musikloud2.info"

        function showError(message) {
            infoBanner.previewBody = "Musikloud2";
            infoBanner.previewSummary = message;
            infoBanner.publish();
        }

        function showMessage(message) {
            showError(message);
        }
    }

    function showSoundCloudTrackPage(args) {
        pageStack.push(Qt.resolvedUrl("soundcloud/SoundCloudTrackPage.qml"), args);
    }

    function isSoundCloudTrackPageVisible() {
        return pageStack.currentPage.objectName == 'soundCloudTrackPage'
    }
}
