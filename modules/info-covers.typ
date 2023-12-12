#import "styles.typ": *

#let head() = {
  set block(spacing: 1em)
  align(top, [
    #image("logos/tum_logo.svg", width: 25%)
    #par(leading: .5em, text(
    weight: "extralight", size: 26pt, 
    upper([School of Computation, \ Information and Technology -- \ Informatics])))
    #text(weight: "light", size: 18pt, upper([Technische Unversität München]))
  ])
}

#let cover-page(author, lang, title, Degree) = {
  set align(center)
  head()
  set block(spacing: 2.5em)
  set par(justify: false)
  set text(size: 18pt, hyphenate: false)
  [
    #v(1em)
    #Degree's Thesis in Informatics \
    #par(leading: .5em, text(weight: "medium", size: 26pt, title))
    #author
    #align(bottom, image("logos/tum_in_logo.svg", width: 20%))
  ]
}

#let title-page(
  author, lang, title, Degree, supervisors, advisors, translated-title, date) = {
  pagebreak(weak: true, to: "odd")
  set align(center)
  head()
  set block(spacing: 2.5em) 
  set par(justify: false)
  set text(size: 18pt, hyphenate: false)
  [
    #v(0em)
    #Degree's Thesis in Informatics \
    #par(leading: .5em, text(weight: "medium", size: 22pt, title))
    #v(-1em)
    #par(leading: .5em, text(weight: "medium", size: 22pt, translated-title)) 
  ]

  set align(bottom)
  set text(size: 14pt)
  let opts = (
    columns: 2,
    //inset: 0pt, 
    align: left + top,
    column-gutter: 5pt,
    row-gutter: 5pt,
    stroke: none,
  )

  if lang == "en" [
    #table(
      ..opts,
      [Author:], [#author],
      [Supervisor] + if supervisors.len() > 1 [s:] else [:], supervisors.join([ \ ]),
      [Advisor] + if advisors.len() > 1 [s:] else [:], advisors.join([ \ ]),
      [Submitted:], [#date.display("[day] [month repr:short] [year]")]
    )
  ] else if lang == "de" [
    #table(
      ..opts,
      [Verfasser:], [#author],
      [Themensteller:], supervisors.join([ \ ]),
      [Betreuer:], advisors.join([ \ ]),
      [Abgabedatum:], [#date.display("[day].[month].[year]")]
    )
  ]
}