(use-modules (oop goops))
(use-modules (ice-9 readline))
(use-modules ((pharo-builder oscommand)
		:select ((join . path-join) cwd)))
(use-modules (pharo-builder artifacts))
(use-modules (pharo-builder environment))
(use-modules (ice-9 readline))

(activate-readline)

;;
;; Configuration
;;


;;
;; Artifacts
;;
(define PharoCore 
  (make-artifact 
       "PharoCore"
       "core" 
       "http://www.pharo-project.org/pharo-download/stable-core")
)
(define PharoUnstableCore 
  (make-artifact 
        "PharoUnstableCore"
	"unstable-core" 
	"http://www.pharo-project.org/pharo-download/unstable-core")
)
(define PharoDev 
  (make-artifact 
        "PharoDev"
	"dev" 
	"http://www.pharo-project.org/pharo-download/stable")
)

;;
;; Pharo Artifacts Repository
;;
(define pharo-repository 
  (make-repository (path-join cwd ".pharo-artifacts")
		   (list PharoCore PharoDev PharoUnstableCore))
)
(display pharo-repository)
(newline)

