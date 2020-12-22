lines <- unlist(strsplit(system("git ls-files -- ':!:*.txt' ':!:*.png' ':!:index.r' | xargs wc -l", intern = TRUE), "\n"))
filetypes <- list()

for (line in 1:length(lines)) {
  matches <- sub('\\s+(\\d+).+?\\.(.+)', "\\1 \\2 \\3", lines[line], perl = TRUE)
  pieces <- unlist(strsplit(trimws(matches), " "))

  if (pieces[2] %in% list('md', 'gitignore', 'ruby-version', 'nvmrc', 'total')) {
    next
  }

  if (pieces[2] %in% names(filetypes)) {
    filetypes[pieces[2]] <- as.numeric(filetypes[pieces[2]]) + as.numeric(pieces[1])
  } else {
    filetypes[pieces[2]] <- as.numeric(pieces[1])
  }
}

png("stats.png", width = 1280, height = 960, bg = "white", pointsize = 24)
max <- (ceiling(range(unlist(filetypes))[2] / 50)) * 50
total <- sum(unlist(filetypes))
orderedtypes <- filetypes[order(unlist(filetypes), decreasing = TRUE)]
barplot(unlist(orderedtypes), main = "Lines by Filetype", col = "dodgerblue3", horiz = TRUE, las = 2, xlim = c(0, max))
dev.off()
