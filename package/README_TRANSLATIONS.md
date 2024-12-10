(Instructions adapted from gmail-plasmoid:
http://code.google.com/p/gmail-plasmoid/)
KDE Ki18n translator's guide: https://api.kde.org/frameworks/ki18n/html/trn_guide.html

This document contains brief instructions on how to create new
translations for this plasmoid. If any of the instructions are unclear
or you encounter any difficulties please contact the author.


Existing translations no longer need to be installed. If you previously installed them and are encountering problems, try removing them, e.g.,
```bash
rm /usr/share/locale/*/LC_MESSAGES/plasma_applet_org.kde.userbase.plasma.luna3.mo
rm ~/.local/share/locale/*/LC_MESSAGES/plasma_applet_org.kde.userbase.plasma.luna3.mo
```



---------------------------------------------
Step 1: Creating a new <locale>.po file
---------------------------------------------
First locate where the plasmoid has been installed.

If it was installed using Add Widgets menu, it will probably be:
  `~/.local/share/plasma/plasmoids/org.kde.userbase.plasma.luna3/`

If you did a global install of the plasmoid, it's probably under:
  `/usr/share/plasma/plasmoids/org.kde.userbase.plasma.luna3/`


Under the `po` folder, make a folder for the locale, e.g.: `fr/`

Make a copy of
  `plasma_applet_org.kde.userbase.plasma.luna3.pot`

Move/rename it to the folder you created, e.g.:
  `fr/plasma_applet_org.kde.userbase.plasma.luna3.po`

Bash:
```bash
  mkdir -p fr
  cp plasma_applet_org.kde.userbase.plasma.luna3.pot fr/plasma_applet_org.kde.userbase.plasma.luna3.po
  ```

You are now ready to start translating.

--------------------------------------
Step 2: Translate the required strings
--------------------------------------
While you can edit the .po file in any text editor, using the
"lokalize" program can make your life easier. This program is packaged
for most distributions so it should be easy to install. Whatever method
you choose, you need to supply a translation for all of the strings that
appear in the .po file.

If you encounter any strings that you cannot translate due to the choice
of words or some other issue, please contact the author to work out a
solution.

-------------------------------------------
Step 3: Convert the .po file to an .mo file
-------------------------------------------
The plasmoid needs the translation in a .mo file.

Go to contents/po and run `./Messages.sh` - this generates the .mo files for
all the .po files.

The .mo files are placed in the `locale` directory under `contents`,

e.g. `locale/fr/LC_MESSAGES/plasma_applet_org.kde.userbase.plasma.luna3.mo`

----------------------------
Step 4: Test the .mo file
----------------------------
Finally, install the plasmoid and test your translations.

Update the plasmoid installation:
```bash
plasmapkg2 -u package
```

Test your translations (if not part of configuration menu):
```bash
LANGUAGE=fr plasmawindowed -d org.kde.userbase.plasma.luna3
```

Or simply logout and back in - it should pick up the translations.

----------------------------------------------------------
Step 5: Send the translation for inclusion with the widget
----------------------------------------------------------
Once you are happy with the translation please send the .po file to the
author along with translations for the following two strings for the "Add Widgets" screen (see
`metadata.json`):

 - "Luna 3"
 - "Display moon phases for your location"

Please send the translations for these two strings only when the
translation is not yet in `metadata.json`.

Alternatively, fork on Github (samuel-jimenez/Luna3), do your changes there, and
then send a pull request.
