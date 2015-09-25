import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.musikloud2.MusiKloud 2.0
import harbour.musikloud2.QSoundCloud 1.0 as QSoundCloud
import ".."

Page {
    id: root

    allowedOrientations: Orientation.All

    property alias model: playlistsView.model
    property string title: qsTr("Sets")

    SoundCloudPlaylistsView {
        id: playlistsView
        anchors.fill: parent

        placeholderText: qsTr("No sets found")
        header: PageHeader {
            title: root.title
        }
    }
}

