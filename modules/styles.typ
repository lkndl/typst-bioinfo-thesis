
#let quantum = 8pt
#let page-num-width = 2em
#let space = 2.2cm
#let raw-style = (font: "IBM Plex Mono", size: 1.2em) // the default font size in the doc defines what 1em is, and this always looked a bit too small, therefore scale it

// use a state to manage whether the caption title or the full thing is displayed at different places in the do
// https://github.com/typst/typst/issues/1295#issuecomment-1853762154
#let in-outline = state("in-outline", false)

#let flex-caption(title, rest) = locate(loc => 
  if in-outline.at(loc) { title } else { title + rest }
)

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
#let ref-page(label, supplement: "page") = {
  locate(loc => {
    let match = query(label, loc)
    if match == none {
      panic()
    }
    match = match.first().location()
    link(match, box([#supplement #counter(page).at(match).first()]))
  })
}

#let empty-page() = {
  page([], header: [], footer: [])
}

// citation shorthand
#let citeprose(label) = cite(label, form: "prose")
#let citeauthor(label) = cite(label, form: "author")

// fix reference styles: level 1 headings are chapter, not Section
#let supplements(it, lang) = {
  if "level" not in it.fields() {
    return none
  } else if lang == "en" {
    // per default "Section", "Section", ...
    return ([chapter], [section], [subsection]).at(it.level - 1, default: [subsection])
  } else {
    // i just made these up:
    return ([Kapitel], [Abschnitt], [Absatz]).at(it.level - 1, default: [Absatz])
  }
}

#let headingspaced(it) = {
  block(above: 2 * space, below: space / 2, 
  [#v(space)#text(size: 20pt, it)])
}

#let heading-styles(lang, numbering-depth, body) = {
  // define the section numbering
  set heading(
      //numbering: "1.1",
      numbering: (..nums) => {
        let nums = nums.pos()
        if nums.len() <= numbering-depth {
          numbering("1.1", ..nums)
        }},
      outlined: true, 
      supplement: it => supplements(it, lang))
  
  // add space above chapters, later enforce a pagebreak
  show heading.where(level: 1): it => headingspaced(it)

  show heading.where(level: 2): it => [
    #block(above: 11mm, below: 6mm)[#it] ]

  // show heading.where(level: 3): it => [
  //   #block(above: 11mm, below: 6mm)[#it.body] ] // hide the numbering
  
  body
}

#let break-before-chapter(on: true, body) = {
  // turning this on and off is a fix until https://github.com/typst/typst/issues/2841 is resolved
  if on {
    show heading.where(level: 1): it => pagebreak(weak: true) + headingspaced(it)
  } else {
    show heading.where(level: 1): it => headingspaced(it)
  }

  body
}


#let continue-page-counter-from(label, shift: none) = {
  // shift: if it's broken don't fret - just fix it. Life is more than LaTeX or Typst
  locate(loc => {
    let i = {
      if shift != none {
        shift
      } else {
        -int(calc.odd(loc.page()))
      }
    }
    let toc-end = query(label, loc)
    let restart-at = {
      if toc-end.len() == 0 {
        1
      } else { 
        toc-end.first().location().page() } 
      }
    // locate can only return content, therefore update the page counter here instead
    counter(page).update(restart-at + i)
  })
}

// Pure typst re-implementation of flawed typst-native `repeat`
// by EpicEricEE from here: https://github.com/typst/typst/issues/2713#issue-2000578599
//
// Repeat the given content to fill the full space.
//
// Parameters:
// - gap: The gap between repeated items. (Default: none)
// - justify: Whether to increase the gap to justify the items. (Default: false)
//
// Returns: The repeated content.
#let typst-repeat(
  gap: none,
  justify: false,
  body
) = layout(size => style(styles => {
  let pt(length) = measure(h(length), styles).width
  let width = measure(body, styles).width
  let amount = calc.floor(pt(size.width + gap) / pt(width + gap))

  let gap = if not justify { gap } else {
    (size.width - amount * width) / (amount - 1)
  }
  
  let items = ((box(body),) * amount)
  if type(gap) == length and gap != 0pt {
    items = items.intersperse(h(gap))
  }

  items.join()
}))