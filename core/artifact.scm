;;; artifact.scm --- A pharo artifact

;;; Commentary:
;; 


;;; History:
;; 

;;; Code:
(define-module (pharo-builder core artifact)
  #:use-module (ice-9 format)
  #:use-module (pharo-builder core oscommand)
  #:use-module ((pharo-builder core repository)
		:renamer (symbol-prefix-proc 'repository:))
  #:export (
	    download
	    unzip
	    make-artifact
	    name
	    set-repository
	    )
)

;;;
;;; an Artifact
;;;
(define (print self port)
  (define fmt
    "artifact ~S download from ~% ~S ~% to directory ~S ~%")
  (display (format #f
		   fmt
		   (name self)
		   (download-url self)
		   (directory-name self)) port)
)

(define fields '(name directory-name download-url filename repository))

(define artifact 
  (make-record-type "artifact"
		    fields
		    print)
)

(define make-artifact
  (record-constructor artifact 
		      fields
		      )
)

(define name
  (record-accessor artifact 'name)
)

(define directory-name
  (record-accessor artifact 'directory-name)
)

(define download-url
  (record-accessor artifact 'download-url)
)

(define filename
  (record-accessor artifact 'filename)
)

(define repository
  (record-accessor artifact 'repository)
)

(define set-repository
  (record-modifier artifact 'repository)
)

(define (base-path self)
  (path-join (repository:directory-name (repository self))
	     (directory-name self))
)

(define (full-path self)
  (path-join (base-path self) (filename self))
)

(define (download self)
  "download URL-filename to filename.
   curl --insecure --location --output filename URL-filename."
  (mk-directory (base-path self))
  (let* (
	 (cmd (list "curl --insecure --location --output"
		    (full-path self)
		    (download-url self)))
	 )
    (call-command-list cmd))
)

(define (unzip self to-directory)
  "unzip artifact filename to directory."
  (let* (
	 (cmd  (list "unzip -q -j" (full-path self)
		     "*.image *.changes -d" to-directory))
	 )
         (call-command-list cmd)
     )
)

;;; artifact.scm ends here
