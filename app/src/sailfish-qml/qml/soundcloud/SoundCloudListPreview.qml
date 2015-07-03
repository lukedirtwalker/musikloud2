import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: listPreview

    width: parent.width

    property int previewCount: 3
    property alias delegate: listView.delegate
    property alias model: listView.model
    property string moreText
    property alias title: sectionHeader.text
    signal moreClicked()

    SectionHeader {
        id: sectionHeader
    }

    Repeater {
        id: listView
        width: parent.width
        height: delegate ? delegate.height * 3 : 0
    }

    BackgroundItem {
        height: parent.delegate ? parent.delegate.height : 0
        width: parent.width
        visible: listView ? listView.model.count >= listPreview.previewCount : false
        Label {
            anchors.left: parent.left
            anchors.leftMargin: Theme.horizontalPageMargin
            anchors.right: parent.right
            anchors.rightMargin: Theme.horizontalPageMargin
            anchors.verticalCenter: parent.verticalCenter
            truncationMode: TruncationMode.Fade
            text: listPreview.moreText
        }
        onClicked: listPreview.moreClicked()
    }
}
