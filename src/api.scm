;;; api.scm --- api

;;; Commentary:
;; To make public the commands that you can use from the command line

;;; Code:

(define-module (api)
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
			 set-directory-name
			 )
		:renamer (symbol-prefix-proc 'project:))
  #:use-module (core pharo-builder)
  #:use-module (core oscommand)
  #:export (
	    set-home-directory-to
	    load-default-configuration
	    load-current-pom
	    load-pom-at
	    current-pom
	    project
	    create-project
	    open
	    build
	    display-configuration
	    repository
	    repo
	    artifact
	    artifact-named
	    vm
	    vms
	    )
  )

(define pharo-builder
  (make-pharo-builder
    ""
    uwd
    cwd
    (mc-package-cache-at uwd)
    '()
    '()
    (make-hash-table)
    )
  )

;; Accessing
;;
(define (set-home-directory-to directory-name)
  "set home directory to DIRECTORY-NAME."
  (home-directory pharo-builder directory-name)
  )

(define (vms)
  "all virtual machines."
  (catch #t
   (lambda ()
     (hash-map->list cons (virtual-machines pharo-builder))
     )
   (lambda (key . args)
	   (display "there aren't vms.\n"))
   )
)

(define (repo)
  "current repository"
  (catch #t
   (lambda ()
     (current-repository pharo-builder)
     )
   (lambda (key . args)
	   (display "there's no current repo.\n"))
   )
)

(define (current-pom)
  "current project"
  (catch #t
   (lambda ()
     (current-project pharo-builder)
     )
   (lambda (key . args)
	   (display "there's no current project.\n"))
   )
  )

(define (build)
  "build current project."
  (project:build (current-pom))
 )

(define (open)
  "open current project."
  (project:open (current-pom))
)

(define (artifact-named artifact-name)
  "get artifact named ARTIFACT-NAME"
  (repository:artifact-ref (repo) artifact-name)
)

;; Loading
;;
(define (load-default-configuration)
  "load default configuration."
  (load-default-conf pharo-builder)
  )

(define (pom-at directory-name)
  "pom at DIRECTORY-NAME"
  (path-join directory-name "pom.scm")
  )

(define (load-pom-at directory-name)
  "load pom at DIRECTORY-NAME."
  (if-file-exists-do (pom-at directory-name)
		     (lambda (filename)
		       (load filename)
		       (project:set-directory-name
		       	        (current-project pharo-builder)
		       	        directory-name)
		       )
		     )
  )

(define (load-current-pom)
  "load pom at current directory."
  (load-pom-at (current-directory pharo-builder))
  )

;; Printing
(define (display-configuration)
  "display actual configuration"
  (display pharo-builder)
  )

;; Instance Creation
(define (repository directory artifact-list)
  "a repository with ARTIFACTS-LIST at a DIRECTORY"
  (let* ((new-repository
	 (repository:new-repository-for
	    (path-join (user-directory pharo-builder) directory)
	    )))
    (repository:add-all new-repository artifact-list)
    (set-current-repository pharo-builder new-repository)
    new-repository)
)

(define (create-project directory-name vm artifact)
  "create a new project based on ARTIFACT running on VM at DIRECTORY-NAME."
  (let* (
	 (new-project
	      (project:make-project
	          directory-name
		  (get-vm pharo-builder vm)
		  (repository:artifact-ref (current-repository pharo-builder)
					   artifact)
		  (package-cache-directory pharo-builder))
	     )
	 )
    (project:create new-project)
    new-project
    )
  )

(define (project vm artifact)
  "a project based on ARTIFACT running on VM."
  (let* (
	 (new-project
	      (project:make-project
	          (current-directory pharo-builder)
		  (get-vm pharo-builder vm)
		  (repository:artifact-ref (current-repository pharo-builder)
					   artifact)
		  (package-cache-directory pharo-builder)))
	 )
   
    (set-current-project pharo-builder new-project)
    new-project
  )
)

(define (artifact name download-url)
  "an artifact named NAME and download from DOWNLOAD-URL"
  (let* (
	 (new-artifact
	  (artifact:make-artifact name download-url "latest.zip" '()))
	 )
    new-artifact)
)

(define (vm name path-to-executable)
  "a vm with PATH-TO-EXECUTABLE."
  (let* ((new-vm (vm:make-vm name path-to-executable)))
    (add-vm pharo-builder new-vm)
    new-vm
    )
  )

(provide 'api)

;;; api.scm ends here
