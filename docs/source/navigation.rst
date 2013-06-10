.. _navigation:

Navigation
==========

By default Kiln's navigation is configured in the file
``KILN_HOME/webapps/ROOT/assets/menu/main.xml``, and the menu comes
only with a link to the homepage.

It is possible to have multiple menu files for different pages of the
website.  The menu file that is used for a specific page is specified
in the sitemap file ``KILN_HOME/webapps/ROOT/sitemaps/main.xmap``
using ``<map:part src="cocoon://_internal/menu/main.xml" />``. For
instance if there was another menu file named ``foo.xml`` it could be
used instead of the main one by changing the sitemap file for a
specific match to ``<map:part src="cocoon://_internal/menu/foo.xml"
/>``

The following examplifies the type of functionality that can be
achieved with the navigation menu. Note that the level of menu nesting
is in theory unlimited, but it will be badly displayed.

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

The values of ``menu/@root`` attributes need to correspond to folders
in the filesystem that must exist in
``KILN_HOME/webapps/ROOT/content/xml/tei``, the values of ``@href``
need to correspond to files named in the same way but with a *.xml*
extension. The value of ``@href`` is relative to the value of
``menu/@root``.
