;;; artifacts.scm --- A repository of artifacts
;;; Code:
(define-module (pharo-builder artifacts)
  #:use-module (oop goops)
  #:use-module (ice-9 format)
  #:use-module (pharo-builder oscommand)
  #:export (build remove download unzip
	    download-all add-artifact
	    make-artifact make-repository
	    repository)
)

;;;
;;; an Artifact
;;;
(define-class <Artifact> ()
  (name #:accessor name
	#:init-keyword #:name)
  (directory-name #:accessor directory-name
		  #:init-keyword #:directory-name)
  (download-URL #:accessor download-URL
		#:init-keyword #:download-from)
  (filename #:init-value "latest.zip"
	    #:accessor filename)
  (repository #:accessor repository)
)

(define-method (write (obj <Artifact>) port)
  (define fmt "artifact ~S download from ~% ~S ~% to directory ~S ~%")
  (display (format #f
		   fmt
		   (name obj)
		   (download-URL obj)
		   (directory-name obj)) port)
)

(define-method (base-path (obj <Artifact>))
  (path-join (directory-name (repository obj)) (directory-name obj))
)

(define-method (full-path (obj <Artifact>))
  (path-join (base-path obj) (filename obj))
)

(define-method (download (obj <Artifact>))
  (mk-directory (base-path obj))
  (basic-download (download-URL obj) (full-path obj))
)

(define-method (unzip (obj <Artifact>) to-directory)
  (unzip-artifact (full-path obj) to-directory)
)

(define (make-artifact name directory-name download-URL)
  "make an artifact named NAME at DIRECTORY-NAME and
   download from DOWNLOAD-URL"
  (define new-artifact
          (make <Artifact>
	    #:name name 
	    #:directory-name directory-name
	    #:download-from download-URL))
  new-artifact)

;;
;; Artifacts Repository
;;
(define-class <ArtifactsRepository> ()
  (artifacts #:accessor artifacts
	      #:init-value '())
  (directory-name #:init-value ""
		  #:accessor directory-name
		  #:init-keyword #:directory-name)
)

(define-method (write (obj <ArtifactsRepository>) port)
  (define fmt
    "Repository at directory ~S ~% with artifacts: ~% ~S ~% ")
  (display (format #f
		   fmt
		   (directory-name obj)
		   (artifacts obj)) port)
)

(define-method (add-artifact (obj <ArtifactsRepository>) artifact)
  (set! (repository artifact) obj)
  (set! (artifacts obj) (append (artifacts obj) (list artifact)))
)

(define-method (add-all (obj <ArtifactsRepository>) artifact-list)
  (if (not (null? artifact-list))
      (begin
	(add-artifact obj (car artifact-list))
	(add-all obj (cdr artifact-list)))
   )
)

(define-method (download-all (obj <ArtifactsRepository>))
  (map download (artifacts obj))
)

(define-method (build (obj <ArtifactsRepository>))
  (mk-directory (directory-name obj))
  (download-all obj)
)

(define-method (remove (obj <ArtifactsRepository>))
  (rm-directory (directory-name obj))
)


(define (make-repository directory-name artifact-list)
  "make a repository with ARTIFACTS-LIST at a DIRECTORY-NAME"
  (define new-repository
    (make <ArtifactsRepository>
			   #:directory-name directory-name))
  (add-all new-repository artifact-list)
  new-repository
)
;;; artifacts.scm ends here
