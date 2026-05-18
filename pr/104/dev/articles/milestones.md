# R Consortium ISC Grant Milestones

This project is partially funded by the [R Consortium 2023 ISC Grant
Program](https://r-consortium.org/all-projects/2023-group-1.html#api2r-an-r-package-for-auto-generating-r-api-clients).
To track the development toward that grant, here I log the milestones
from the grant proposal, with notes about progress, challenges, and
changes.

- **pre-0.1.0: Infrastructure.**
  - I split the OpenAPI-parsing functionality into a separate package,
    [{rapid}](https://rapid.api2r.org). That package is being developed
    parallel to this one, and contains all of the *R API
    D*efinition-specific functionality.
  - I also realized I need a package for wrapping {httr2} calls. That
    package is called [{nectar}](https://nectar.api2r.org), and is also
    being developed parallel to this one.
- **0.1.0: Basic authentication and endpoint calls.**
  - Proposal wording:
    - Export a function to generate `R/*.R` and `tests/testthat/*.R`
      files to authenticate the user and make a call to the API, given
      the URL of an OpenAPI spec in YAML format. The generated files
      will follow and encourage best practices, and will serve as the
      core around which the rest of a package would be built.
    - Produce a vignette about configuring authentication.
    - Potential challenges: Authentication is a complex and delicate
      subject. Some APIs require registration of special apps to “catch”
      authentication requests, while others simply provide an API key. I
      will need to carefully navigate these complexities in the
      vignette.
  - Changes:
    - The vignette about configuring authentication was folded into the
      main package vignette, since it turned out to be surprisingly
      straightforward (at least at this point).
    - At this point authentication covers API keys only.
- **0.2.0: OAS definition discovery.**
  - Proposal wording:
    - Add support for APIs using the OAS json format.
    - Streamline discovery of API definitions (with associated error
      handling).
    - Potential challenges: There does not appear to be a set standard
      of where API definitions are posted on a given site. It might be
      difficult to help users find the right place. Interestingly,
      <https://APIs.guru> itself has a (simple) API to aid in API
      discovery, which might provide an opportunity to use api2r to
      generate parts of itself.
  - Changes:
    - API discovery was spun off to a separate package,
      [{anyapi}](https://anyapi.api2r.org).
- **0.3.0: Batching and rate limiting.**
  - Proposal wording:
    - Add documentation for implementing batching and rate-limiting.
    - If possible, export functionality to help implement these
      processes, but standards seem to vary widely.
    - Potential challenges: This step will involve more reading and
      documenting than code, to gather examples of how different APIs
      implement limits and batching. It’s possible systems will be so
      different that it will be difficult to summarize them. For
      example, Slack has two separate batching systems in its API, with
      some functions moved to the newer system, and others not.
  - Changes:
    - This was actually developed *after* 0.4.0.
    - The wording I really wanted here was “pagination.”
    - This milestsone resulted in the
      [pagination](https://beekeeper.api2r.org/dev/articles/pagination.md)
      vignette.
- **0.4.0: Batching and rate limiting.**
  - Proposal wording:
    - Generate `R/*.R` and `tests/testthat/*.R` files for all endpoints
      (“paths”) described in the given API specification.
    - The generated functions will work, but error checking,
      documentation, and tests will be minimal.
    - Potential challenges: I’ll need to strike a balance here between
      getting a basic working system and producing something that can be
      easily expanded later.
  - Changes:
    - Generated `R/*.R` and `tests/testthat/*.R` files for all endpoints
      (“paths”) described in the given API specification.
    - The generated functions work, but error checking, documentation,
      and tests were minimal at this point.
- **0.5.0: More robust scaffolding.**
  - Proposal wording:
    - Add parameter documentation.
    - Also add parameter type checking.
    - Potential challenges: By this point I’ll need an OAS definition
      document to use for testing that includes all of the possible
      parameter types. I’ll likely need to generate a fake API
      specification that goes beyond a typical individual example.
  - Changes:
    - Type checking is implemented for many parameter types (logical,
      character, integer, double), and infrastructure is in place to
      addd the rest as they become available in the spun-off
      [{stbl}](https://stbl.wrangle.zone) package.
    - I don’t really *need* the grand API specification I envisioned for
      testing, so I did not create that.
- **0.6.0: Expected results.**
  - Proposal wording:
    - Add response (return value) documentation.
    - Use expected responses to generate better test scaffolds.
    - Potential challenges: Testing the generation of tests might
      present unique challenges. I’ll need to look into how testthat
      tests itself.
- **0.7.0: Error messaging.**
  - Proposal wording:
    - Add more robust error messaging for non-standard responses.
    - Potential challenges: Mocking cases where things fail can be
      tricky. Ideally this step will involve pushing the package to a
      stable 1.0.0, but that will require enough usage to feel confident
      that the core function definitions are stable.

I have plans beyond v0.7.0, logged as issues (and, in some cases,
implemented infrastructure) in the GitHub repository. For the moment, I
am focusing on completing the expectations for the grant.
