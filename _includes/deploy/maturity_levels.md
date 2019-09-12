## Maturity Levels

In order to communicate the current development status and maturity of dpl's
support for a particular service, the respective provider is marked with one of
the following maturity levels, according to the given criteria:

* `dev` - the provider is in development (initial level)
* `alpha` - the provider is fully tested
* `beta` - the provider has been in alpha for at least a month and successful real-world production deployments have been observed
* `stable` - the provider has been in beta for at least two months and there are no open issues that qualify as critical (such as deployments failing, documented functionality broken, etc.)

> Dpl v2 represents a major rewrite, so support for all providers has been
reset to `dev` or `alpha`, depending on the test status.

For all levels except `stable` a message will be printed to your build log
that informs you about the current status.
