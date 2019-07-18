.. _testing:

Testing framework
=================

Kiln provides a basic framework to run automated tests that check the
XML output of a ``map:match`` with expected output. Tests are stored
in the ``webapps/ROOT/test-suite`` directory, with the expected data
being stored under ``data`` and the definition of the tests in files
under ``cases``.

The format for test-case files are specified in
``assets/schema/test/test_case.rng``. Each test within a test-case
file specifies the path to the expected data XML file (relative to
``test-suite/data``) and the id and parameters of the ``map:match`` to
be tested.

The admin menu links to the HTML report for running all of the tests
in all of the test-cases under ``test-suite/cases``, noting for each
test whether it passed or failed, and if it failed, giving a rough
difference between the actual and expected output.
