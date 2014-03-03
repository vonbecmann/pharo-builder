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
  #:use-module ((core source)
		:renamer (symbol-prefix-proc 'source:))
  #:export (
	    download
	    unzip
	    unzip-vm
	    make-artifact-for
	    make-vm-for
	    artifact-name
	    set-repository
	    path-to-executable
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
	 (cmd  (list "unzip -q -j" (full-path self) "*.image *.changes -d" to-directory))
	 )
         (call-command-list cmd)
	 (source:link-at (source self) to-directory)
     )
)

(define (unzip-vm self to-directory)
  "unzip vm filename to directory."
  (let* (
	 (cmd  (list "unzip -q -o" (full-path self) "-d" to-directory))
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

(define fields '(name 
		 download-url 
		 filename 
		 repository 
		 source
		 path-to-executable))

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

(define (make-artifact-for name download-url source)
  (make-artifact name download-url "latest.zip" '() source "")
)

(define (make-vm-for name download-url path-to-executable)
  (make-artifact name download-url "latest.zip" '() '() path-to-executable)
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

(define source
  (record-accessor artifact 'source)
)

(define filename
  (record-accessor artifact 'filename)
)

(define repository
  (record-accessor artifact 'repository)
)

(define path-to-executable
  (record-accessor artifact 'path-to-executable)
)

(define (base-path self)
  (path-join (repository:directory-name (repository self))
	     (directory-name self))
)

(define (full-path self)
  (path-join (base-path self) (filename self))
)

;;; artifact.scm ends here
