(use-modules (oop goops))
(use-modules ((pharo-builder oscommand)
		:select ((join . path-join) cwd)))
(use-modules (pharo-builder artifacts))
(use-modules (ice-9 readline))

(activate-readline)

;;
;; Configuration
;;


;;
;; Artifacts
;;
(define PharoCore 
  (make <Artifact> 
    #:name "PharoCore"
    #:directory-name "core" 
    #:download-from "http://www.pharo-project.org/pharo-download/stable-core")
)
(define PharoUnstableCore 
  (make <Artifact> 
    #:name "PharoUnstableCore"
    #:directory-name "unstable-core" 
    #:download-from "http://www.pharo-project.org/pharo-download/unstable-core")
)
(define PharoDev 
  (make <Artifact> 
    #:name "PharoDev"
    #:directory-name "dev" 
    #:download-from "http://www.pharo-project.org/pharo-download/stable")
)

;;
;; Pharo Artifacts Repository
;;
(define artifacts-repo 
  (path-join cwd ".pharo-artifacts")
)
(display artifacts-repo)
(newline)


(define pharo-repository 
  (make-repository artifacts-repo
		   (list PharoCore PharoDev PharoUnstableCore)
		   )
)

