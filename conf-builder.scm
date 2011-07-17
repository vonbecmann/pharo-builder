;;; conf-builder.scm --- a configuration builder

;;; Commentary:
;; 


;;; History:
;; 

;;; Code:
(define-module (pharo-builder conf-builder)
  #:use-module (oop goops)
  #:use-module (ice-9 format)
  #:use-module (pharo-builder core oscommand)
  #:use-module (pharo-builder core artifacts)
  #:use-module (pharo-builder core vm)
  #:use-module (pharo-builder core project)
  #:export (
	    <conf-builder>
	    artifact
	    repository
	    vm
	    load-default-conf
	    home-directory
	    conf-builder
	    create-project 
	    project
	    )
)


;;;
;;; configuration builder
;;;
(define-class <conf-builder> ()
  (directory-name 
           #:init-value ""
           #:accessor directory-name)
  (user-directory 
	   #:init-keyword #:user-directory
           #:accessor user-directory)
  (current-directory 
	   #:init-keyword #:current-directory
           #:accessor current-directory)
  )

(define-method (home-directory (self <conf-builder>) directory)
  (set! (directory-name self) directory)
)

(define-method (write (self <conf-builder>) port)
  (define fmt "configuration builder at ~S ~% user's directory: ~S ~% current directory: ~S \n")
  (display (format #f
		   fmt
		   (directory-name self)
		   (user-directory self)
		   (current-directory self)
		   ) port)
)

(define-method (path-to-default-conf (self <conf-builder>))
  (path-join (user-directory self) "pharo-builder-conf.scm")
)

;;; default configuration exists?.
(define-method (default-conf-exists? (self <conf-builder>)) 
  (file-exists? (path-to-default-conf self))
)

;;; load default configuration.
(define-method (load-default-conf (self <conf-builder>)) 
  (if (default-conf-exists? self)
      (load (path-to-default-conf self))
      (display (string-append (path-to-default-conf self) " not exists.\n"))
      )
)

(define conf-builder 
	(make <conf-builder> 
	  #:user-directory uwd
	  #:current-directory cwd
	  )
 )


(define (artifact name directory-name download-URL)
  "an artifact named NAME at DIRECTORY-NAME and
   download from DOWNLOAD-URL"
  (define new-artifact
          (make <artifact>
	    #:name name
	    #:directory-name directory-name
	    #:download-from download-URL
	    )
	  )
  new-artifact)

(define (repository directory artifact-list)
  "a repository with ARTIFACTS-LIST at a DIRECTORY"
  (define new-repository
    (make <artifacts-repository>
      #:directory-name (path-join (directory-name conf-builder) 
				  directory)
			   )
    )
  (add-all new-repository artifact-list)
  new-repository
)

(define (vm name path-to-executable)
  "a new vm with PATH-TO-EXECUTABLE."
  (define new-vm
    (make <vm> #:name name #:path-to-executable path-to-executable)
    )
  new-vm
)

(define (project directory-name vm artifact)
  (define new-project
    (make <project> #:directory-name directory-name
	       #:vm vm
	       #:artifact artifact)
    )
  new-project
)

(define (create-project directory-name vm artifact)
  "create a new project with VM and ARTIFACT at DIRECTORY-NAME."
  (let* (
	 (new-project (project directory-name vm artifact))
	 )
    (mk-home-directory new-project)
    (save-definition new-project)
    )
  )

;;; conf-builder.scm ends here
