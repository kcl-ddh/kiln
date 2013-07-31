.. _error:

Error handling
==============

Kiln uses Cocoon's built-in error handling mechanism. It provides two
levels of handling. The first, defined in ``sitemaps/main.xmap``,
makes use of the templating system to provide error messages that
display in the style of the site. The second, defined in
``sitemaps/config.xmap``, is untemplated, and used only if there is a
problem with the code used in the first level error-handling.

Both levels will display all of the technical details Cocoon makes
available when the global variable ``debug`` is set to "1", and hidden
when it is set to "0".

Error messages can be overridden if desired; this is already done for
404 errors, for which see ``sitemaps/main.xmap``.
