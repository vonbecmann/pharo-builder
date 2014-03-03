;;; api.scm --- api

;;; Commentary:
;; To make public the commands that you can use from the command line

;;; Code:

(define-module (api)
  #:use-module ((core artifact)
		:renamer (symbol-prefix-proc 'artifact:))
  #:use-module ((core repository)
		:renamer (symbol-prefix-proc 'repository:))
  #:use-module ((core source)
		:renamer (symbol-prefix-proc 'source:))
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
	    vm-named
	    source
	    sources
	    )
  )

(define pharo-builder
  (make-pharo-builder
    ""
    uwd
    cwd
    (mc-package-cache-at uwd)
    '()
    (repository:new-repository-for (path-join uwd ".pharo-artifacts"))
    (make-hash-table)
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
  (hash-map->list cons (virtual-machines pharo-builder))
)

(define (sources)
  "all sources."
  (hash-map->list cons (st-sources pharo-builder))
)

(define (repo)
  "current repository"
  (current-repository pharo-builder)
)

(define (current-pom)
  "current project"
  (current-project pharo-builder)
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

(define (vm-named vm-name)
  "get vm named VM-NAME"
  (get-vm pharo-builder vm-name)
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
(define (repository directory)
  "a repository at a DIRECTORY"
  (repository:set-directory-name 
   (repo) 
   (path-join (user-directory pharo-builder) directory))
  (repo) 
)

(define (create-project directory-name vm artifact)
  "create a new project based on ARTIFACT running on VM at DIRECTORY-NAME."
  (let* (
	 (new-project
	      (project:make-project
	          directory-name
		  (get-vm pharo-builder vm)
		  (repository:artifact-ref (repo)
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
	   (repository:artifact-ref (repo) artifact)
	   (package-cache-directory pharo-builder)))
	 )
    (set-current-project pharo-builder new-project)
    new-project
  )
)

(define (artifact name download-url source-name)
  "an artifact named NAME and download from DOWNLOAD-URL, based on SOURCE-NAME"
  (let* (
	 (new-artifact (artifact:make-artifact-for name download-url 
				     (get-source pharo-builder source-name)))
	 )
    (repository:add-artifact (repo) new-artifact) 
    new-artifact
    )
)

(define (vm name download-url path-to-executable)
  "a vm with PATH-TO-EXECUTABLE."
  (let* ((new-vm (artifact:make-vm-for name download-url path-to-executable)))
    (repository:add-artifact (repo) new-vm) 
    (add-vm pharo-builder new-vm)
    new-vm
    )
  )

(define (source name filename directory)
  "a source file at DIRECTORY"
  (let* ((new-source (source:make-source
		  name 
		  filename
		  directory 
		  )))
    (add-source pharo-builder new-source)
    )
  )

(provide 'api)

;;; api.scm ends here
