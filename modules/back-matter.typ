#import "styles.typ": *

#let references(
  bibliography-file: none,
  style: "apa", lang: "en") = {
    // pass a pre-installed citation style or the path to a .csl file here. Download `.csl`s from https://github.com/citation-style-language/styles
    // also check https://www.ub.tum.de/en/citation-guide 
  if bibliography-file != none {
    //pagebreak()
    //v(-space)
    let bib-title = if lang == "en" [References] else [Literaturverzeichnis]
    heading(level: 1, outlined: true, numbering: none, bib-title)
    //show bibliography: set text(8pt)
    set block(spacing: .65em)
    bibliography(bibliography-file, 
      title: none,
      style: style)
  }
}


#let list-of(thing, title) = {
  // this is used for list-of-figures and list-of-tables
  show outline.entry: it => {
    let (suppl, _, number, _, title, ..) = it.body.children
    let loc = it.element.location()
    box(width: 100%, stack(dir: ltr, 
      // the number of the "thing"
      box(width: 5mm, link(loc, number)),
      // the title, i.e. first [] of the caption, may be multi-line
      box(width: 100% - page-num-width - 5mm, [
        #link(loc, title)
        // the gap characters
        #box(width: 1fr, baseline: -1pt,
          align(right, scale(x: -100%, line(
            length: 100%, stroke: (dash: ("dot", quantum)))))
      )]),
      // the page number, bottom-aligned for long figure titles
      align(bottom + right, 
        box(width: page-num-width, link(loc, it.page)))
    ))
  }

  locate(loc => {
    let figures = figure.where(kind: thing)
    if query(figures, loc).len() == 0 {
      return // break if none found
    }
    //pagebreak()
    //v(-space)
    heading(level: 1, outlined: true, numbering: none, title)
    outline(
      title: none,
      target: figures,
    ) 
  })
}


#let list-of-figures(lang) = {
  let lof-title = if lang == "en" [List of Figures] else [Abbildungsverzeichnis]
  list-of(image, lof-title) 
}


#let list-of-tables(lang) = {
  let lot-title = if lang == "en" [List of Tables] else [Tabellenverzeichnis]
  list-of(table, lot-title)
}