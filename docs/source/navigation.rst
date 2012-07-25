.. _navigation:

Navigation
==========

Kiln's navigation is configured in the file
``KILN_HOME/webapps/root/assets/menu/main.xml``, by default the menu contains
only a link to the homepage.

The following examplifies the type of functionality that can be achieved with
the navigation menu. Note that the level of menu nesting is in theory
unlimited, but it will be badly displayed.

::

    <root label="" xmlns="http://www.cch.kcl.ac.uk/xmod/menu/1.0">
        <menu href="index.html" label="Home"/>
        <menu href="index.html" label="About" root="about">
            <item href="team.html" label="Team"/>
        </menu>
        <menu href="index.html" label="Latest" root="latest">
            <item href="events.html" label="Events"/>
            <item href="presentation.html" label="Presentations"/>
        </menu>
    </root>

The values of ``menu/@root`` attributes need to correspond to folders in the
filesystem that must exist in ``KILN_HOME/webapps/root/content/xml/tei``, the
values  of ``@href`` need to correspond to files named in the same way but with
a *.xml* extension.
