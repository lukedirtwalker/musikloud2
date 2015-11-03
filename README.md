#MusiKloud2

MusiKloud2 is a SoundCloud client and music player that can be extended via plugins.

Features include:

    * Browse and search tracks, sets and users.
    * Play and download tracks.
    * Support for multiple SoundCloud accounts.
    * Support for user-defined credentials and access scopes for SoundCloud.
    * Support for additional services via plugins.
    
## Build for Sailfish:
    * Have qsoundcloud at the same directory level as musikloud2, e.g.
        -foo/qsoundcloud
        -foo/musikloud2
    * In build steps (Projects -> Build) under qmake add additional arguments:
        ```DEFINES+=QSOUNDCLOUD_STATIC_LIBRARY```