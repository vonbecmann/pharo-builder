(define-module (pharo-builder environment)
  #:use-module (oop goops)
  #:use-module (ice-9 format)
  #:use-module (pharo-builder oscommand)
  #:use-module (pharo-builder vm)
  #:use-module (pharo-builder artifacts)
  #:export (
	    create-project
	    build-project 
	    clean-project
	    delete-project
	    re-build-project
	    image-filename-at
	    execute-project
	    )
)

;;;
;;; a project
;;;
(define-class <Project> ()
  (directory-name #:accessor directory-name
		  #:init-keyword #:directory-name)
  (vm #:accessor vm
      #:init-keyword #:vm)
  (artifact #:accessor artifact
      #:init-keyword #:artifact)

)

(define-method (src-directory (obj <Project>))
  "source directory."
  (path-join (directory-name obj) "src")
)

(define-method (mk-src-directory (obj <Project>))
  "make source directory."
  (let* ((src (src-directory obj)))
    (mk-directory src)
    (link-package-cache-at src)
    (unzip (artifact obj) src)
    )
)

(define-method (rm-src-directory (obj <Project>))
  "remove source directory."
  (rm-directory (src-directory obj))
)

(define-method (image-filename-at (obj <Project>))
  "image filename at source directory."
  (let* ((cmd 
	  (list 
	   "basename $(find " 
	   (src-directory obj) 
	   "-name *.image)")))
    (call-input-command-list cmd)
    )
)

(define-method (execute-project (obj <Project>))
  "execute the given project."
  (let* ((image-filename 
	  (path-join (src-directory obj) (image-filename-at obj))))
    (execute (vm obj) image-filename)
    )
  obj
)

(define-method (build-project (obj <Project>))
  "build the given project."
  (mk-directory (directory-name obj))
  (mk-src-directory obj)
  obj
)

(define-method (delete-project (obj <Project>))
  "delete the given project."
  (rm-directory (directory-name obj))
  obj
)

(define-method (clean-project (obj <Project>))
  "clean source directory for the given project."
  (rm-src-directory obj)
  obj
)

(define-method (re-build-project (obj <Project>))
  "clean and build the given project."
  (build-project (clean-project obj))
)

(define (create-project directory-name vm artifact)
  (define new-project 
    (make <Project> #:directory-name directory-name
	            #:vm vm
		    #:artifact artifact))
  new-project
)

