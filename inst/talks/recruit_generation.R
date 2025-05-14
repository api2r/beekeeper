# pak::pak("jonthegeek/robodeck")
#
# Use {robodeck} to help generate an initial version of a slide deck.

library(robodeck)
title <- "Building the Hive: Collaborating on API Packages with {beekeeper}"
description <-
  "Do you use a web API in R, or rely on a particular tool on the web and wish that you could access it in your R code? Do you often find yourself consulting the documentation to remember how to access that tool? Do you wish there was an R package to make all of that easier? Let's work together to create that package!
{beekeeper} is a new package to help you create and maintain an R package to wrap your favorite web API. It takes care of the \"drone work\" of API package creation, so you can quickly generate a package and make sure it's easy-to-use for you and others in the R community. It applies an opinionated framework to help you follow best practices, like consistently documenting parameters, and testing your package to make sure it works how you think it works. By working together and sharing experiences, we can make {beekeeper} even better and ensure it addresses real-world challenges developers face.
This talk is not just about introducing {beekeeper}, but also about building a supportive community of developers who can help each other succeed. Let’s collaborate to create reliable, user-friendly, API-wrapping R packages." |>
  stringr::str_squish()

section_titles <- robodeck::gen_deck_section_titles(
  title = "Building the Hive: Collaborating on API Packages with {beekeeper}",
  description = description,
  minutes = 30,
  model = "gpt-4o"
)

section_titles <- list(
  list(title = "Introduction and Motivation", minutes = 6),
  list(title = "Creating an API Package with {beekeeper}", minutes = 6),
  list(title = "What Works Today", minutes = 6),
  list(title = "What's Next", minutes = 6),
  list(title = "Collaboration and Community", minutes = 6)
)

outline <- robodeck::gen_deck_outline(
  title = title,
  description = description,
  minutes = 30,
  model = "gpt-4o",
  section_titles = section_titles
)

outline <- list(
  `Introduction and Motivation` = c(
    "How I Use APIs",
    "API Developer Docs: Where's R?",
    "The Vision for {beekeeper}"
  ),
  `Creating an API Package with {beekeeper}` = c(
    "Finding the API Spec",
    "usethis::create_package()",
    "beekeeper::use_beekeeper()",
    "beekeeper::generate_pkg()"
  ),
  `What Works Today` = c(
    "Raw generate_pkg() Output",
    "Improving Parameter Documentation",
    "Response Parsing with {tibblify}",
    "Testing & Iterating"
  ),
  `What's Next` = c(
    "What I Have Planned",
    "What I Don't Know"
  ),
  `Collaboration and Community` = c(
    "Promoting Your Package",
    "Feature Requests and Testing",
    "How You Can Contribute to {beekeeper}"
  )
)

talk <- robodeck::gen_deck(
  title = title,
  description = description,
  minutes = 30,
  model = "gpt-4o",
  section_titles = section_titles,
  outline = outline,
  additional_information = "The goal of the talk is to recruit early adopters to develop their own API packages with {beekeeper}. The tone of the talk should be fun and upbeat. Use an emoji at the start of every bullet in bulleted lists."
)

talk2 <- robodeck::gen_deck(
  title = title,
  description = description,
  minutes = 30,
  model = "gpt-4o",
  section_titles = section_titles,
  outline = outline,
  additional_information = "The goal of the talk is to recruit early adopters to develop their own API packages with {beekeeper}. The tone of the talk should be fun and upbeat. Use an emoji at the start of every bullet in bulleted lists. Minimize use of code blocks when possible."
)
