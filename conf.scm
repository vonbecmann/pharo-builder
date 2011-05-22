;; Configuration for the builder
(define-module (pharo-builder conf)
  #:use-module (pharo-builder oscommand)
  #:use-module (pharo-builder artifacts)
  #:export (pharo-core pharo-dev
	    pharo-unstable-core pharo-repository)
)

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