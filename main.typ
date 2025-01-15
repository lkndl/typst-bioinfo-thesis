
#import "modules/template.typ": *
#import "chapters/0_abstract.typ": de_abstract, en_abstract

 #show: doc.with(
  author: "Rosalind Franklinson",
  lang: "en",
  title: [
    Quantum~Algorithms for~Bioinformatic~Applications: Navigating~the~DNA~Multiverse
    ], 
  short-title: [quantum bioinfo],
  translated-title: [
    Quantenalgorithmik für bioinformatische~Anwendungen: Unterwegs~im #box[DNA-Multiversum]
    ],
  date: datetime(
    year: 2024,
    month: 01,
    day: 15,
  ),
  degree: "bachelor",
  german-abstract: de_abstract,
  english-abstract: en_abstract,
  supervisors: ([Prof. Dr. Ada Codeheimer, Chair~of Quantum~Computing and~Computational~Biology],),
  advisors: ([Dr. Alan Bitwise], [Zoe Debugsmith, M.Sc.]),
  flavour: "info",
  pagination-align: "outside",
  bibliography-file: "../stuff.bib",
 )

// Include an entire chapter like this:
//#include "chapters/1_intro.typ"

// But the rest of this example just goes right here:
= intro
=== Motivation
As xkcd wisely reminds us, "There's nothing quite so beautiful as watching someone code in a language they're fluent in." In this linguistic dance between quantum bits and biological sequences, we strive to achieve fluency in the unique syntax that intertwines the principles of quantum computation with the complex language of life. 

=== Background and related work <related>
Drawing inspiration from xkcd #link("https://xkcd.com/378/", "#378"), where "Python" is the programming language of choice for researchers plotting world domination, our research aligns itself with the power and elegance of Pythonic quantum algorithms. The literature review explores the quantum landscape, guiding us through the footsteps of pioneers like Schrödinger and Turing, who, if xkcd is to be believed (#795), may have shared a cup of coffee in a parallel computational universe.
// #lorem(600)
==== some works <works>
#lorem(10)
==== other works <others>
#lorem(10)

=== Outline
In the spirit of xkcd #327, we adopt a robust methodology akin to the "Exploits of a Mom," ensuring the security and integrity of our quantum bioinformatics framework. Through the careful implementation of quantum gates and bioinformatic algorithms, we navigate the vast space of possibilities, akin to the legendary "Lorenz Attractor" (#137).


= materials & methods
some materials are important: food, WiFi, entertainment, ...

== differentiating material materials from immaterial methods
That's important, but I have no idea how to do it. Maybe @tv-problems can help us a tiny bit already?
#figure(
  image("/images/tv_problems.png"),
  placement: bottom,
  gap: 1em,
  caption: figure.caption(position: top, flex-caption([Example full-width image, caption above], [. Most people do not have computer science degrees, and they would probably count as more _method-y_ than _material-y_?])),
) <tv-problems>

Also: #lorem(200)

#figure(
  image("/images/dingos.jpg", width: 100%),
  placement: auto,
  gap: 1em,
  caption: flex-caption([Another example full-width image], [. Consumers are generally unaware that toddlers fall right into the #box(["tasty food"]) category for dingos; with anecdotal evidence suggesting that only individuals suffering from excessive slobbering ever successfully repelled the fanged predators. As tasty food, toddlers are clearly a *material*, _not_ a method.]),
) <dingos>

=== method A
Link to an unnumbered section: @related is far up there, as is @others. This is a little bit of math and a link to @results, which you can find on #ref-page(<results>): #v(1fr)

#set math.equation(numbering: "(1)")

$
"HVAL" = "PIDE" - cases(
  100 & forall L <= 11,
  480 dot L^(-0.32[1+exp(-L\/1000)])#h(1em) & forall L <= 450,
  19.5 & forall L > 450
)
$ <ratio>


With @ratio, we get:
$ F_n = floor(1 / sqrt(5) phi.alt^n) $




#wrap-fig(
  fig: align(right, image("images/laser_pointer_more_power.png", width: 60%)), 
  width: 40%,
  supplement-position: "above",
  gap: -6mm, // this is just passed through to `figure`
  position: left + bottom,
  caption: flex-caption([Example wrapped figure], [. In fact this is a side-by-side grid of text and this image. Actually a lot easier than in LaTeX! Also flexing the *@more-power* label is in a different position now.]), 
  label: <more-power>,
  [
    === method B
    This world is super chaotic! And the quantum realm isn't any better: #citeprose(<May1976>) found this already (and we're quoting them a bit like `citetext` here). But by now we are lucky to have #ibm[ColabFold] @Mirdita2022 and in combination with some more power (see @more-power), we can go far~-- for an example look no further than at #citeprose(<Bryant2022>). #lorem(10)
  ],
  )

#lorem(100)


== materials <materials>

- Food
- WiFI
- coffee
#lorem(200)

#side-cap-fig(
  fig: image("/images/dreams.png"),
  fig-width: 60%,
  caption-width: 40% - 1em, // because gutter: 1em,
  caption-pos: bottom + left,
  caption: flex-caption([Side caption example], [. Look it's floating! In addition to `caption-pos` and two `-width`s, you can pass `placement` to `side-cap-fig`. But not all combinations work -- have a look at #{show link: underline; link("https://typst.app/docs/reference/layout/place/", [the docs])} if the figure crashes into text or the compiler does. The underlining show rule is scoped, see? Also #underline[underlined] text; un-underlined #link("https://youtu.be/dQw4w9WgXcQ?feature=shared&t=42", [link]).]),
  label: <floaty>,
  supplement-position: "inline",
  placement: arguments(bottom + right, float: true),
)

= results <results>
Quantum entanglement meets genomic entanglement as our algorithms traverse the DNA multiverse. Much like the unpredictable nature of xkcd's "Random Number" (#221), the results paint a colorful tapestry of possibilities, offering glimpses into the potential of quantum-enhanced bioinformatics applications. 

#align(center, box(width: 85%, [
  // helper function for table alignment
  #let aligner(column, row) = {
    if row == 0 {
      if column == 0 or column == 2 {
        top + left
      } else {
        top + right
      }
    } else if column > 2 {
      bottom + right
    } else {
      bottom + left
    }
  }
  #set text(hyphenate: false)
  #figure(
    kind: table,
    table(
      stroke: none,
      inset: (x: 6pt + 16pt, y: 6pt),
      columns: 6, // or just a number
      rows: (21pt, 23pt, auto, auto, 20pt, auto, auto),
      align: (column, row) => aligner(column, row),
      "size", "source", "split", "spp.", "proteins", "PPIs",
      table.hline(),

      "full", `APID`, "train", $18$, $39393$, $143171$,
      "", "", "validate", $10$, $1750$, $2279$,
      "", `HuRI`, "test", $1$, $4458$, $19106$,
      "small", `APID`, "train", $8$, $8565$, $15586$,
      "", "", "validate", $7$, $818$, $1184$,
      "", `HuRI`, "test", $1$, $430$, $666$,
    ),
    caption: flex-caption([PPI data in the sets], [; disregarding negatives and extra compensation proteins. Finished sets are about twice or $11 times$ the size.])
  )

])) <mytable>
