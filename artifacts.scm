(define-module (pharo-builder artifacts)
  #:use-module (oop goops) 
  #:use-module (ice-9 format)
  #:use-module ((pharo-builder oscommand)
		:select ((join . path-join) 
			 cwd call-command-list mk-directory rm-directory))
  #:export (<Artifact>  download)
  #:export (<ArtifactsRepository> build remove download-all add-artifact)
)

;;
;; basic download URL-filename to filename
;; curl --location --output filename URL-filename
;;
(define (basic-download URL-filename to-filename)
  (define cmd 
    (list "curl" "--location" "--output" to-filename URL-filename))
  (call-command-list cmd)
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

(define-method (base-path (obj <Artifact>) to-directory)
  (path-join to-directory (directory-name obj))
)

(define-method (full-path (obj <Artifact>) to-directory)
  (path-join (base-path obj to-directory) (filename obj))
)

(define-method (download (obj <Artifact>) to-directory)
  (mk-directory (base-path obj to-directory))
  (basic-download (download-URL obj) (full-path obj to-directory))
)


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
  (define fmt "Repository at directory ~S ~% with artifacts: ~S ~% ")
  (display (format #f 
		   fmt
		   (directory-name obj)
		   (artifacts obj)) port)
)

(define-method (add-artifact (obj <ArtifactsRepository>) artifact)
  (set! (artifacts obj) (append (artifacts obj) (list artifact)))
)

(define-method (download-all (obj <ArtifactsRepository>) artifact-list)
  (if (not (null? artifact-list))
      (begin
      (download (car artifact-list) (directory-name obj))
      (download-all obj (cdr artifact-list)))
   )
)

(define-method (build (obj <ArtifactsRepository>))
  (mk-directory (directory-name obj))
  (download-all obj (artifacts obj))
)

(define-method (remove (obj <ArtifactsRepository>))
  (rm-directory (directory-name obj))
)






