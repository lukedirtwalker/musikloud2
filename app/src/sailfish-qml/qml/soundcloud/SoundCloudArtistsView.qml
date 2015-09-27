import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.musikloud2.MusiKloud 2.0
import harbour.musikloud2.QSoundCloud 1.0 as QSoundCloud
import ".."

SilicaGridView {
    id: artistGrid
    anchors.fill: parent

    property string resourceId: ""
    property alias placeholderText: placeholder.text
    property int columns: Math.floor(width / (1.5 * Theme.itemSizeHuge))

    cellWidth: Math.floor(width / columns)
    cellHeight: cellWidth

    model: SoundCloudArtistModel {
        id: artistModel

        onStatusChanged: if (status === QSoundCloud.ResourcesRequest.Failed)
                             infoBanner.showError(errorString);
    }

    delegate: ArtistDelegate {
        width: GridView.view.cellWidth
        onClicked: {
            pageStack.push(Qt.resolvedUrl("SoundCloudArtistPage.qml")).loadArtist(artistModel.get(index))
        }
    }

    onResourceIdChanged: {
        console.log("resourceIdChanged to" + resourceId)
        if (resourceId !== "" && resourceId)
            model.get(resourceId)
    }

    VerticalScrollDecorator {}

    ViewPlaceholder {
        id: placeholder
        enabled: artistModel.status === QSoundCloud.ResourcesRequest.Ready && model.count === 0
        text: qsTr("No users found")
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: model.status === QSoundCloud.ResourcesRequest.Loading
        size: BusyIndicatorSize.Large
    }
}
