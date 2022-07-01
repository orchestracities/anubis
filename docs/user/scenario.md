# Usage scenarios

Anubis is designed with the following scenarios in mind:

1. 1. Simplify portability of data access control policies across different
  platforms by keeping data and policy together, thus supporting data sharing
  and increasing data sovereignty.
  Suppose User A stores Data 1 in your Platform X, and then User A
  copy the Data 1 to Platform Y, given that policies defined by User A in
  Platform X are attached to Data 1 and expressed via a standard vocabulary,
  Platform Y can rely on policies attached to Data 1 to provide access,
  without User A having to re-develop the policies in Platform Y.

1. (To be supported). Enable data owners to apply/change policies
  everywhere/anytime by supporting distributed synchronization of
  access control policies. Suppose two different platforms
  A and B adopts Anubis, when Data 1 is transferred from Platform A to
  Platform B, policies for Data 1 are also synchronized in Platform B.
  When User A, change policies linked to Data 1 in Platform B, updated policies
  are synchronized in Platform A. A single domain variant of this scenario
  is also possible, when for example, within the same platform, data is
  accessible at different locations (and local access control is applied).

1. Reduce time to manage policies across different APIs and platforms by
  decoupling data access control from API format. Usually policies mimic
  the API format, and this implies that for the same data, different policies
  may be required for each API where they are accessible, by decoupling API
  format and access control policies, it is possible to avoid that.
  Suppose that Data 1 is stored in API A and in API B, Anubis allow you
  to define a single set of policies to access Data 1 across both APIs.

Ultimately the support for these three scenarios enables user-centric control
of security and privacy data policies on existing APIs thus enabling
user-centric data sovereignty across different APIs, platforms and providers.
