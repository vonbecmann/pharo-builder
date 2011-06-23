(define-module (pharo-builder core project)
  #:use-module (oop goops)
  #:use-module (ice-9 format)
  #:use-module (pharo-builder core oscommand)
  #:use-module (pharo-builder core vm)
  #:use-module (pharo-builder core artifacts)
  #:export (
	    create-project
	    build 
	    clean
	    delete-project
	    re-build
	    execute
	    set-up
	    <project>
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
  (let* ((src (src-directory self)))
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
  (let* ((cmd 
	  (list 
	   "basename $(find " 
	   (src-directory self) 
	   "-name *.image)")))
    (call-input-command-list cmd)
    )
  )

(define-method (execute (self <project>))
  "execute the given project."
  (let* ((image-filename 
	  (path-join (src-directory self) (image-filename-at self))))
    (execute-vm (vm self) image-filename)
    )
  self
  )

(define-method (build (self <project>))
  "build the given project."
  (clean self)
  (mk-src-directory self)
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

(define-method (set-up (self <project>))
  "set up the given project."
  (let* ((image-filename 
	  (path-join (src-directory self) (image-filename-at self)))
	 (script-filename (path-join (directory-name self) "set-up.st"))
	 )
    (execute-headless-vm (vm self) image-filename script-filename))
  self
  )

(define (create-project directory-name vm artifact)
  "create a new project with VM and ARTIFACT at DIRECTORY-NAME."
  (let* ((new-project 
	 (make <project> #:directory-name directory-name
	       #:vm vm
	       #:artifact artifact)))
    (mk-home-directory new-project)
    new-project)
  )

