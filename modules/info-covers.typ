#import "styles.typ": *

#let info-front-style(body) = {
  set align(center)
  set block(spacing: 2em)
  set par(spacing: 1em)
  align(top, [
    #image("logos/tum_logo.svg", width: 25%)
    #par(leading: .5em, text(
    weight: "extralight", size: 26pt, 
    upper([School of Computation, \ Information and Technology -- \ Informatics])))
    #text(weight: "light", size: 18pt, upper([Technische Universität München]))
  ])
  set par(justify: false)
  set text(size: 18pt, hyphenate: false)

  body
}

#let cover-page(args) = {
  show: info-front-style
  [
    #v(2.5em)
    #{args.Degree + if args.lang == "en" ['s Thesis in Informatics] else [arbeit in Informatik]} \
    #v(2em)
    #par(leading: .5em, text(weight: "medium", size: 26pt, args.title))
    #v(2.5em)
    #args.author
    #align(bottom, image("logos/tum_in_logo.svg", width: 20%))
  ]
  // the scope of show: info-front-style i.e. it's body ends here because cover-page is not passed a body - just args
}

#let title-page(args, submission-info-content) = {
  show: info-front-style
  [
    #v(1.5em)
    #{args.Degree + if args.lang == "en" ['s Thesis in Informatics] else [arbeit in Informatik]} \
    #v(2em)
    #par(leading: .5em, text(weight: "medium", size: 22pt, args.title))
    #v(1em)
    #par(leading: .5em, text(weight: "medium", size: 22pt, args.translated-title)) 
  ]
  submission-info-content
}