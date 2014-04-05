;;; artifact.scm --- A pharo artifact

;;; Commentary:
;; An artifact


;;; History:
;; 

;;; Code:
(define-module (core artifact)
  #:use-module (ice-9 format)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-9 gnu)
  #:use-module (core oscommand)
  #:use-module ((core repository)
		:renamer (symbol-prefix-proc 'repository:))
   #:export (
	    download
	    unzip
	    unzip-vm
	    make-artifact-for
	    make-vm-for
	    make-source
	    artifact-name
	    path-to-executable
	    )
)

(define-record-type artifact
  (make-artifact name download-url filename repository source executable)
  artifact?
  (name name) 
  (download-url download-url) 
  (filename filename) 
  (repository repository) 
  (source source) 
  (executable executable)
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
	 (unzip-source (source self) to-directory)
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

(define (unzip-source self to-directory)
  "unzip source filename to directory."
  (let* (
	 (cmd  (list "unzip -q -o" (full-path self) "-d" to-directory))
	 )
         (call-command-list cmd)
     )
)

(set-record-type-printer! artifact
   (lambda (self port)
     (display (format #f
		      "artifact ~S download from ~% ~S ~% to directory ~S ~%"
		      (artifact-name self)
		      (download-url self)
		      (directory-name self)) port)
     )
)

(define (make-artifact-for name download-url source repository)
  (make-artifact name download-url "latest.zip" repository source "")
)

(define (make-vm-for name download-url path-to-executable repository)
  (make-artifact name download-url "latest.zip" repository '() path-to-executable)
)

(define (make-source name download-url repository)
  (make-artifact name download-url "latest.zip" repository '() "")
)

(define (artifact-name self)
  (name self)
)

(define (directory-name self)
  (symbol->string (artifact-name self))
)

(define (path-to-executable self)
  (executable self)
)

(define (base-path self)
  (path-join (repository:directory-name (repository self))
	     (directory-name self))
)

(define (full-path self)
  (path-join (base-path self) (filename self))
)

;;; artifact.scm ends here
