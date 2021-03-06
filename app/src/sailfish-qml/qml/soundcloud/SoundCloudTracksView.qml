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

    model: SoundCloudTrackModel {
        id: tracksModel

        onStatusChanged: if (status === QSoundCloud.ResourcesRequest.Failed)
                             infoBanner.showError(errorString);
    }

    delegate: TrackDelegate {}

    onResourceIdChanged: {
        console.log("resourceIdChanged to" + resourceId)
        if (resourceId !== "" && resourceId)
            model.get(resourceId)
    }

    VerticalScrollDecorator {}

    ViewPlaceholder {
        id: placeholder
        enabled: model.status === QSoundCloud.ResourcesRequest.Ready && model.count === 0
        text: qsTr("No tracks found")
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: model.status === QSoundCloud.ResourcesRequest.Loading
        size: BusyIndicatorSize.Large
    }
}
