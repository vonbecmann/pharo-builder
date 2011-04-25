(define-module (pharo-builder artifacts)
  #:use-module ((oop goops) 
		(ice-9 format) 
		(pharo-builder oscommand))
  #:export (PharoCore)
)

(define-class <Artifact> ()
  (name #:accessor name 
	#:init-keyword #:name)
  (directory-name #:accessor directory-name
		  #:init-keyword #:directory-name)
  (download-URL #:accessor download-URL
		#:init-keyword #:download-from)
)
(define-method (write (obj <Artifact>) port)
  (display (format #f 
		   "artifact ~S download from ~% ~S ~% to directory ~S ~%"
		   (name obj) 
		   (download-URL obj) 
		   (directory-name obj)) port)
)

(define PharoCore 
  (make <Artifact> 
    #:name "PharoCore"
    #:directory-name "core" 
    #:download-from "http://www.pharo-project.org/pharo-download/stable-core")
)



