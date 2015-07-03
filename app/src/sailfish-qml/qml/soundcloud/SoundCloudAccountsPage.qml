import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.musikloud2.MusiKloud 2.0
import harbour.musikloud2.QSoundCloud 1.0 as QSoundCloud

Page {
    allowedOrientations: Orientation.All

    Loader {
        id: viewLoader

        anchors.fill: parent
        sourceComponent: accountModel.count > 0 ? accountsView : authView
    }

    Component {
        id: accountsView

        SilicaListView {
            id: view

            anchors.fill: parent
            interactive: count > 0
            model: accountModel
            header: PageHeader {
                title: qsTr("Accounts")
            }
            delegate: ListItem {
                id: accountItem
                Label {
                    anchors {
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                        right: parent.right
                        rightMargin: Theme.horizontalPageMargin
                        verticalCenter: parent.verticalCenter
                    }
                    text: username
                    color: accountItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                }

                highlighted: active
                onClicked: accountModel.selectAccount(index)
//                infoBanner.showMessage(accountModel.selectAccount(index)
//                                                  ? qsTr("You have selected account") + " '" + username + "'"
//                                                  : accountModel.errorString)
//                onPressAndHold: {
//                    view.currentIndex = index;
//                    contextMenu.open();
//                }
            }

            ViewPlaceholder {
                text: qsTr("No accounts")
                enabled: accountModel.count == 0
            }

            VerticalScrollDecorator {}
        }

//        ContextMenu {
//            id: contextMenu

//            MenuItem {
//                text: qsTr("Remove")
//                onClicked: infoBanner.showMessage(accountModel.removeAccount(view.currentIndex)
//                                                  ? qsTr("Account removed. Please visit the SoundCloud website to revoke the access token")
//                                                  : accountModel.errorString)
//            }
//        }
    }


    Component {
        id: authView

        SilicaWebView {
            id: webView

            anchors.fill: parent
            onUrlChanged: {
                var s = url.toString();

                if (/code=/i.test(s)) {
                    authRequest.exchangeCodeForAccessToken(s.split("code=")[1].split("#")[0]);
                    authLoader.sourceComponent = undefined;
                }
            }

            Component.onCompleted: url = SoundCloud.authUrl()
        }
    }

    SoundCloudAccountModel {
        id: accountModel
    }

    QSoundCloud.AuthenticationRequest {
        id: authRequest

        clientId: SoundCloud.clientId
        clientSecret: SoundCloud.clientSecret
        redirectUri: SoundCloud.redirectUri
        scopes: SoundCloud.scopes
        onFinished: {
            if (status == QSoundCloud.AuthenticationRequest.Ready) {
                if (result.access_token) {
                    userRequest.accessToken = result.access_token;
                    userRequest.refreshToken = (result.refresh_token ? result.refresh_token : "");
                    userRequest.get("/me");
                    return;
                }
            }

            // TODO messageBox.showError
            console.error(SoundCloud.getErrorString(result));
        }
    }

    QSoundCloud.ResourcesRequest {
        id: userRequest

        clientId: SoundCloud.clientId
        clientSecret: SoundCloud.clientSecret
        onFinished: {
            if (status == QSoundCloud.ResourcesRequest.Ready) {
                if (accountModel.addAccount(result.id, result.username, accessToken, refreshToken,
                                            SoundCloud.scopes.join(" "))) {
                    // TODO statusBar.showMessage
                    console.log(qsTr("You are signed in to account") + " '" + result.username + "'");
                }
                else {
                    // TODO messageBox.showError
                    console.error(accountModel.errorString);
                }

                return;
            }
            // TODO messageBox.showError
            console.error(SoundCloud.getErrorString(result));
        }
    }
}
