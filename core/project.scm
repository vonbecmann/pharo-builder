;;; project.scm --- a project

;;; Commentary:
;; 


;;; History:
;; 

;;; Code:
(define-module (pharo-builder core project)
  #:use-module (ice-9 format)
  #:use-module (pharo-builder core oscommand)
  #:use-module (pharo-builder core vm)
  #:use-module (pharo-builder core artifacts)
  #:export (
	    make-project
	    clean
	    set-up
	    build
	    execute
	    set-up-script-at
	    project-definition
	    save-definition
	    create
	    print
	    )
  )

;;;
;;; a project
;;;

(define (print self port)
  (define fmt
    "project at ~A based on ~A")
  (display (format #f
		   fmt
		   (directory-name self)
		   (name (artifact self))) port)
)

(define project 
  (make-record-type "project" 
		    '(directory-name vm artifact package-cache-directory) print)
)

(define make-project
  (record-constructor project '(directory-name vm artifact package-cache-directory))
)

(define directory-name 
  (record-accessor project 'directory-name)
)

(define vm 
  (record-accessor project 'vm)
)

(define artifact
  (record-accessor project 'artifact)
)

(define package-cache-directory 
  (record-accessor project 'package-cache-directory)
)
		 
(define (src-directory self)
  "source directory."
  (path-join (directory-name self) "src")
  )

(define (mk-src-directory self)
  "make source directory."
  (let* (
	 (src (src-directory self))
	 (package-cache-directory (package-cache-directory self))
	 )
    (mk-directory src)
    (link-package-cache-at package-cache-directory src)
    (unzip (artifact self) src)
    )
  )

(define (rm-src-directory self)
  "remove source directory."
  (rm-directory (src-directory self))
  )

(define (image-filename-at self)
  "image filename at source directory."
  (let* (
	 (cmd
	  (list
	   "basename $(find "
	   (src-directory self)
	   "-name *.image)"))
	 )
    (path-join (src-directory self) (call-input-command-list cmd))
    )
  )

(define (set-up-script-at self)
  "set-up.st script at source directory."
  (path-join (directory-name self) "set-up.st")
  )

(define (pom-at self)
  "pom file at source directory."
  (path-join (directory-name self) "pom.scm")
  )

(define (execute self)
  "execute the given project."
  (let* (
	 (image-filename (image-filename-at self))
	 )
    (execute-vm (vm self) image-filename)
    )
  self
  )

(define (build self)
  "build the given project."
  (clean self)
  (mk-src-directory self)
  (set-up self)
  self
  )

(define (clean self)
  "clean source directory for the given project."
  (rm-src-directory self)
  self
  )

(define (mk-home-directory self)
  "make home directory."
  (mk-directory (directory-name self))
  self
  )

(define (project-definition self)
  "project definition."
  (lambda ()
    (format #t
	    "(project\n\t ~S\n\t ~a\n\t ~a\n\t)\n"
	    (directory-name self)
	    (vm-name (vm self))
	    (name (artifact self))
	    )
    )
)

(define (save-definition self)
  "save definition."
  (let* (
	 (pom-filename (pom-at self))
	 )
    (with-output-to-file pom-filename (project-definition self))
      )
  self
)

(define (set-up self)
  "set up the given project."
  (let* (
	 (script-filename (set-up-script-at self))
	 )
    (if (file-exists? script-filename)
	(let* (
	       (image-filename (image-filename-at self))
	       )
	  (execute-headless-vm (vm self) image-filename script-filename)
	  )
	(display (string-append script-filename " does not exists.\n"))
	)
    )
  self
  )

(define (create self)
  (build (save-definition (mk-home-directory self)))
)
;;; project.scm ends here
