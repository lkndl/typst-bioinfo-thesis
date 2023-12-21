

#let header-styles(body) = {
  // This styles the headers
  show selector(<all-header>): it => {
    align(center, emph(it))
  }
  show selector(<left-header>): it => {
    align(left, emph(it))
  }
  show selector(<right-header>): it => {
    align(right, emph(it))
  }
  body
}

#let set-headers(
  // This is just a utility function to make the template.typ cleaner, and it attaches the labels used for styling
  all: none, odd: none, even: none) = {
  locate(loc => {
    if all != none {
      assert(odd == none and even == none)
      [#all <all-header>]
    } else if calc.even(loc.page()){
      [#even <left-header>]
    } else {
      [#odd <right-header>]
    }
  })
} 

#let get-open-section(
  level: 1, skip-level-1: true, descend-to-level: none
  ) = {
  // if there are no headings with the given level in the current chapter but lower-level ones, use those
  locate(loc => {

    if query(heading.where(level: 1), loc).any(
      m => m.location().page() == loc.page()
    ) and skip-level-1 {
      // no header on pages with a Level 1 heading = new chapter beginning
      return
    }

    let loc-neighbours(things) = {
      let open = query(things.before(loc), loc).at(-1, default: none)
      let next = query(things.after(loc), loc).at(0, default: none)
      return (open, next)
    }

    let limit-query(above, below, things) = {
      if above != none {
        things = things.after(above.location())
      }
      if below != none {
        things = things.before(below.location())
      }
      things
    }

    // find recursion init args
    // headings that at least have the right level
    let level-headings = heading.where(level: level)
    // but do not go out of parent
    let outer = loc-neighbours(heading.where(level: level - 1))
    // throw some out
    level-headings = limit-query(..outer, level-headings)
    // find the current and the next chapter
    let (open, next) = loc-neighbours(level-headings)

    let find(l, open, next) = {
      // recurse into lower levels
      let lh = heading.where(level: l)
      let outer = loc-neighbours(heading.where(level: l - 1))
      lh = limit-query(..outer, lh)
      (open, next) = loc-neighbours(lh)
      if descend-to-level != none and l >= descend-to-level {
        return none
      } else if open == none and next == none {
        return find(l + 1, open, next)
      } else {
        return open
      }
    }   

    let section = find(level, open, next)
    if section == none {
      return none
    } 

    // a little formatting helper
    let number(it) = {
      if it.numbering == none {
        none
      } else {
        [#numbering(it.numbering, ..counter(heading).at(it.location())) ] // with space
      }
    }

    // actually generate the content
    number(section) + section.body
  })
}