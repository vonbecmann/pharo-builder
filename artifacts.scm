;;; artifacts.scm --- A repository of artifacts

;;; Commentary:
;; 


;;; History:
;; 

;;; Code:
(define-module (pharo-builder artifacts)
  #:use-module (oop goops)
  #:use-module (ice-9 format)
  #:use-module (pharo-builder oscommand)
  #:export (
	    build
	    remove
	    download
	    unzip
	    download-all
	    add-artifact
	    repository
	    <artifact>
	    <artifacts-repository>
	    add-all
	    )
)

;;;
;;; an Artifact
;;;
(define-class <artifact> ()
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

(define-method (write (obj <artifact>) port)
  (define fmt "artifact ~S download from ~% ~S ~% to directory ~S ~%")
  (display (format #f
		   fmt
		   (name obj)
		   (download-URL obj)
		   (directory-name obj)) port)
)

(define-method (base-path (obj <artifact>))
  (path-join (directory-name (repository obj)) (directory-name obj))
)

(define-method (full-path (obj <artifact>))
  (path-join (base-path obj) (filename obj))
)

(define-method (download (obj <artifact>))
  "download URL-filename to filename.
   curl --insecure --location --output filename URL-filename."
  (mk-directory (base-path obj))
  (let* ((cmd (list "curl" "--insecure" "--location"
		    "--output" (full-path obj) (download-URL obj))))
    (call-command-list cmd))
)

(define-method (unzip (obj <artifact>) to-directory)
  "unzip artifact filename to directory."
  (let* ((cmd  (list "unzip" "-j" (full-path obj)
		     "*.image" "*.changes" "-d" to-directory)))
         (call-command-list cmd)
     )
)

;;
;; Artifacts Repository
;;
(define-class <artifacts-repository> ()
  (artifacts #:accessor artifacts
	      #:init-value '())
  (directory-name #:init-value ""
		  #:accessor directory-name
		  #:init-keyword #:directory-name)
)

(define-method (write (obj <artifacts-repository>) port)
  (define fmt
    "Repository at directory ~S ~% with artifacts: ~% ~S ~% ")
  (display (format #f
		   fmt
		   (directory-name obj)
		   (artifacts obj)) port)
)

(define-method (add-artifact (obj <artifacts-repository>) artifact)
  (set! (repository artifact) obj)
  (set! (artifacts obj) (append (artifacts obj) (list artifact)))
)

(define-method (add-all (obj <artifacts-repository>) artifact-list)
  (if (not (null? artifact-list))
      (begin
	(add-artifact obj (car artifact-list))
	(add-all obj (cdr artifact-list)))
   )
)

(define-method (download-all (obj <artifacts-repository>))
  (map download (artifacts obj))
)

(define-method (build (obj <artifacts-repository>))
  (mk-directory (directory-name obj))
  (download-all obj)
)

(define-method (remove (obj <artifacts-repository>))
  (rm-directory (directory-name obj))
)

;;; artifacts.scm ends here
