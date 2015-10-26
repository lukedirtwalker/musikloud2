import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.musikloud2.MusiKloud 2.0
import harbour.musikloud2.QSoundCloud 1.0 as QSoundCloud
import ".."


Page {
    id: root

    allowedOrientations: Orientation.All

    function load(playlistOrId) {
        playlist.loadPlaylist(playlistOrId)
        tracksView.model.get("/playlists/" + (playlistOrId.id ? playlistOrId.id : playlistOrId))
    }

    SoundCloudPlaylist {
        id: playlist

        onStatusChanged: if (status == QSoundCloud.ResourcesRequest.Failed)
                             infoBanner.showError(errorString);
    }

    SoundCloudTracksView {
        id: tracksView
        anchors.fill: parent

        placeholderText: qsTr("No sets found")
        header: SoundCloudArtistHeader {
            title: playlist.title
            backgroundPicture: playlist.largeThumbnailUrl
            artistPicture: playlist.thumbnailUrl
        }
    }
}
