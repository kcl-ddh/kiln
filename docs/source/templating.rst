.. _templating:

Templating
==========

Kiln provides a templating mechanism that provides full access to XSLT
for creating the output, and an inheritance mechanism.

Template inheritance allows for a final template to be built up of a
base skeleton (containing the common structure of the output) and
'descendant' templates that fill in the gaps.

This inheritance system works in much the same way as `Django`_\'s
template inheritance.

Using a template
----------------

To apply a template to a content source, a Cocoon ``map:transform`` is used,
as follows: ::

    <map:transform src="cocoon://_internal/template/path/to/template.xsl"/>

The matching template looks for the file
``assets/templates/path/to/template.xml``.  Note that the extension of the
template file is **xml**.

Writing a template
------------------

The basic structure of a template is as follows: ::

    <kiln:root xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
               xmlns:xi="http://www.w3.org/2001/XInclude">
        <kiln:parent>
            <xi:include href="base.xml"/>
        </kiln:parent>
        <kiln:child>
            <kiln:block name="head-title">
            </kiln:block>
        </kiln:child>
    </kiln:root>

In a base template (that is, one that does not extend another
template), there are no ``kiln:parent`` or ``kiln:child`` elements,
only ``kiln:root`` and ``kiln:block`` elements (and whatever content
the template may hold, of course).

In a template that extends another, the template being extended is
referenced by an ``xi:include``, the only allowed content of
``kiln:parent``.

Blocks
------

Block names must be unique within a template.

Attribute blocks
^^^^^^^^^^^^^^^^

In order to create a block to cover the contents of an attribute,
define a block immediately after the element holding the attribute,
specifying the name of the attribute it is a block for in the
``attribute`` attribute.

::

    <ul>
        <kiln:block name="ul-class" attribute="class">
            <xsl:text>block default</xsl:text>
        </kiln:block>
    </ul>

Multiple attribute blocks for the same element should simply be
defined in series. It is only necessary that they occur before any
non-attribute blocks within that element.

Inheriting content
^^^^^^^^^^^^^^^^^^

In addition to supplying its own content, a block may include the
content of the block it is inheriting from. To do so, an empty
``kiln:super`` element should be added wherever the inherited content
is wanted (multiple ``kiln:super`` elements may occur within a single
block.

::

    <kiln:block name="nav">
        <kiln:super/>
        <p>Extra navigation here.</p>
    </kiln:block>

If the block being inherited also contains an ``kiln:super`` element, then that
referenced content will also be included.

Dynamic content
---------------

Templates use XSLT as the coding language to create any dynamic content.
``xsl:stylesheet`` and ``xsl:template`` elements must not be used; the process
that compiles the template into an XSLT wraps the template's XSL statements in
a single ``xsl:template`` element matching on "/"; all processing occurs within
this template, or imported/included XSLT.

``xsl:import`` and ``xsl:include`` elements may be used (and the compiler will
move them to the beginning of the XSLT), as may ``xsl:apply-templates`` and
``xsl:call-template``.

Referencing assets
------------------

To reference assets (such as images, CSS and JavaScript files), ensure
that the default variables XSLT is imported, and append the path to
the file (relative to the assets directory) after the variable
reference {$kiln:assets-path}.

::

    <xsl:import href="cocoon://_internal/template/xsl/stylesheets/defaults.xsl" />

    <kiln:block name="css">
      <link href="{$kiln:assets-path}/foundation/css/normalize.css"
                  rel="stylesheet" type="text/css" />
    </kiln:block>

This ensures that nothing that might change between installations
(such as development serving the files files through Kiln, and
production serving them off another dedicated server) is hard-coded
into your templates.

See the settings in ``stylesheets/defaults.xsl`` for possible
configurations.

.. _Django: http://www.djangoproject.com/
