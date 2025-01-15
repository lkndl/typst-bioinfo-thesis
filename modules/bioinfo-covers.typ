#import "styles.typ": *

#let bioinfo-front-style(body) = {
  set align(center)
  set text(15pt, hyphenate: false)
  set block(spacing: .3em) 
  set par(leading: 1.4em, justify: false)
  // set heading(numbering: none, outlined: false, bookmarked: false, level: 1)

  table(
    columns: (30%, 1fr, 40%),
    align: (x, y) => (left, center, right + bottom).at(x),
    inset: 0pt, 
    stroke: none,
    image("logos/lmu_logo.svg"), //, width: 48mm),
    [],
    image("logos/tum_logo_wide.svg"), //, width: 64mm),
  )
  body
}

#let cover-page(args) = {
  show: bioinfo-front-style
  v(4.9cm)
  if args.lang == "en" [
    Bioinformatics Program \ Technical University of Munich \ Ludwig-Maximilians-Universität München \ #v(1cm) #args.Degree's Thesis in Bioinformatics
  ] else if args.lang == "de" [
    Studiengang Bioinformatik \ Technische Universität München \ Ludwig-Maximilians-Universität München \ #v(1cm) #{args.Degree}arbeit in Bioinformatik
  ]
  [
    #v(1.1cm)
    #line(length: 100%, stroke: 0.5mm)
    #v(3mm)
    #par(leading: .5em, text(26pt)[*#args.title*])
    #v(5mm)
    #line(length: 100%, stroke: 0.5mm)
    #v(1.4cm)
    #args.author
  ]
}

#let title-page(args, submission-info-content) = {
  show: bioinfo-front-style
  v(2.9cm)
  if args.lang == "en" [
    Bioinformatics Program \ Technical University of Munich \ Ludwig-Maximilians-Universität München \ #v(1cm) #args.Degree's Thesis in Bioinformatics
  ] else if args.lang == "de" [
    Studiengang Bioinformatik \ Technische Universität München \ Ludwig-Maximilians-Universität München \ #v(1cm) #{args.Degree}arbeit in Bioinformatik
  ] else {
    assert(false)
  }
  par(leading: .5em, text(22pt, strong[
    #args.title
    
    #args.translated-title
  ]))
  v(1fr)
  submission-info-content
}