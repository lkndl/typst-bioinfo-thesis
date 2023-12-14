
#let get-pagination(pagination-align) = {
  assert(pagination-align in ("outside", "inside", left, right, center))
  if pagination-align in ("outside", "inside") {
    let (a, b) = if pagination-align == "outside" { (left, right) } else { (right, left) }
    locate(loc => align(
      if calc.even(loc.page()) { a } else { b },
      [#counter(page).display(loc.page-numbering())]))
  } else {
    locate(loc => align(pagination-align, [#counter(page).display(loc.page-numbering())]))
  }
}