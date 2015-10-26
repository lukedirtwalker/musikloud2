import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.musikloud2.MusiKloud 2.0

Page {
    id: root

    allowedOrientations: Orientation.All

    property string _currentSearch: ""

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
        sourceComponent: historyList
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
            width: parent ? parent.width : 0

            property alias searchField: searchField
            PageHeader {
                title: qsTr("Search") + (searchField.text === "" ? "" : " ('" + searchField.text + "')")
            }

            SearchField {
                id: searchField

                width: parent.width
                focus: true
                placeholderText: qsTr("Search")
                validator: RegExpValidator {
                    regExp: /^.+/
                }
                EnterKey.onClicked: search()
                EnterKey.enabled: searchField.acceptableInput
                EnterKey.iconSource: "image://theme/icon-m-search"
                onTextChanged: {
                    root._currentSearch = text
                    if (text == "") contentLoader.sourceComponent = historyList
                }
                Component.onCompleted: text = root._currentSearch

                function search() {
                    if (searchField.acceptableInput)
                    {
                        root.search(text, searchTypeModel.data(searchTypeSelector.currentIndex, "value").type,
                                    searchTypeModel.data(searchTypeSelector.currentIndex, "value").order)
                        Settings.addSearch(text)
                    }
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
                            onClicked: {
                                Settings.setDefaultSearchType(Resources.SOUNDCLOUD, searchTypeModel.data(index, "name"))
                            }
                        }
                    }

                    onClosed: {
                        searchField.search()
                    }
                }
                currentIndex: searchTypeModel.match("name", Settings.defaultSearchType(Resources.SOUNDCLOUD))
            }
        }
    }

    Component {
        id: historyList
        SilicaListView {
            id: view

            anchors.fill: parent
            model: SearchHistoryModel {
                id: searchModel
            }
            header: searchHeader

            delegate: ListItem {
                id: listItem

                menu: contextMenu
                contentHeight: Theme.itemSizeSmall
                ListView.onRemove: animateRemoval(listItem)

                onClicked: {
                    var searchField = contentLoader.item.headerItem.searchField
                    searchField.text = display
                    searchField.search()
                }

                Label {
                    text: display
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.horizontalPageMargin
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.horizontalPageMargin
                    truncationMode: TruncationMode.Fade
                    color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                }

                Component {
                    id: contextMenu
                    ContextMenu {
                        MenuItem {
                            text: qsTr("Remove")
                            onClicked: searchModel.removeSearch(view.currentIndex)
                        }

                        MenuItem {
                            text: qsTr("Clear")
                            onClicked: searchModel.clear()
                        }
                    }
                }
            }

            VerticalScrollDecorator { }

            ViewPlaceholder {
                enabled: view.count == 0
                text: qsTr("Search history is empty")
                hintText: qsTr("Search for something")
            }
        }
    }
}
