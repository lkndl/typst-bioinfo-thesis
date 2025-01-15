
#let quantum = 8pt
#let page-num-width = 2em
#let space = 4.4cm
#let raw-style = (font: "IBM Plex Mono", size: 1.2em) // the default font size in the doc defines what 1em is, and this always looked a bit too small, therefore scale it

// use a state to manage whether the caption title or the full thing is displayed at different places in the do
// https://github.com/typst/typst/issues/1295#issuecomment-1853762154
#let in-outline = state("in-outline", false)

#let flex-caption(title, rest) = context if in-outline.get() { title } else { title + rest }

// set in typewriter, blue against a gray background
#let ibm(it) = {
  h(1pt, weak:false)
  box(fill: luma(250), 
    outset: 2pt, radius: 2pt, 
    //it)
    text(..raw-style, size: 1em, fill: rgb("#1A68AD"), it)) // use default size 1em here again
  h(1pt, weak:false) 
}

// refer to the page of a labeled element in the doc
#let ref-page(label, supplement: "page") = context {
    let match = query(label)
    let l = match.len()
    if l == 0 {
      panic("Found no elements for the label", label)
    } else if l > 1 {
      panic("Found more than one element for the label", label)
    }
    let loc = match.at(0).location()
    link(loc, box([#supplement #counter(page).at(loc).first()]))
}

// if you need a really empty page with no headers or footers
#let empty-page() = {
  page([], header: [], footer: [])
}

// citation shorthand
#let citeprose(label) = cite(label, form: "prose")
#let citeauthor(label) = cite(label, form: "author")

// fix reference styles: level 1 headings are chapter, not Section
#let supplements(it, lang) = {
  if "depth" not in it.fields() {
    return none
  } else if lang == "en" {
    // per default "Section", "Section", ...
    return ([chapter], [section], [subsection]).at(it.depth - 1, default: [subsection])
  } else {
    // i just made these up:
    return ([Kapitel], [Abschnitt], [Absatz]).at(it.depth - 1, default: [Absatz])
  }
}

#let heading-styles(lang, numbering-depth, body) = {
  // define the section numbering
  set heading(
      //numbering: "1.1",
      numbering: (..nums) => {
        // open problem https://github.com/typst/typst/discussions/5650
        let nums = nums.pos()
        if nums.len() > numbering-depth {
          nums = nums.slice(numbering-depth + 1)
          return numbering("1.1", ..()) + h(-0.3em) // https://github.com/typst/typst/blob/a4ac4e656267e718a5cf60d1e959f74b2b7346f3/crates/typst-library/src/model/heading.rs#L223
        } else if nums.len() <= numbering-depth {
          return numbering("1.1", ..nums)
        }},
      outlined: true, 
      supplement: it => supplements(it, lang))
  
  // add pagebreak before and space above chapters
  show heading.where(level: 1): it => pagebreak(weak: true) + block(above: 2 * space, below: space / 4, [#v(space)#text(size: 20pt, it)])

  show heading.where(level: 2): it => [
    #block(above: 11mm, below: 6mm)[#it] ]

  show heading.where(level: 3): it => [
    #block(above: 8mm)[#it.body] ] // hide the numbering
  
  show ref: it => {
    let el = it.element
    if el != none and el.func() == heading and el.level > numbering-depth {
      link(el.location(), box[#el.supplement~#emph(el.body)])
    } else {
      // Other references as usual.
      it
    }
  }

  body
}

#let continue-page-counter-from(label, shift: none) = {
  // shift: if it's broken don't fret - just fix it. Life is more than LaTeX or Typst
  context {
    let i = {
      if shift != none {
        shift
      } else {
        -int(calc.odd(here().page()))
      }
    }
    let toc-end = query(label)
    let restart-at = {
      if toc-end.len() == 0 {
        1
      } else { 
        toc-end.first().location().page() } 
      }
    // locate can only return content, therefore update the page counter here instead
    counter(page).update(restart-at + i)
  }
}
