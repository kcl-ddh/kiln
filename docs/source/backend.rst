.. _backend:

Using Kiln as an independent backend
====================================

While Kiln provides facilities for creating and serving resources to
user clients, it can equally well be used solely as a backend to
another system or systems operating as the frontend. There is nothing
special or different about such operation, and the same principles and
approaches apply. Rather than a user client, such as a browser, making
a request to a URL and getting a resource, the frontend system makes
the request, perhaps using AJAX, and then operates on the resource.


Providing content for incorporation into HTML
---------------------------------------------

A common use case is to have Kiln provide content that the frontend
then incorporates into its own templating system for display as
HTML. Kiln provides an example template and pipeline showing how this
might be achieved. The template transforms TEI into HTML, and provides
that, plus any metadata, CSS, and JavaScript that might be required
for correct display. All of these are made available in individual
elements within the XML document that Kiln returns.

This allows the frontend system to collate the various pieces as it
wishes without having to perform any complicated transformations.


Requesting a resource with Python
---------------------------------

Sample code for requesting a resource from Kiln using Python::

  import requests

  r = requests.get(kiln_resource_url)
  xml = r.text
  # Process XML.
  ...

Requesting a resource with JavaScript
-------------------------------------

Sample code for requesting a resource from Kiln using JavaScript (with
jQuery)::

  function xml_content_handler (xml) {
    // Process XML.
  }

  $.get({
    url: kiln_resource_url,
    dataType: 'xml'
  }).done(xml_content_handler);
