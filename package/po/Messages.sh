#!/bin/sh

#! /usr/bin/env bash
# $XGETTEXT `find . -name \*.js -o -name \*.qml` -o $podir/plasma_applet_org.kde.userbase.plasma.luna3.pot

# based on example found here:
#   https://techbase.kde.org/Development/Tutorials/Localization/i18n_Build_Systems

BUGADDR="https://github.com/samuel-jimenez/Luna3/issues" # MSGID-Bugs

WDIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd) # working dir
BASEDIR=${WDIR}/.. # root of translatable sources
METADATA=${BASEDIR}/metadata.json

PROJECT=plasma_applet_$(grep '"Id"' $METADATA | sed -E 's/^\s+".*": "(.*)",/\1/')
VERSION=$(grep '"Version"' $METADATA | sed -E 's/^\s+".*": "(.*)",/\1/')

RCSCRIPT="$WDIR/rc.js"

echo "Preparing rc files"

cd ${BASEDIR}

# additional string for KAboutData
echo 'i18nc("NAME OF TRANSLATORS","Your names");' >$RCSCRIPT
echo 'i18nc("EMAIL OF TRANSLATORS","Your emails");' >>$RCSCRIPT

cd ${WDIR}

echo "Done preparing rc files"

echo "Extracting messages"

cd ${BASEDIR}

# see above on sorting
find . -name '*.qml' -o -name '*.js' | sort >${WDIR}/infiles.list

cd ${WDIR}
xgettext --from-code=UTF-8 -C -kde -ci18n -ki18n:1 -ki18nc:1c,2 -ki18np:1,2 -ki18ncp:1c,2,3 -ktr2i18n:1 \
	-kI18N_NOOP:1 -kI18N_NOOP2:1c,2 -kaliasLocale -kki18n:1 -kki18nc:1c,2 -kki18np:1,2 -kki18ncp:1c,2,3 \
	--msgid-bugs-address="${BUGADDR}" \
	--files-from=infiles.list -D ${BASEDIR} -D ${WDIR} -o ${PROJECT}.pot || {
	echo "error while calling xgettext. aborting."
	exit 1
}

echo "Done extracting messages"

echo "Merging translations"

catalogs=$(find . -name '*.po')
for cat in $catalogs; do
	echo $cat
	msgmerge -o $cat.new $cat ${PROJECT}.pot
	mv $cat.new $cat
done

echo "Done merging translations"

echo "Generating mo files"

catalogs=$(find . -name '*.po')
for cat in $catalogs; do
	echo $cat
	catdir=${BASEDIR}/contents/locale/$(dirname $cat)/LC_MESSAGES
	mkdir -p $catdir
	msgfmt $cat -o $catdir/$PROJECT.mo
done

echo "Done generating mo files"

echo "Cleaning up"
cd ${WDIR}
rm infiles.list
rm $RCSCRIPT

echo "Done"
