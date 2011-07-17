(define-module (pharo-builder core project)
  #:use-module (oop goops)
  #:use-module (ice-9 format)
  #:use-module (pharo-builder core oscommand)
  #:use-module (pharo-builder core vm)
  #:use-module (pharo-builder core artifacts)
  #:export (
	    mk-home-directory
	    delete-project
	    clean
	    build 
	    set-up
	    execute
	    set-up-script-at
	    <project>
	    save-definition
	    project-definition
	    )
  )

;;;
;;; a project
;;;
(define-class <project> ()
  (directory-name #:accessor directory-name
		  #:init-keyword #:directory-name)
  (vm #:accessor vm
      #:init-keyword #:vm)
  (artifact #:accessor artifact
	    #:init-keyword #:artifact)

  )

(define-method (write (self <project>) port)
  (define fmt 
    "project at ~A based on ~A")
  (display (format #f
		   fmt
		   (directory-name self)
		   (name (artifact self))) port)
)

(define-method (src-directory (self <project>))
  "source directory."
  (path-join (directory-name self) "src")
  )

(define-method (mk-src-directory (self <project>))
  "make source directory."
  (let* (
	 (src (src-directory self))
	 )
    (mk-directory src)
    (link-package-cache-at src)
    (unzip (artifact self) src)
    )
  )

(define-method (rm-src-directory (self <project>))
  "remove source directory."
  (rm-directory (src-directory self))
  )

(define-method (image-filename-at (self <project>))
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

(define-method (set-up-script-at (self <project>))
  "set-up.st script at source directory."
  (path-join (directory-name self) "set-up.st")
  )

(define-method (pom-at (self <project>))
  "pom file at source directory."
  (path-join (directory-name self) "pom.scm")
  )

(define-method (execute (self <project>))
  "execute the given project."
  (let* (
	 (image-filename (image-filename-at self))
	 )
    (execute-vm (vm self) image-filename)
    )
  self
  )

(define-method (build (self <project>))
  "build the given project."
  (clean self)
  (mk-src-directory self)
  (set-up self)
  self
  )

(define-method (delete-project (self <project>))
  "delete the given project."
  (rm-directory (directory-name self))
  self
  )

(define-method (clean (self <project>))
  "clean source directory for the given project."
  (rm-src-directory self)
  self
  )

(define-method (mk-home-directory (self <project>))
  "make home directory."
  (mk-directory (directory-name self))
  self
  )

(define-method (project-definition (self <project>))
  "project definition."
  (lambda () 
    (format #t 
	    "(define current-project \n\t (project  ~S ~a ~a)\n)" 
	    (directory-name self) 
	    (vm-name (vm self))
	    (name (artifact self))
	    )
    )
)

(define-method (save-definition (self <project>))
  "save definition."
  (let* (
	 (pom-filename (pom-at self))
	 )
    (with-output-to-file pom-filename (project-definition self))
      )
  self
)

(define-method (set-up (self <project>))
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


