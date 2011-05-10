(use-modules (oop goops))
(use-modules ((pharo-builder oscommand)
		:select ((join . path-join) cwd)))
(use-modules (pharo-builder artifacts))



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
;; Artifacts Repository
;;
(define artifacts-repo 
  (path-join cwd ".artifacts")
)
(display artifacts-repo)
(newline)

(define repository (make <ArtifactsRepository>
		     #:directory-name artifacts-repo)
)
(add-artifact repository PharoCore)
(add-artifact repository PharoUnstableCore)
(add-artifact repository PharoDev)

