#import "styles.typ": *

#let logos() = {
  table(
    columns: (30%, 1fr, 40%),
    align: (x, y) => (left, center, right + bottom).at(x),
    inset: 0pt, 
    stroke: none,
    image("logos/lmu_logo.svg"), //, width: 48mm),
    [],
    image("logos/tum_logo_wide.svg"), //, width: 64mm),
  )
}

#let cover-page(author, lang, title, Degree) = {
  set heading(numbering: none, outlined: false, bookmarked: false, level: 1)
      logos()
  v(4.9cm)
  set align(center)
  set text(15pt, hyphenate: false)
  set block(spacing: .3em) 
  set par(leading: 1.4em, justify: false)
  
  if lang == "en" [
    Bioinformatics Program \ Technical University of Munich \ Ludwig-Maximilians-Universität München \ #v(1.3cm) #Degree's Thesis in Bioinformatics #v(1.1cm)
  ] else if lang == "de" [
    Studiengang Bioinformatik \ Technische Universität München \ Ludwig-Maximilians-Universität München \ #v(1.3cm) #Degree Arbeit in Bioinformatik #v(1.1cm)
  ]
  [
    #line(length: 100%, stroke: 0.5mm)
    #v(3mm)
    #par(leading: .5em, text(26pt)[*#title*])
    #v(5mm)
    #line(length: 100%, stroke: 0.5mm)
    #v(1.4cm)
    #author
  ]
}

#let title-page(
  author, lang, title, Degree, supervisors, advisors, translated-title, date) = {
  pagebreak(weak: true, to: "odd")
  logos()
  v(2.9cm)
  set align(center)
  set text(15pt, hyphenate: false)
  set block(spacing: .3em) 
  set par(leading: 1.35em, justify: false)
  
  if lang == "en" [
    Bioinformatics Program \ Technical University of Munich \ Ludwig-Maximilians-Universität München \ #v(1.3cm) #Degree's Thesis in Bioinformatics #v(1.1cm)
  ] else if lang == "de" [
    Studiengang Bioinformatik \ Technische Universität München \ Ludwig-Maximilians-Universität München \ #v(1.3cm) #Degree Arbeit in Bioinformatik #v(1.2cm)
  ] else {
    assert(false)
  }
  [
    *#par(leading: .5em, text(22pt)[#title#v(1.1cm)#translated-title])*
    #v(1.5cm)
  ]

  set align(center + bottom)
  set par(leading: .65em)
  set text(size: 13pt)
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