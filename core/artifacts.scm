;;; artifacts.scm --- A repository of artifacts

;;; Commentary:
;; 


;;; History:
;; 

;;; Code:
(define-module (pharo-builder core artifacts)
  #:use-module (oop goops)
  #:use-module (ice-9 format)
  #:use-module (pharo-builder core oscommand)
  #:export (
	    build-repo
	    remove
	    download
	    unzip
	    download-all
	    add-artifact
	    <artifact>
	    <artifacts-repository>
	    add-all
	    name
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

(define-method (write (self <artifact>) port)
  (define fmt 
    "artifact ~S download from ~% ~S ~% to directory ~S ~%")
  (display (format #f
		   fmt
		   (name self)
		   (download-URL self)
		   (directory-name self)) port)
)

(define-method (base-path (self <artifact>))
  (path-join (directory-name (repository self)) 
	     (directory-name self))
)

(define-method (full-path (self <artifact>))
  (path-join (base-path self) (filename self))
)

(define-method (download (self <artifact>))
  "download URL-filename to filename.
   curl --insecure --location --output filename URL-filename."
  (mk-directory (base-path self))
  (let* (
	 (cmd (list "curl --insecure --location --output" 
		    (full-path self) 
		    (download-URL self)))
	 )
    (call-command-list cmd))
)

(define-method (unzip (self <artifact>) to-directory)
  "unzip artifact filename to directory."
  (let* (
	 (cmd  (list "unzip -q -j" (full-path self)
		     "*.image *.changes -d" to-directory))
	 )
         (call-command-list cmd)
     )
)

;;
;; an Artifacts Repository
;;
(define-class <artifacts-repository> ()
  (artifacts #:accessor artifacts
	      #:init-value '())
  (directory-name #:init-value ""
		  #:accessor directory-name
		  #:init-keyword #:directory-name)
)

(define-method (write (self <artifacts-repository>) port)
  (define fmt
    "Repository at directory ~S ~% with artifacts: ~% ~S ~% ")
  (display (format #f
		   fmt
		   (directory-name self)
		   (artifacts self)) port)
)

(define-method (add-artifact (self <artifacts-repository>) artifact)
  (set! (repository artifact) self)
  (set! (artifacts self) (append (artifacts self) (list artifact)))
)

(define-method (add-all (self <artifacts-repository>) artifact-list)
  (if (not (null? artifact-list))
      (begin
	(add-artifact self (car artifact-list))
	(add-all self (cdr artifact-list)))
   )
)

(define-method (download-all (self <artifacts-repository>))
  (map download (artifacts self))
)

(define-method (build-repo (self <artifacts-repository>))
  (mk-directory (directory-name self))
  (download-all self)
)

(define-method (remove (self <artifacts-repository>))
  (rm-directory (directory-name self))
)

;;; artifacts.scm ends here
