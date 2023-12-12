
#let get-headers() = {
  // auf den linken Seiten, auf denen kein neues Level 1 Kapitel eröffnet wird, zeige das letzte Level 1 Kapitel
  // auf den rechten Seiten zeige das letzte Level 2 Kapitel
  locate(loc => {
    let current = loc.page()
    let toc-page = query(<toc>, loc)
    if toc-page.len() == 0 {
      return
    }
    toc-page = toc-page.first().location().page()
    if current < toc-page {
      return
    }
    // only for pages at or below the table-of-contents

    let matches = query(heading.where(level: 1), loc)
    let has-level-1 = matches.any(m =>
      m.location().page() == current
    )
    if has-level-1 {
      return
    }
    //only pages without any new Level 1 chapter beginning
    
    let l1s = heading.where(level: 1)
    let chapter = query(l1s.before(loc), loc).last()
    let chaploc = chapter.location()
    let next_chap = query(l1s.after(loc), loc)
    next_chap = if next_chap.len() > 0 { next_chap.first() } else { none }

    let find(l) = {
      // find the current and the next chapter 
      let lh = heading.where(level: l)
      let m = lh.before(loc)
      if chapter != none {
        m = m.and(lh.after(chaploc))
      } 
      if next_chap != none {
        m = m.and(lh.before(next_chap.location()))
      } 
      m = query(m, loc)
      if l >= 4 {
        return (none, none)
      } else if m.len() == 0 {
        return find(l + 1)
      } else {
        return (m.last(), l)
      }
    }   

    let label_heading(_heading, alignment: left, level: 2) = {
      if _heading.numbering == none {
        align(alignment, [_#_heading.body _])
      } else if level >= 3 {
        align(alignment, [_#_heading.body _])
      } else {
        let _heading_num = numbering(_heading.numbering, ..counter(heading).at(_heading.location()))
        align(alignment, [_#_heading_num #_heading.body _])
      }
    }

    if calc.even(loc.page()){
      // left-hand pages 
      label_heading(chapter)
      return
    } 
    // right-hand pages      
    let (section, l) = find(2)
    //let section = find-section(chapter, 2)
    if section == none {
      return
    }
    label_heading(section, alignment: right, level: l)
  })
}