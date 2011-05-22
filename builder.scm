(use-modules (oop goops))
(use-modules (ice-9 readline))
(use-modules ((pharo-builder oscommand)
		:select ((join . path-join) cwd)))
(use-modules (pharo-builder artifacts))
(use-modules (pharo-builder environment))
(use-modules (pharo-builder conf))
(use-modules (ice-9 readline))

(activate-readline)

;;
;; Configuration
;;


;;
;; Artifacts
;;
(define pharo-core 
  (make-artifact 
       "pharo-core"
       "core" 
       "http://www.pharo-project.org/pharo-download/stable-core")
)
(define pharo-unstable-core 
  (make-artifact 
        "pharo-unstable-core"
	"unstable-core" 
	"http://www.pharo-project.org/pharo-download/unstable-core")
)
(define pharo-dev 
  (make-artifact 
        "pharo-dev"
	"dev" 
	"http://www.pharo-project.org/pharo-download/stable")
)

;;
;; Pharo Artifacts Repository
;;
(define pharo-repository 
  (make-repository (path-join cwd ".pharo-artifacts")
		   (list pharo-core pharo-dev pharo-unstable-core))
)
(display pharo-repository)
(newline)

