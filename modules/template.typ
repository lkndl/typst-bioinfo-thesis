
#import "styles.typ": *
// #import "headers.typ": *
#import "footers.typ": *
#import "figures.typ": *
#import "front-matter.typ": *
#import "back-matter.typ": *
#import "@preview/hydra:0.3.0": hydra

// These are the fields you can or
// should pass to the template function
#let default-args = arguments(
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
)

#let doc(..passed-args, body) = {
  // merge into a single option namespace
  let args = default-args.named() + passed-args.named()

  if args.lang not in ("en", "de") {
    panic([This template is set up for English "en" or German "de". If you want to use a different language, it's easiest to change all "de"-dependant code to your language, then delete/change this block. Maybe you want to make a pull request?])
  }
  if args.flavour not in ("info", "bioinfo") {
    panic([Don't know this flavour: #flavour. If you did that on purpose, build an "#{args.flavour}-covers.typ" module that implements a "cover-page" and "title-page", then delete/change this block.])
  }
  if args.degree not in ("bachelor", "master") {
    panic([This template is meant for "bachelor" or "master" theses. You passed #args.degree and that might turn out weird somewhere! Delete/change this block once you checked.])
  }
  args.Degree = [#box([#upper(args.degree.at(0))#args.degree.slice(1)])] 

  ////////////////////////////////////////////////
  // document setup
  set document(
    author: args.author, 
    title: args.short-title)
  set page(
    paper: "a4",
    margin: (bottom: 3cm, rest: 2.5cm),
  )
  set text(
    font: "Helvetica Neue",
    size: 12pt,
    lang: args.lang,
  )
  set par(justify: true, leading: .88em)
  set block(above: 8pt, below: 24pt)
  // define the `code` font style
  show raw: set text(..raw-style)
  // sans-serif and equal-width font for math
  show math.equation: set text(font: "Fira Math")

  show: heading-styles.with(args.lang, args.numbering-depth)
  show: caption-styles.with(supplement-position: "left")
  // show: header-styles
  

  ////////////////////////////////////////////////
  // actual document content starts here 
  // define a page numbering, but don't show it
  set page(numbering: "a", footer: [])
  // The front matter: 
  make-cover(args)
  // break to a right-handed page
  pagebreak(weak: true, to: "odd")
  // re-define the page numbering, but still don't show it
  set page(numbering: "i", footer: [])
  make-title(args)
  // again break to a right-handed page
  pagebreak(weak: true, to: "odd")
  // from now on, show some page numbers
  set page(footer: get-pagination(args.pagination-align))
  declare-page(args)
  abstract(
    args.german-abstract, args.english-abstract)
  // totally optional:
  // acknowledgements(args.lang, [Thanks everyone!], title: "thx")
  table-of-contents(args.lang, simple: true)

  ////////////////////////////////////////////////
  // some more main body setup 
  set page(
    header: locate(loc => {
      if calc.even(loc.page()) {
        // this is overkill; for demonstration
        emph[#hydra(1, loc: loc)#h(1fr)#args.author #sym.dot #args.short-title]
      } else {
        emph[#h(1fr)#hydra(2, loc: loc)]
      }
    }),
    // footer: get-pagination(args.pagination-align)
  )
  // the intro should start on a right-handed page
  pagebreak(weak: true, to: "odd")
  // set the page numbering to its main body format
  set page(numbering: "1")
  // and re-start the count
  counter(page).update(1)

  // *now* fix the show rule to require a pagebreak before any new chapter, until https://github.com/typst/typst/issues/2841 is resolved
  show heading.where(level: 1): it => pagebreak(weak: true) + headingspaced(it)

  // The main content
  body

  ////////////////////////////////////////////////
  // The back matter
  // pagebreak(to: "odd") now won't work! until https://github.com/typst/typst/issues/2841 is resolved just fix it by inserting an empty page
  // empty-page()
  // continue the front matter page counter
  set page(numbering: "i")
  continue-page-counter-from(<toc-end>, shift: none)
  references(bibliography-file: args.bibliography-file, lang: args.lang)
  list-of-figures(args.lang)
  list-of-tables(args.lang)
}