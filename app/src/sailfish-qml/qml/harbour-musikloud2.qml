import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.musikloud2.MusiKloud 2.0
import org.nemomobile.notifications 1.0
import harbour.musikloud2.QSoundCloud 1.0 as QSoundCloud
import "soundcloud"

ApplicationWindow
{
    id: app
    initialPage: Component { SoundCloudPage{} }

    bottomMargin: miniControls.visibleSize

    AudioPlayer {
        id: player

        property SoundCloudTrackModel searchResults

        onStatusChanged: {
            if (status == AudioPlayer.Failed) infoBanner.showError(errorString);
        }

        onCurrentIndexChanged: {
            var model = player.searchResults;
            if (model && (player.currentIndex + 1) >= model.count && model.canFetchMore) {
                model.fetchMore()
            }
        }

        function setTracksToPlay(trackModel) {
            if (trackModel !== searchResults) {
                player.clearQueue()
                searchResults = trackModel
                _addTracksToPlay()
            }
        }

        function _addTracksToPlay(startIndex) {
            var tracks = [];
            for(var i = startIndex || 0; i < searchResults.count; ++i) {
                 tracks[i] = searchResults.get(i)
            }
            player.addTracks(tracks)
        }
    }

    Connections {
        target: player.searchResults

        onStatusChanged: {
            if (player.searchResults.status === QSoundCloud.ResourcesRequest.Ready){
                player._addTracksToPlay(player.currentIndex + 1)
            }
        }
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
