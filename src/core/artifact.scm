;;; artifact.scm --- A pharo artifact

;;; Commentary:
;; An artifact


;;; History:
;; 

;;; Code:
(define-module (core artifact)
  #:use-module (ice-9 format)
  #:use-module (core oscommand)
  #:use-module ((core repository)
		:renamer (symbol-prefix-proc 'repository:))
  #:export (
	    download
	    unzip
	    make-artifact
	    artifact-name
	    set-repository
	    )
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

(define (print self port)
  (define fmt
    "artifact ~S download from ~% ~S ~% to directory ~S ~%")
  (display (format #f
		   fmt
		   (artifact-name self)
		   (download-url self)
		   (directory-name self)) port)
)

(define fields '(name download-url filename repository))

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

(define artifact-name
  (record-accessor artifact 'name)
)

(define set-repository
  (record-modifier artifact 'repository)
)

(define (directory-name self)
  (symbol->string (artifact-name self))
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

(define (base-path self)
  (path-join (repository:directory-name (repository self))
	     (directory-name self))
)

(define (full-path self)
  (path-join (base-path self) (filename self))
)

;;; artifact.scm ends here
