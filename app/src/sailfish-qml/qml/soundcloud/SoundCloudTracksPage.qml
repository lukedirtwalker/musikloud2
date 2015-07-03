/*
 * Copyright (C) 2015 Stuart Howarth <showarth@marxoft.co.uk>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.musikloud2.MusiKloud 2.0
import harbour.musikloud2.QSoundCloud 1.0 as QSoundCloud
import ".."

Page {
    id: root

    allowedOrientations: Orientation.All

    property alias model: trackModel
    property string title: qsTr("Tracks")

    SilicaListView {
        anchors.fill: parent


        header: PageHeader {
            title: root.title
        }

        model: SoundCloudTrackModel {
            id: trackModel

            // TODO:            onStatusChanged: if (status == QSoundCloud.ResourcesRequest.Failed) messageBox.showError(errorString);
        }

        delegate: TrackDelegate { }

        VerticalScrollDecorator {}

        ViewPlaceholder {
            enabled: trackModel.status === QSoundCloud.ResourcesRequest.Ready && model.count == 0
            text: qsTr("No tracks found")
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: trackModel.status === QSoundCloud.ResourcesRequest.Loading
        size: BusyIndicatorSize.Large
    }
}
