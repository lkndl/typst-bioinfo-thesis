
#import "styles.typ": *
#import "headers.typ": *
#import "footers.typ": *
#import "figures.typ": *
#import "bioinfo-covers.typ": cover-page as bioinfo-cover, title-page as bioinfo-title
#import "info-covers.typ": cover-page as info-cover, title-page as info-title
#import "front-matter.typ": *
#import "back-matter.typ": *

#let doc(
  author: "nobody",
  lang: "en",
  title: none,
  short-title: none,
  translated-title: none,
  date: datetime.today(),
  degree: "bachelor",
  german-abstract: [],
  english-abstract: [],
  supervisors: (),
  advisors: (),
  bibliography-file: none,
  flavour: "info",
  numbering-depth: 2,
  pagination-align: "outside",
  
  // The content that trails after, in main.typ
  body
) = {

  assert(lang in ("en", "de"), message: "only English or German are allowed")
  assert(degree in ("bachelor", "master"), message: "this template only works for B.Sc. or M.Sc. degrees right now")
  let Degree = [#box([#upper(degree.at(0))#degree.slice(1)])] 
  assert(pagination-align in ("outside", "inside", left, right, center))
  assert(flavour in ("bioinfo", "info"), message: "only two variants in the box: bioinfo and info")
  let (cover-page, title-page) = if flavour == "info" { (info-cover, info-title) } else { (bioinfo-cover, bioinfo-title) }

  set document(author: author, title: short-title)
  set page(
    paper: "a4",
    margin: (bottom: 3cm, rest: 2.5cm),
  )
  set text(
    font: "Helvetica Neue", // "Liberation Sans", // "IBM Plex Sans",  // "New Computer Modern Sans",
    size: 12pt,
    //fill: red,
    lang: lang,
  )
  set par(justify: true, leading: .88em)
  set block(above: 8pt, below: 24pt)
  // define the `code` font style
  show raw: set text(..raw-style)
  // sans-serif and equal-width font for math
  show math.equation: set text(font: "Fira Math")

  show: heading-styles.with(lang, numbering-depth)
  show: caption-styles.with(supplement-position: "left")
  

  ////////////////////////////////////////////////
  // actual document content starts here 
  
  // The front matter
  set page(numbering: "a", footer: []) // define a numbering, but don't show it
  cover-page(author, lang, title, Degree)
  set page(numbering: "i", footer: [])
  counter(page).update(1)
  title-page(author, lang, title, Degree, supervisors, advisors, translated-title, date)
  set page(
    footer: get-pagination(pagination-align),
    header: get-headers())
  declare-page(author, lang, Degree)
  abstract(german-abstract, english-abstract)
  // totally optional:
  //acknowledgements(lang, [Thanks everyone!], title: "thx")
  table-of-contents(lang, simple: true)
  // the intro maybe should start on a right-hand side, but in any case the right-hand pages must be "odd"!
  pagebreak(to: "odd")
  //empty-page()
  set page(numbering: "1")
  counter(page).update(1)

  // *now* fix the show rule to require a pagebreak before any new chapter, until https://github.com/typst/typst/issues/2841 is resolved
  show heading.where(level: 1): it => pagebreak(weak: true) + headingspaced(it)

  // The main content
  body

  // The back matter
  // pagebreak(to: "odd") now won't work!until https://github.com/typst/typst/issues/2841 is resolved
  //just fix it by inserting an empty page
  // empty-page()
  // continue the front matter page counter
  set page(numbering: "i")
  continue-page-counter-from(<toc-end>, shift: none)
  references(bibliography-file: bibliography-file, lang: lang)
  list-of-figures(lang)
  list-of-tables(lang)
}