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
                infoBanner.showError(errorString);
                break;
            default:
                console.log("Other status: " + status)
                break;
            }
        }
    }

    Loader {
        id: contentLoader
        anchors.fill: parent
        sourceComponent: tracksView
    }

    Component {
        id: pulley
        PullDownMenu {
            parent: tracksView
            MenuItem {
                text: qsTr("Tracks")
                visible: _viewState !== 0
                onClicked: {
                    contentLoader.sourceComponent = tracksView
                    _viewState = 0
                }
            }
            MenuItem {
                text: qsTr("Likes")
                visible:  _viewState !== 1
                onClicked: {
                    contentLoader.sourceComponent = favoritesView
                    _viewState = 1
                }
            }
            MenuItem {
                text: qsTr("Playlists")
                visible: _viewState !== 2
                onClicked: {
                    contentLoader.sourceComponent = setsView
                    _viewState = 2
                }
            }
            MenuItem {
                text: qsTr("Followings")
                visible: _viewState !== 3
                onClicked: {
                    contentLoader.sourceComponent = followingsView
                    _viewState = 3
                }
            }
        }
    }

    Component {
        id: artistHeader
        SoundCloudArtistHeader {
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
    }

    Component {
        id: tracksView
        SoundCloudTracksView {
            id: view
            pullDownMenu: pulley.createObject(view)
            resourceId: artist.id != "" ? "/users/" + artist.id + "/tracks" : ""
            header: artistHeader
        }
    }

    Component {
        id: favoritesView
        SoundCloudTracksView {
            id: view
            pullDownMenu: pulley.createObject(view)
            resourceId: artist.id != "" ? "/users/" + artist.id + "/favorites" : ""
            header: artistHeader
        }
    }

    Component {
        id: setsView
        SoundCloudPlaylistsView {
            id: view
            pullDownMenu: pulley.createObject(view)
            resourceId: artist.id != "" ? "/users/" + artist.id + "/playlists" : ""
            header: artistHeader
        }
    }

    Component {
        id: followingsView
        SoundCloudArtistsView {
            id: view
            pullDownMenu: pulley.createObject(view)
            resourceId: artist.id != "" ? "/users/" + artist.id + "/followings" : ""
            header: artistHeader
        }
    }
}
