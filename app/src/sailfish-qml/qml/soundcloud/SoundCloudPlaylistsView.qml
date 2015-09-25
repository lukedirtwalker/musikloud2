import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.musikloud2.MusiKloud 2.0
import harbour.musikloud2.QSoundCloud 1.0 as QSoundCloud
import ".."

SilicaListView {
    id: contentList
    anchors.fill: parent

    property string resourceId: ""
    property alias placeholderText: placeholder.text

    model: SoundCloudPlaylistModel {
        onStatusChanged: if (status === QSoundCloud.ResourcesRequest.Failed) console.log(errorString)
                    //infoBanner.showMessage(errorString);
    }

    delegate: PlaylistDelegate {}

    onResourceIdChanged: {
        console.log("resourceIdChanged to" + resourceId)
        if (resourceId !== "" && resourceId)
            model.get(resourceId)
    }

    VerticalScrollDecorator {}

    ViewPlaceholder {
        id: placeholder
        enabled: model.status === QSoundCloud.ResourcesRequest.Ready && model.count === 0
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: model.status === QSoundCloud.ResourcesRequest.Loading
        size: BusyIndicatorSize.Large
    }
}
