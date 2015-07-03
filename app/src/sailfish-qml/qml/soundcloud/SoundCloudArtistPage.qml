import QtQuick 2.0

import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.musikloud2.MusiKloud 2.0
import harbour.musikloud2.QSoundCloud 1.0 as QSoundCloud
import ".."

Page {
    id: root

    allowedOrientations: Orientation.All

    function loadArtist(artistOrId) {
        artist.loadArtist(artistOrId);

        if ((artist.id) && (!artist.followed) && (SoundCloud.userId)) {
            artist.checkIfFollowed();
        }
    }

    property int _viewState: 0

    SoundCloudArtist {
        id: artist

        onStatusChanged: {
            switch (status) {
            case QSoundCloud.ResourcesRequest.Ready:
                if ((!followed) && (SoundCloud.userId)) {
                    checkIfFollowed();
                }
                break;
            case QSoundCloud.ResourcesRequest.Failed:
                console.log("Artist fetch failed")
                //                TODO messageBox.showError(errorString);
                break;
            default:
                console.log("Other status: " + status)
                break;
            }
        }

        onIdChanged: {
            console.log("Id changed, status:" + status)
            console.log("get : " + "/users/" + artist.id + "/tracks")
            tracksModel.get("/users/" + artist.id + "/tracks")
            favouriteModel.get("/users/" + artist.id + "/favorites")
            playlistModel.get("/users/" + artist.id + "/playlists")
            artistModel.get("/users/" + artist.id + "/followings")
        }
    }

    SilicaListView {
        id: contentList
        anchors.fill: parent

        header: SoundCloudArtistHeader {
            title: artist.name ? artist.name : qsTr("User")
            trackCount: qsTr("%1 - Tracks").arg(artist.trackCount)
            setsCount: qsTr("%1 - Sets").arg(artist.playlistCount)
            followersCount: qsTr("%1 - Followers").arg(artist.followersCount)
            artistPicture: artist.thumbnailUrl
            backgroundPicture: artist.largeThumbnailUrl
            favorite: artist.followed
            onFavorited: {
                if (artist.followed) artist.unfollow()
                else artist.follow()
            }
        }

        model: tracksModel
        delegate: tracksDelegate

        VerticalScrollDecorator {}

        PullDownMenu {
            MenuItem {
                text: qsTr("Tracks")
                visible: _viewState !== 0
                onClicked: {
                    contentList.model = tracksModel
                    contentList.delegate = tracksDelegate
                    _viewState = 0
                }
            }
            MenuItem {
                text: qsTr("Likes")
                visible:  _viewState !== 1
                onClicked: {
                    contentList.model = favouriteModel
                    contentList.delegate = tracksDelegate
                    _viewState = 1
                }
            }
            MenuItem {
                text: qsTr("Playlists")
                visible: _viewState !== 2
                onClicked: {
                    contentList.model = playlistModel
                    contentList.delegate = playlistDelegate
                    _viewState = 2
                }
            }
            MenuItem {
                text: qsTr("Followings")
                visible: _viewState !== 3
                onClicked: {
                    contentList.model = artistModel
                    contentList.delegate = artistDelegate
                    _viewState = 3
                }
            }
        }

        Component {
            id: tracksDelegate
            TrackDelegate { }
        }

        Component {
            id: playlistDelegate
            PlaylistDelegate { }
        }

        Component {
            id: artistDelegate
            ArtistDelegate {}
        }
    }

    SoundCloudTrackModel {
        id: tracksModel
    }

    SoundCloudTrackModel {
        id: favouriteModel
    }

    SoundCloudPlaylistModel {
        id: playlistModel
    }

    SoundCloudArtistModel {
        id: artistModel
    }
}
