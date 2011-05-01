(define-module (pharo-builder artifacts)
  #:use-module (oop goops) 
  #:use-module (ice-9 format)
  #:export (repository PharoCore PharoDev PharoUnstableCore full-path download)
)
(use-modules ((pharo-builder oscommand)
	      :select ((join . path-join) 
		       (download . basic-download)
		       artifacts-repo))
)

;;
;; an Artifact
;;
(define-class <Artifact> ()
  (name #:accessor name 
	#:init-keyword #:name)
  (directory-name #:accessor directory-name
		  #:init-keyword #:directory-name)
  (download-URL #:accessor download-URL
		#:init-keyword #:download-from)
  (filename #:init-value "latest.zip"
	    #:accessor filename)
)

(define-method (write (obj <Artifact>) port)
  (define fmt "artifact ~S download from ~% ~S ~% to directory ~S ~%")
  (display (format #f 
		   fmt
		   (name obj) 
		   (download-URL obj) 
		   (directory-name obj)) port)
)

(define-method (full-path (obj <Artifact>))
  (path-join artifacts-repo (path-join (name obj) (filename obj)))
)

(define-method (download (obj <Artifact>))
  (basic-download (download-URL obj) (full-path obj))
)

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
(define-class <ArtifactsRepository> ()
  (pharo-core #:init-value PharoCore
	    #:accessor pharo-core)
  (pharo-dev #:init-value PharoDev
	    #:accessor pharo-dev)
  (pharo-unstable-core #:init-value PharoUnstableCore
	    #:accessor pharo-unstable-core)
)
(define repository (make <ArtifactsRepository>))
