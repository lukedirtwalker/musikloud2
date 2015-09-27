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

        if (type === Resources.PLAYLIST) {
            path = "/playlists";
            contentLoader.sourceComponent = setsView
        }
        else if (type === Resources.ARTIST) {
            path = "/users";
            contentLoader.sourceComponent = usersView
        }
        else {
            path = "/tracks";
            contentLoader.sourceComponent = tracksView
        }
        contentLoader.item.model.get(path, filters);
        return true;
    }

    Loader {
        id: contentLoader
        anchors.fill: parent
        sourceComponent: setsView
    }

    Component {
        id: tracksView
        SoundCloudTracksView {
            id: view
            header: searchHeader
        }
    }

    Component {
        id: setsView
        SoundCloudPlaylistsView {
            id: view
            header: searchHeader
        }
    }

    Component {
        id: usersView
        SoundCloudArtistsView {
            id: view
            header: searchHeader
        }
    }

    Component {
        id: searchHeader

        Column {
            width: parent.width
            PageHeader {
                title: qsTr("Search") + searchField.text === "" ? "" : " ('" + searchField.text + "')"
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
}
