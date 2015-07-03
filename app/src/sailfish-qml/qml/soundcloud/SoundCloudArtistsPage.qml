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

    property alias model: artistModel
    property string title: qsTr("Users")

    SilicaGridView {
        id: artistGrid
        anchors.fill: parent

        property int columns: Math.floor(width / (1.5 * Theme.itemSizeHuge))

        cellWidth: Math.floor(width / columns)
        cellHeight: cellWidth

        header: PageHeader {
            title: root.title
        }

        model: SoundCloudArtistModel {
            id: artistModel

            // TODO:            onStatusChanged: if (status == QSoundCloud.ResourcesRequest.Failed) messageBox.showError(errorString);
        }

        delegate: ArtistDelegate {
            width: GridView.view.cellWidth
            onClicked: {
                pageStack.push(Qt.resolvedUrl("SoundCloudArtistPage.qml")).loadArtist(artistModel.get(index))
            }
        }

        VerticalScrollDecorator {}

        ViewPlaceholder {
            enabled: artistModel.status === QSoundCloud.ResourcesRequest.Ready && model.count == 0
            text: qsTr("No users found")
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: artistModel.status === QSoundCloud.ResourcesRequest.Loading
        size: BusyIndicatorSize.Large
    }
}
