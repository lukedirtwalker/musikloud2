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

#include "audioplayer.h"
#include "categorymodel.h"
#include "categorynamemodel.h"
#include "clipboard.h"
#include "concurrenttransfersmodel.h"
#include "database.h"
//#include "dbusservice.h"
#include "definitions.h"
#include "networkproxytypemodel.h"
#include "pluginartistmodel.h"
#include "plugincategorymodel.h"
#include "plugincommentmodel.h"
#include "pluginnavmodel.h"
#include "pluginplaylistmodel.h"
#include "pluginsearchtypemodel.h"
#include "pluginsettingsmodel.h"
#include "pluginstreammodel.h"
#include "plugintrackmodel.h"
#include "resources.h"
#include "resourcesplugins.h"
#include "resourcesrequest.h"
#include "searchhistorymodel.h"
#include "servicemodel.h"
#include "settings.h"
#include "soundcloud.h"
#include "soundcloudaccountmodel.h"
#include "soundcloudartistmodel.h"
#include "soundcloudcommentmodel.h"
#include "soundcloudconnectionmodel.h"
#include "soundcloudnavmodel.h"
#include "soundcloudplaylistmodel.h"
#include "soundcloudsearchtypemodel.h"
#include "soundcloudstreammodel.h"
#include "soundcloudtrackmodel.h"
#include "transfermodel.h"
#include "transfers.h"
#include "utils.h"
#include <QtCore/QCoreApplication>

#include <QtCore/QDebug>
#include <QtCore/QSettings>
#include <QtCore/QStandardPaths>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlEngine>
#include <QtQml/qqml.h> // For qmlRegisterType
#include <QtQuick/QQuickView>
#include <QGuiApplication>
#include <sailfishapp.h>

#include <qsoundcloud/authenticationrequest.h>
#include <qsoundcloud/resourcesmodel.h>
#include <qsoundcloud/resourcesrequest.h>
#include <qsoundcloud/streamsmodel.h>

inline void registerTypes() {    
    qmlRegisterType<AudioPlayer>("harbour.musikloud2.MusiKloud", 2, 0, "AudioPlayer");
    qmlRegisterType<CategoryModel>("harbour.musikloud2.MusiKloud", 2, 0, "CategoryModel");
    qmlRegisterType<CategoryNameModel>("harbour.musikloud2.MusiKloud", 2, 0, "CategoryNameModel");
    qmlRegisterType<ConcurrentTransfersModel>("harbour.musikloud2.MusiKloud", 2, 0, "ConcurrentTransfersModel");
    qmlRegisterType<MKTrack>("harbour.musikloud2.MusiKloud", 2, 0, "Track");
    qmlRegisterType<NetworkProxyTypeModel>("harbour.musikloud2.MusiKloud", 2, 0, "NetworkProxyTypeModel");
    qmlRegisterType<PluginArtist>("harbour.musikloud2.MusiKloud", 2, 0, "PluginArtist");
    qmlRegisterType<PluginArtistModel>("harbour.musikloud2.MusiKloud", 2, 0, "PluginArtistModel");
    qmlRegisterType<PluginCategoryModel>("harbour.musikloud2.MusiKloud", 2, 0, "PluginCategoryModel");
    qmlRegisterType<PluginComment>("harbour.musikloud2.MusiKloud", 2, 0, "PluginComment");
    qmlRegisterType<PluginCommentModel>("harbour.musikloud2.MusiKloud", 2, 0, "PluginCommentModel");
    qmlRegisterType<PluginNavModel>("harbour.musikloud2.MusiKloud", 2, 0, "PluginNavModel");
    qmlRegisterType<PluginPlaylist>("harbour.musikloud2.MusiKloud", 2, 0, "PluginPlaylist");
    qmlRegisterType<PluginPlaylistModel>("harbour.musikloud2.MusiKloud", 2, 0, "PluginPlaylistModel");
    qmlRegisterType<PluginSearchTypeModel>("harbour.musikloud2.MusiKloud", 2, 0, "PluginSearchTypeModel");
    qmlRegisterType<PluginSettingsModel>("harbour.musikloud2.MusiKloud", 2, 0, "PluginSettingsModel");
    qmlRegisterType<PluginStreamModel>("harbour.musikloud2.MusiKloud", 2, 0, "PluginStreamModel");
    qmlRegisterType<PluginTrack>("harbour.musikloud2.MusiKloud", 2, 0, "PluginTrack");
    qmlRegisterType<PluginTrackModel>("harbour.musikloud2.MusiKloud", 2, 0, "PluginTrackModel");
    qmlRegisterType<ResourcesRequest>("harbour.musikloud2.MusiKloud", 2, 0, "ResourcesRequest");
    qmlRegisterType<SearchHistoryModel>("harbour.musikloud2.MusiKloud", 2, 0, "SearchHistoryModel");
    qmlRegisterType<SelectionModel>("harbour.musikloud2.MusiKloud", 2, 0, "SelectionModel");
    qmlRegisterType<ServiceModel>("harbour.musikloud2.MusiKloud", 2, 0, "ServiceModel");
    qmlRegisterType<SoundCloudAccountModel>("harbour.musikloud2.MusiKloud", 2, 0, "SoundCloudAccountModel");
    qmlRegisterType<SoundCloudArtist>("harbour.musikloud2.MusiKloud", 2, 0, "SoundCloudArtist");
    qmlRegisterType<SoundCloudArtistModel>("harbour.musikloud2.MusiKloud", 2, 0, "SoundCloudArtistModel");
    qmlRegisterType<SoundCloudComment>("harbour.musikloud2.MusiKloud", 2, 0, "SoundCloudComment");
    qmlRegisterType<SoundCloudCommentModel>("harbour.musikloud2.MusiKloud", 2, 0, "SoundCloudCommentModel");
    qmlRegisterType<SoundCloudConnectionModel>("harbour.musikloud2.MusiKloud", 2, 0, "SoundCloudConnectionModel");
    qmlRegisterType<SoundCloudNavModel>("harbour.musikloud2.MusiKloud", 2, 0, "SoundCloudNavModel");
    qmlRegisterType<SoundCloudPlaylist>("harbour.musikloud2.MusiKloud", 2, 0, "SoundCloudPlaylist");
    qmlRegisterType<SoundCloudPlaylistModel>("harbour.musikloud2.MusiKloud", 2, 0, "SoundCloudPlaylistModel");
    qmlRegisterType<SoundCloudSearchTypeModel>("harbour.musikloud2.MusiKloud", 2, 0, "SoundCloudSearchTypeModel");
    qmlRegisterType<SoundCloudStreamModel>("harbour.musikloud2.MusiKloud", 2, 0, "SoundCloudStreamModel");
    qmlRegisterType<SoundCloudTrack>("harbour.musikloud2.MusiKloud", 2, 0, "SoundCloudTrack");
    qmlRegisterType<SoundCloudTrackModel>("harbour.musikloud2.MusiKloud", 2, 0, "SoundCloudTrackModel");
    qmlRegisterType<TrackModel>("harbour.musikloud2.MusiKloud", 2, 0, "TrackModel");
    qmlRegisterType<TransferModel>("harbour.musikloud2.MusiKloud", 2, 0, "TransferModel");
    
    qmlRegisterUncreatableType<Transfer>("harbour.musikloud2.MusiKloud", 2, 0, "Transfer", "");

    qmlRegisterType<QSoundCloud::AuthenticationRequest>("harbour.musikloud2.QSoundCloud", 1, 0, "AuthenticationRequest");
    qmlRegisterType<QSoundCloud::ResourcesModel>("harbour.musikloud2.QSoundCloud", 1, 0, "ResourcesModel");
    qmlRegisterType<QSoundCloud::ResourcesRequest>("harbour.musikloud2.QSoundCloud", 1, 0, "ResourcesRequest");
    qmlRegisterType<QSoundCloud::StreamsModel>("harbour.musikloud2.QSoundCloud", 1, 0, "StreamsModel");
    qmlRegisterType<QSoundCloud::StreamsRequest>("harbour.musikloud2.QSoundCloud", 1, 0, "StreamsRequest");
}

Q_DECL_EXPORT int main(int argc, char *argv[]) {
    QCoreApplication::setOrganizationName("MusiKloud2");
    QCoreApplication::setApplicationName("MusiKloud2");
    QCoreApplication::setApplicationVersion(VERSION_NUMBER);

    QGuiApplication *app = SailfishApp::application(argc, argv);
    QQuickView *view = SailfishApp::createView();

    Settings settings;
    AudioPlayer player;
    //Clipboard clipboard;
    //DBusService dbus;
    Resources resources;
    ResourcesPlugins plugins;
    SoundCloud soundcloud;
    Transfers transfers;
    Utils utils;
        
    initDatabase();
    registerTypes();
    plugins.load();
    settings.setNetworkProxy();

    QQmlContext *context = view->rootContext();
    
//    context->setContextProperty("Clipboard", &clipboard);
//    context->setContextProperty("DBus", &dbus);
    context->setContextProperty("Plugins", &plugins);
    context->setContextProperty("Resources", &resources);
    context->setContextProperty("Settings", &settings);
    context->setContextProperty("SoundCloud", &soundcloud);
    context->setContextProperty("Transfers", &transfers);
    context->setContextProperty("Utils", &utils);
    context->setContextProperty("MAX_RESULTS", MAX_RESULTS);
    context->setContextProperty("VERSION_NUMBER", VERSION_NUMBER);

    view->setSource(SailfishApp::pathTo("qml/harbour-musikloud2.qml"));
    view->setResizeMode(QQuickView::SizeRootObjectToView);
    view->show();

    return app->exec();
}
