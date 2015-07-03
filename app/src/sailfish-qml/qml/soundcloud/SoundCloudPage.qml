/*
 * Copyright (C) 2015 Lukas Vogel <lukedirtwalker@gmail.com>
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

Page {
    id: root

    allowedOrientations: Orientation.All

    SilicaListView {
        anchors.fill: parent
        model: SoundCloudNavModel {
            id: navModel
        }
        header: PageHeader {
            title: "Musikloud2"
        }
        delegate: BackgroundItem {
            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                text: display
                color: highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: {
                switch (index) {
                case 0:
                    pageStack.push(Qt.resolvedUrl("SoundCloudAccountsPage.qml"));
                    break;
                case 1:
                    pageStack.push(Qt.resolvedUrl("SoundCloudSearchPage.qml"));
                    break;
                case 2:
                    pageStack.push(Qt.resolvedUrl("SoundCloudTracksPage.qml"),
                                   {"title": qsTr("Tracks")}).model.get("/me/tracks", {limit: MAX_RESULTS});
                    break;
                case 3:
                    pageStack.push(Qt.resolvedUrl("SoundCloudTracksPage.qml"),
                                   {"title": qsTr("Favourites")}).model.get("/me/favorites", {limit: MAX_RESULTS});
                    break;
                case 4:
                    pageStack.push(Qt.resolvedUrl("SoundCloudPlaylistsPage.qml"),
                                   {"title": qsTr("Sets")}).model.get("/me/playlists", {limit: MAX_RESULTS});
                    break;
                case 5:
                    pageStack.push(Qt.resolvedUrl("SoundCloudArtistsPage.qml"),
                                   {"title": qsTr("Followings")}).model.get("/me/followings", {limit: MAX_RESULTS});
                    break;
                default:
                    break;
                }
            }
        }
    }
}
