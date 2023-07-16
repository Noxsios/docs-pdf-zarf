#set document(title: "Zarf Command Cheatsheet", author: "Harry 'razzle' Randazzo")
#set page(
  margin: (x: 0.5in, y: 0.5in),
  flipped: true
)
#set text(
  font: "Fira Sans",
  size: 12pt,
  slashed-zero: true,
)
// Display inline code in a small box
// that retains the correct baseline.
#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

// Display block code in a larger block
// with more padding.
#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: 8pt,
  radius: 4pt,
)

#{
let paths = read("zarf-docs/ls.txt").split("\n")
let cmds = paths.map(yaml)

let formatrow(r) = {
  if r.keys().contains("usage") == false {
    (raw(r.name, block: true, lang:"sh"), r.synopsis)
  } else {
    (raw(r.usage.replace("[flags]", ""), block: true, lang:"sh"), r.synopsis)  
  }
}

table(
  columns: (40%, 60%),
  inset: 8pt,
  align: horizon,

  [**Command**],[**Explanation**],
  ..cmds.map(formatrow).flatten()
)
}


