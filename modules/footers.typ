
#let get-pagination(pagination-align) = {
  assert(pagination-align in ("outside", "inside", left, right, center))
  if pagination-align in ("outside", "inside") {
    let (a, b) = if pagination-align == "outside" { (left, right) } else { (right, left) }
    context align(if calc.even(here().page()) { a } else { b }, 
      [#counter(page).display(here().page-numbering())])
  } else {
    context align(pagination-align, [#counter(page).display(here().page-numbering())])
  }
}