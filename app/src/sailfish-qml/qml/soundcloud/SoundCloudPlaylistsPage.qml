import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.musikloud2.MusiKloud 2.0
import harbour.musikloud2.QSoundCloud 1.0 as QSoundCloud
import ".."

Page {
    id: root

    allowedOrientations: Orientation.All

    property alias model: playlistModel
    property string title: qsTr("Sets")

    SilicaListView {
        anchors.fill: parent


        header: PageHeader {
            title: root.title
        }

        model: SoundCloudPlaylistModel {
            id: playlistModel

            // TODO:            onStatusChanged: if (status == QSoundCloud.ResourcesRequest.Failed) messageBox.showError(errorString);
        }

        delegate: PlaylistDelegate { }

        VerticalScrollDecorator {}

        ViewPlaceholder {
            enabled: playlistModel.status === QSoundCloud.ResourcesRequest.Ready && model.count == 0
            text: qsTr("No sets found")
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: playlistModel.status === QSoundCloud.ResourcesRequest.Loading
        size: BusyIndicatorSize.Large
    }
}

