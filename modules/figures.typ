#let default-2D-align = top + right
#let as-ratio(number) = {
  eval(str(number * 100) + "%")
}

#let unravel(funcs, poss, nameds, body) = {
  assert(funcs.len() == poss.len() and poss.len() == nameds.len(), message: "whoops")
  if funcs.len() == 0 {
    return body
  }
  let (f, p, n) = (funcs.pop(), poss.pop(), nameds.pop())
  unravel(funcs, poss, nameds, f(..p, ..n)[#body])
}

#let floaty(thing, args) = {
  if args != none {
    place(
      ..args, 
      thing
    )
  } else {
    thing
  }       
}

#let caption-styles(
  supplement-position: "left", 
  container: ((box,), ((),), ((:),)),
  body) = {
    assert(supplement-position in ("left", "inline", "above"))
  // left-aligned, not wider than the outer scope.
  show figure.caption: it => {
    let style(body) = {
      set text(size: 10pt)
      set par(leading: .6em)
      set align(left + top)
      body
    }
    if supplement-position == "inline" {
      unravel(
        ..container
      )[#show: style; *#it.supplement #it.counter.display(it.numbering):* #it.body]
    } else {
      unravel(..container)[
        #show: style
        #let named = {
          if supplement-position == "left" {
            (columns: (auto, 1fr), gutter: 4pt)
          } else {
            assert(supplement-position == "above")
            (rows: (auto, auto), gutter: 1em)
          }
        }
        #grid(
        ..named,
        [*#it.supplement #it.counter.display(it.numbering):*], 
        it.body)
      ]
    }
  }

  body
}

#let expand-to-2D-alignment(ali, default) = {
  assert(type(ali) == alignment)
  let ali = {
    if ali.y == none {
      default.y
    } else {
      ali.y
    }
  } + {
    if ali.x == none {
      default.x
    } else {
      ali.x
    }
  }
  return ali
}

#let wrap-fig(
  fig: none, 
  width: none, 
  caption: [], 
  label: none,
  position: default-2D-align, 
  gutter: 1em, 
  supplement-position: "left",
  placement: none, 
  ..named,
  body
  ) = {
    // we're actually building a two-column grid for the figure and the text beside it
    let ali = expand-to-2D-alignment(position, default-2D-align)

    assert(ali.x != center, message: "That's a bit weird! Can't center a wrapfig")

    let col-widths = (auto, width)
    let columns = ([#body], [
      // if the caption style is supposed to be changed, it must be re-applied in the current scope
      #show: caption-styles.with(supplement-position: supplement-position)
      #figure(
        fig,
        caption: caption,
        ..named,
      ) #label
    ]) 

    // if the figure goes to the left, flip the columns
    if ali.x == left {
      col-widths = col-widths.rev()
      columns = columns.rev()
    }
    
    set align(ali.y) // this sets the vertical alignment between figure and text. 
    floaty(grid(
      columns: col-widths, 
      gutter: gutter,
      ..columns
      ), placement)
}

#let side-cap-fig(
  fig: none, 
  fig-width: none,
  caption-width: none, 
  caption-pos: default-2D-align,
  caption: [], 
  label: none,
  gutter: 1em, 
  supplement-position: "left",
  placement: none,
  ..args,
  ) = {
    // move and scale the caption by *styling* it!

    let cap-width = {
      let t = type(caption-width) 
      if t == ratio {
        // re-scale the caption-width when it is a ratio (i.e. in %) so that it applies to the width of the figure parent - not the image!
        as-ratio(caption-width / fig-width)
      } else if t == fraction {
        if type(fig-width) == fraction {
          // both widths in fr
          as-ratio(caption-width / fig-width)
        } else {
          // only one width in fr => make it full-width
          as-ratio((100% - fig-width) / fig-width) - gutter
        }
        
      } else if t == relative {
        // a relative length like "40% + 2em". 
        // keep the 2em and re
        caption-width.length + eval(str(caption-width.ratio / fig-width * 100) + "%")
      } else {
        caption-width
      }
    }
 
    let ali = expand-to-2D-alignment(caption-pos, default-2D-align)
    // calculate the horizontal movement
    let dx = (cap-width + gutter) * {
      if ali.x == right {
        1
      } else {
        -1
      }
    }
    // apply the move+width+style
    show: caption-styles.with(
      supplement-position: supplement-position,
      container: (
        (place, box), 
        ((ali,), ()), 
        ((dx: dx), (width: cap-width)))
    )

    // actually this is going to be a grid again
    let columns = (
      [#figure(
          fig,
          caption: caption,
          ..args.named(),
        ) #label
      ], [] // the second column is not really necessary
    )
    // the original, user-defined caption width defines the column width!
    let col-widths = (fig-width, caption-width)
    // flip if the caption goes on the left
    if ali.x == left {
      col-widths = col-widths.rev()
      columns = columns.rev()
    }

    floaty(grid(
      columns: col-widths, 
      gutter: gutter,
      ..columns
      ), placement)
}