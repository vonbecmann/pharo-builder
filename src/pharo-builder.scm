;;; pharo-builder.scm --- create pharo projects

;;; Commentary:
;;; 



;;; History:
;; 

;;; Code:
(define-module (pharo-builder)
  #:use-module (oop goops)
  #:use-module (ice-9 format)
  #:use-module (core oscommand)
  #:use-module ((core artifact)
		:renamer (symbol-prefix-proc 'artifact:))		
  #:use-module ((core repository)
		:renamer (symbol-prefix-proc 'repository:))		
  #:use-module ((core vm)
		:renamer (symbol-prefix-proc 'vm:))		
  #:use-module ((core project)
		:select (
			 build 
			 make-project
			 create 
			 open
			 )
		:renamer (symbol-prefix-proc 'project:))
  #:export (
	    artifact
	    repository
	    vm
	    load-default-configuration
	    load-current-pom
	    load-pom-at
	    set-home-directory-to
	    display-configuration
	    create-project
	    project
	    build
	    open
	    current
	    <pharo-builder>
	    )
  )


;;;
;;; configuration builder
;;;
(define-class <pharo-builder> ()
  (directory-name
   #:init-value ""
   #:init-keyword #:directory-name
   #:accessor directory-name)
  (user-directory
   #:init-keyword #:user-directory
   #:accessor user-directory)
  (current-directory
   #:init-keyword #:current-directory
   #:accessor current-directory)
  (package-cache-directory
   #:init-value ""
   #:init-keyword #:package-cache-directory
   #:accessor package-cache-directory)
  (current-project
   #:init-keyword #:current-project
   #:accessor current-project)
  )

(define-method (home-directory (self <pharo-builder>) directory)
  (set! (directory-name self) directory)
  (mk-mc-package-cache-directory self)
  )

(define-method (mk-mc-package-cache-directory (self <pharo-builder>))
  (mk-directory (package-cache-directory self))
  )

(define-method (rm-mc-package-cache (self <pharo-builder>))
  (rm-directory (package-cache-directory self))
  )

(define-method (write (self <pharo-builder>) port)
  (define fmt "configuration builder at ~S ~% user's directory: ~S ~% current directory: ~S \n package cache directory: ~S \n")
  (display (format #f
		   fmt
		   (directory-name self)
		   (user-directory self)
		   (current-directory self)
		   (package-cache-directory self)
		   ) port)
  )

(define-method (path-to-default-conf (self <pharo-builder>))
  (path-join (user-directory self) "pharo-builder-conf.scm")
  )

;;; load default configuration.
(define-method (load-default-conf (self <pharo-builder>))
  (load-file-if-exists (path-to-default-conf self))
  )

(define pharo-builder
  (make <pharo-builder>
    #:user-directory uwd
    #:current-directory cwd
    #:package-cache-directory (mc-package-cache-at uwd)
    )
  )

(define (artifact name download-url)
  "an artifact named NAME and
   download from DOWNLOAD-URL"
  (let* (
	 (new-artifact 
	  (artifact:make-artifact name download-url "latest.zip" '()))
	 )
    new-artifact)
)

(define (repository directory artifact-list)
  "a repository with ARTIFACTS-LIST at a DIRECTORY"
  (let* ((new-repository
	 (repository:make-repository
	    '()
	    (path-join (user-directory pharo-builder) directory)
	    )))
    (repository:add-all new-repository artifact-list)
    new-repository)
)

(define (vm name path-to-executable)
  "a new vm with PATH-TO-EXECUTABLE."
  (let* ((new-vm (vm:make-vm name path-to-executable)))
    new-vm
    )
  )

(define (project directory-name vm artifact)
  (let* (
	 (new-project
	      (project:make-project directory-name
		  vm
		  artifact
		  (package-cache-directory pharo-builder)))
	 )
   
    (set! (current-project pharo-builder) new-project)
    new-project
  )
)

(define (create-project directory-name vm artifact)
  "create a new project with VM and ARTIFACT at DIRECTORY-NAME."
  (let* (
	 (new-project (project directory-name vm artifact))
	 )
    (project:create new-project)
    new-project
    )
  )

(define (set-home-directory-to directory-name)
  "set home directory to DIRECTORY-NAME."
  (home-directory pharo-builder directory-name)
  )

(define (load-default-configuration)
  "load default configuration."
  (load-default-conf pharo-builder)
  )

(define (pom-at directory-name)
  (path-join directory-name "pom.scm")
  )

(define (load-pom-at directory-name)
  "load pom at DIRECTORY-NAME."
  (load-file-if-exists (pom-at directory-name))
  )

(define (load-current-pom)
  "load pom at current directory."
  (load-pom-at (current-directory pharo-builder))
  )

(define (display-configuration)
  (display pharo-builder)
  )

(define (catch-unbound thunk)
  (catch 'goops-error thunk 
	 (lambda (key . args)
	   (display "there's no current project.\n"))
	 )
  )

(define (build)
  (catch-unbound 
   (lambda ()
     (project:build (current-project pharo-builder))
     )
   )
  )

(define (open)
  (catch-unbound 
   (lambda ()
     (project:open (current-project pharo-builder)))
   )
  )

(define (current)
  (catch-unbound 
   (lambda ()
     (current-project pharo-builder)
     )
   )
)

;;; pharo-builder.scm ends here
