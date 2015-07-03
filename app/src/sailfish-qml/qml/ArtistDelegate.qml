import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    height: width

    Image {
        id: thumbnail
        height: parent.height
        width: height
        source: largeThumbnailUrl
        asynchronous: true
    }

    Label {
        anchors.left: parent.left
        anchors.leftMargin: Theme.paddingLarge
        anchors.right: parent.right
        anchors.rightMargin: Theme.paddingLarge
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingLarge
        width: parent.width - 2 * Theme.paddingLarge
        color: highlighted ? Theme.highlightColor : Theme.primaryColor
        truncationMode: TruncationMode.Fade
        text: name
    }
}
