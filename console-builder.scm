;; Console Builder
(use-modules (oop goops))
(use-modules (pharo-builder core oscommand))
(use-modules (pharo-builder core artifacts))
(use-modules (pharo-builder core vm))
(use-modules (pharo-builder core project))
(use-modules (pharo-builder conf-builder))
(use-modules (ice-9 readline))

(activate-readline)

(display "Current Working Directory: ")
(newline)
(display cwd)
(newline)
(mk-mc-package-cache)
(display "MC Package Cache Directory: ")
(newline)
(display mc-package-cache)
(newline)

(define (main args)
  (display args)
  (newline)
)

