;;; project.scm --- a project

;;; Commentary:
;; a pharo project

;;; History:
;; 

;;; Code:
(define-module (core project)
  #:use-module (ice-9 format)
  #:use-module (core oscommand)
  #:use-module ((core artifact)
		:renamer (symbol-prefix-proc 'artifact:))
  #:export (
	    make-project
	    clean
	    set-up
	    build
	    open
	    set-up-script-at
	    project-definition
	    save-definition
	    create
	    set-directory-name
	    )
  )

(define (print self port)
  (define fmt
    "project at ~A based on ~A")
  (display (format #f
		   fmt
		   (directory-name self)
		   (artifact:artifact-name (artifact self))) port)
)

(define fields '(directory-name vm artifact package-cache-directory))

(define project
  (make-record-type "project"
		    fields print)
)

(define make-project
  (record-constructor project fields)
)

(define directory-name
  (record-accessor project 'directory-name)
)

(define set-directory-name
  (record-modifier project 'directory-name)
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
		 
(define (target-directory self)
  "target directory."
  (path-join (directory-name self) "target")
  )

(define (mk-target-directory self)
  "make target directory."
  (let* (
	 (target (target-directory self))
	 (package-cache-directory (package-cache-directory self))
	 )
    (mk-directory target)
    (link-package-cache-at package-cache-directory target)
    (artifact:unzip-vm (vm self) target)
    (artifact:unzip (artifact self) target)
    )
  )

(define (rm-target-directory self)
  "remove target directory."
  (rm-directory (target-directory self))
  )

(define (image-filename-at self)
  "image filename at target directory."
  (let* (
	 (cmd
	  (list
	   "basename $(find "
	   (target-directory self)
	   "-name *.image)"))
	 )
    (path-join (target-directory self) (call-input-command-list cmd))
    )
  )

(define (set-up-script-at self)
  "set-up.st script at directory."
  (path-join (directory-name self) "set-up.st")
  )

(define (output-filename-at self)
  "output filename at target directory."
  (path-join (target-directory self) "output.log")
  )

(define (vm-filename-at self)
  "vm filename at target directory."
  (path-join (target-directory self) (artifact:path-to-executable (vm self)))
  )

(define (pom-at self)
  "pom file at home directory."
  (path-join (directory-name self) "pom.scm")
  )

(define (open self)
  "open the given project."
  (execute self)
  )

(define (build self)
  "build the given project."
  (clean self)
  (mk-target-directory self)
  (set-up self)
  )

(define (clean self)
  "clean target directory for the given project."
  (rm-target-directory self)
  )

(define (mk-home-directory self)
  "make home directory."
  (mk-directory (directory-name self))
  )

(define (project-definition self)
  "project definition."
  (lambda ()
    (format #t
	    "(pb:project\n\t '~a\n\t '~a\n\t)\n"
	    (artifact:artifact-name (vm self))
	    (artifact:artifact-name (artifact self))
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
)

(define (set-up self)
  "set up the given project."
  (execute-headless self)
  )

(define (create self)
  (mk-home-directory self)
  (save-definition self)
  (build self)
)

(define (execute self)
  "execute a image and don't wait for the response.
   std error and output are redirected to OUTPUT-FILENAME"
  (let* (
	 (vm-filename (vm-filename-at self))
	 (image-filename (image-filename-at self))
	 (output-filename (output-filename-at self))
	 (cmd (list vm-filename image-filename ">" output-filename "2>&1" "&"))
	 )
    (call-command-list cmd))
)

(define (execute-headless self)
  "execute a image and wait for the response.
   std error and output are redirected to OUTPUT-FILENAME"
  (let* (
	 (script-filename (set-up-script-at self))
	 )
    (if (file-exists? script-filename)
	(let* (
	       (vm-filename (vm-filename-at self))
	       (image-filename (image-filename-at self))
	       (output-filename (output-filename-at self))
	       (cmd (list vm-filename "-vm-display-null" "-vm-sound-null" 
			  image-filename script-filename ">" output-filename "2>&1"))
	       )
	  (call-command-list cmd)
	  )
	(display (string-append script-filename " does not exists.\n"))
	)
    )
)

;;; project.scm ends here
