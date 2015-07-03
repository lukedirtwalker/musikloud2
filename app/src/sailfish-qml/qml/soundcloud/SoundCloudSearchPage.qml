import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.musikloud2.MusiKloud 2.0

Page {
    id: root

    allowedOrientations: Orientation.All

    function search(query, type, order) {
        var url;
        var path;
        var filters = {};
        filters["q"] = query;
        filters["limit"] = MAX_RESULTS;

        if (type == Resources.PLAYLIST) {
            url = Qt.resolvedUrl("SoundCloudPlaylistsPage.qml");
            path = "/playlists";
        }
        else if (type == Resources.ARTIST) {
            url = Qt.resolvedUrl("SoundCloudArtistsPage.qml");
            path = "/users";
        }
        else {
            url = Qt.resolvedUrl("SoundCloudTracksPage.qml");
            path = "/tracks";
        }
        pageStack.push(url, {"title": qsTr("Search") + " ('" + query + "')"})
                       .model.get(path, filters);
        return true;
    }

    Column {
        width: parent.width
        PageHeader {
            title: qsTr("Search")
        }

        SearchField {
            id: searchField

            width: parent.width
            placeholderText: qsTr("Search")
            validator: RegExpValidator {
                regExp: /^.+/
            }
            EnterKey.onClicked: {
                root.search(text, searchTypeModel.data(searchTypeSelector.currentIndex, "value").type,
                            searchTypeModel.data(searchTypeSelector.currentIndex, "value").order);
                text = "";
            }
        }

        ComboBox {
            id: searchTypeSelector
            width: parent.width

            label: qsTr("Search category")

            menu: ContextMenu {
                Repeater {
                    width: parent.width
                    model: SoundCloudSearchTypeModel {
                        id: searchTypeModel
                    }
                    delegate: MenuItem {
                        text: model.name
                        onClicked: Settings.setDefaultSearchType(Resources.SOUNDCLOUD, searchTypeModel.data(index, "name"))
                    }
                }
            }
            currentIndex: searchTypeModel.match("name", Settings.defaultSearchType(Resources.SOUNDCLOUD))
        }
    }
}
