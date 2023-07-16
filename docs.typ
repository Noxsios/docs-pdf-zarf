#set document(title: "Zarf CLI Docs", author: "Harry 'razzle' Randazzo")
#set page(
  margin: (x: 0.5in, y: 0.5in),
)
#set text(
  font: "Noto Sans",
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

#outline(depth:1, title: "Zarf CLI Docs")

#pagebreak()

#let paths = read("zarf-docs/ls.txt").split("\n")
#let cmds = paths.map(yaml)

#for cmd in cmds [
    #let keys = cmd.keys()

    // #keys

    = #raw(cmd.name, block: false, lang:"sh") 

    #cmd.synopsis

    #if keys.contains("description") or keys.contains("usage") [
        == Synopsis

        #if keys.contains("description") [
            #cmd.description.trim()
        ]

        #if keys.contains("usage") [
            #raw(cmd.usage, block: true, lang:"sh")
        ]
    ]

    == Options

    #for option in cmd.options [
        #let keys = option.keys()

        #let usage = ""

        #if keys.contains("default_value") and keys.contains("usage") {
            usage = option.usage.trim() + " (default: " + option.default_value + ")"
        } else if keys.contains("usage") {
            usage = option.usage.trim()
        } else {
            usage = ""
        }

        #if keys.contains("shorthand") [
            - \- #option.shorthand, --#option.name \ #raw(usage, block: false, lang:"sh")
        ] else [
            #if keys.contains("usage") [
                - \--#option.name \ #raw(usage, block: false, lang:"sh")
            ] else [
                - \--#option.name
            ]
        ]

        // #option
    ]

    // == SEE ALSO

    // #cmd.see_also

    #pagebreak()
]

