;;; pharo-builder.scm --- create pharo projects

;;; Commentary:
;;; 



;;; History:
;; 

;;; Code:
(define-module (pharo-builder pharo-builder)
  #:use-module (oop goops)
  #:use-module (ice-9 format)
  #:use-module (pharo-builder core oscommand)
  #:use-module (pharo-builder core artifacts)
  #:use-module (pharo-builder core vm)
  #:use-module ((pharo-builder core project)
		:select (build 
			 <project> 
			 create 
			 execute
			 delete)
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
	    execute
	    build-execute
	    delete
	    )
  )


;;;
;;; configuration builder
;;;
(define-class <pharo-builder> ()
  (directory-name
   #:init-value ""
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
  (set! (package-cache-directory self) (mc-package-cache-at directory))
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
      #:directory-name (path-join (directory-name pharo-builder)
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
    (make project:<project>
      #:directory-name directory-name
      #:vm vm
      #:artifact artifact
      #:package-cache-directory (package-cache-directory pharo-builder))
    )
  (set! (current-project pharo-builder) new-project)
  new-project
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
     (project:build (current-project pharo-builder)))
   )
  )

(define (execute)
  (catch-unbound 
   (lambda ()
     (project:execute (current-project pharo-builder)))
   )
  )

(define (build-execute)
  (catch-unbound 
   (lambda ()
     (build)
     (execute)
     )
   )
)

(define (delete)
  (catch-unbound 
   (lambda ()
     (project:delete (current-project pharo-builder)))
   )
  )
;;; pharo-builder.scm ends here
