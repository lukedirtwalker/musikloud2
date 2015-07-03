TEMPLATE = subdirs
SUBDIRS += \
    app

contains(MEEGO_EDITION,harmattan) {
    SUBDIRS += \
        ../qsoundcloud/src

    app.depends += \
        ../qsoundcloud/src
}
# Needed to statically link qsoundcloud for Sailfish version:
exists("/usr/include/sailfishapp/sailfishapp.h"): {
SUBDIRS += \
    ../qsoundcloud/src
    app.depends = ../qsoundcloud/src
}

