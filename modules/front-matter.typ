#import "styles.typ": *
#import "footers.typ": *
#import "@preview/outrageous:0.4.0"

#let submission-info-table(args) = {
  set align(center + bottom)
  set par(leading: .5em)
  set text(size: 14pt)  
  let opts = (
    columns: 2,
    //inset: 0pt, 
    align: left + top,
    column-gutter: 5pt,
    row-gutter: 5pt,
    stroke: none,
  )

  if args.lang == "en" [
    #table(
      ..opts,
      [Author:], [#args.author],
      [Supervisor] + if args.supervisors.len() > 1 [s:] else [:], args.supervisors.join([ \ ]),
      [Advisor] + if args.advisors.len() > 1 [s:] else [:], args.advisors.join([ \ ]),
      [Submitted:], [#args.date.display("[day] [month repr:short] [year]")]
    )
  ] else if args.lang == "de" [
    #table(
      ..opts,
      [Verfasser:], [#args.author],
      [Themensteller:], args.supervisors.join([ \ ]),
      [Betreuer:], args.advisors.join([ #parbreak() ]),
      [Abgabedatum:], [#args.date.display("[day].[month].[year]")]
    )
  ]
}

#let make-cover(args) = {
  // load the correct module for this flavour
  import str(args.flavour + "-covers.typ") : *
  cover-page(args) 
}

#let make-title(args) = {
  // re-start the page numbering
  counter(page).update(1)
  // load the correct module for this flavour
  import str(args.flavour + "-covers.typ") : *
  title-page(args, submission-info-table(args))  
}

#let declare-page(args) = {
  pagebreak(weak: true, to: "odd")
  set heading(numbering: none, outlined: false, bookmarked: true, level: 1)
  if args.lang == "en" [
    = Declaration of Authorship
    I confirm that this #box([#args.degree's thesis]) is my own work and I have documented all sources and material used.
    #v(2cm)#h(2cm)Date#h(1fr)#args.author#h(2cm)   
  ] else if args.lang == "de" [
    = Eigenständigkeitserklärung
    Ich versichere, dass ich diese #box([#args.Degree's Thesis]) selbständig verfasst und nur die angegebenen Quellen und Hilfsmittel verwendet habe.
    #v(2cm)#h(2cm)Datum#h(1fr)#args.author#h(2cm)   
  ] 
}

#let acknowledgements(lang, content, title: none) = {
  pagebreak(weak: true, to: "odd")
  set heading(numbering: none, outlined: false, bookmarked: true, level: 1)
  if title != none [= #title] else if lang == "en" [= Acknowledgements] else [= Danksagung]
  content
}

#let abstract(german, english) = {
  pagebreak(weak: true, to: "even")
  set heading(numbering: none, outlined: false, bookmarked: true, level: 1)
  [
    = Zusammenfassung
    #german
    #pagebreak()
    = Abstract
    #english
  ]
}


#let table-of-contents(lang, simple: true) = {
  pagebreak(weak: false, to: "even")
  set heading(numbering: none, outlined: false, bookmarked: true, level: 1)
  show outline.entry: set block(spacing: .65em)

  let toc-title = if lang == "en" [Contents] else [Inhaltsverzeichnis]
  if simple {
    show outline.entry: outrageous.show-entry.with(
      ..outrageous.presets.outrageous-toc,
      font-weight: ("bold", auto),
      vspace: (32pt, none),
      fill-right-pad: 5pt, 
      fill: (none, align(right, repeat(justify: false, box(width: quantum, "."))))
    )
    [#outline(title: toc-title, indent: auto) <toc> #metadata("toc-end") <toc-end>
    ]
    return
  } else {
    // more complicated but still nicer table-of-contents, as of typst 0.13.0 (d6b0d68f)
    let extractor(it) = {
      let loc = it.element.location()
      let title = it.element.body
      let number = none
      if it.element.numbering != none {
        number = numbering(it.element.numbering, ..counter(heading).at(loc))
      }
      (number, title, loc)
    }

    let layoutor(number, title, loc, page, indent: 0pt, fill: none) = {
      if fill == none {
        fill = box(
          width: 1fr, baseline: -1pt,
          align(right, scale(x: -100%, line(
            length: 100%, stroke: (dash: ("dot", quantum)))))
          )
      }
      box(width: 100%, stack(dir: ltr,
        h(indent),
        number,
        box(width: 100% - page-num-width - indent - if number == none {0pt} else {number.width}, [
          #link(loc, title)#fill
        ]),
        align(bottom + right, box(width: page-num-width, link(loc, page)))
      ))
      
    }

    show outline.entry.where(
      level: 1
    ): it => {
      let (number, title, loc) = extractor(it)
      // Most level 1 headings have a numbering; so display that one in a separately aligned "column" to the left, reserving 1.4em here. For example the bibliography shows up in the TOC, but does not get a numbering.
      number = if number == none {none} else [#box(width: 1.4em, link(loc, number))]
      v(6pt) // free space above
      strong( // bold
        layoutor(number, title, loc, it.page(), //str(counter(page).at(loc).first()),//display(loc.page-numbering()), 
          indent: 0pt, fill: h(1fr)))
    }
    
    show outline.entry.where(
      level: 2
    ): it => {
      let (number, title, loc) = extractor(it)
      number = [#box(width: 2em, link(loc, number))]
      layoutor(number, title, loc, it.page(), indent: 5pt)
    }

    show outline.entry.where(
      level: 3
    ): it => {
      let (number, title, loc) = extractor(it)
      number = none // hide numbering
      layoutor(number, title, loc, it.page(), indent: 2em + 5pt) // more ident, but actually not
    }

    [#outline(title: toc-title, depth: 3) <toc> #metadata("toc-end") <toc-end>]
  }
}
