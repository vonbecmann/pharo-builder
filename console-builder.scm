;; Console Builder
(use-modules (oop goops))
(use-modules (pharo-builder oscommand))
(use-modules (pharo-builder artifacts))
(use-modules (pharo-builder vm))
(use-modules (pharo-builder environment))
(use-modules (pharo-builder conf))
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
(display pharo-repository)
(newline)

;;;
;;; a simple project
;;;
;;;(define simpleProject 
;;;  (project "/home/bcontreras/simpleP" default-vm pharo-core))
;;;  
(define simpleP 
  (create-project "/home/vonbecmann/simpleP" default-vm pharo-core))
