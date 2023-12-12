
#let get-pagination(alignment) = {
  if alignment in ("outside", "inside") {
    let (a, b) = if alignment == "outside" { (left, right) } else { (right, left) }
    locate(loc => align(
      if calc.even(loc.page()) { a } else { b },
      [#counter(page).display(loc.page-numbering())]))
  } else {
    locate(loc => align(alignment, [#counter(page).display(loc.page-numbering())]))
  }
}