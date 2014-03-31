;;; api.scm --- api

;;; Commentary:
;; To make public the commands that you can use from the command line

;;; Code:

(define-module (api)
  #:use-module (ice-9 format)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-9 gnu)
  #:use-module ((core artifact)
		:renamer (symbol-prefix-proc 'artifact:))
  #:use-module ((core repository)
		:renamer (symbol-prefix-proc 'repository:))
  #:use-module ((core project)
		:select (
			 build
			 make-project
			 create
			 open
			 set-directory-name
			 )
		:renamer (symbol-prefix-proc 'project:))
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
	    source
	    artifacts
	    )
  )

;;;
;;; configuration builder
;;;
(define-record-type <pharo-builder-record>
  (make-pharo-builder directory-name user-directory current-directory
		      package-cache-directory current-project current-repository)
  pharo-builder?
  (directory-name directory-name set-directory-name!)
  (user-directory user-directory)
  (current-directory current-directory)
  (package-cache-directory package-cache-directory)
  (current-project current-project set-current-project!)
  (current-repository current-repository)
)

(set-record-type-printer! <pharo-builder-record>
   (lambda (self port)
     (display (format #f
		      "configuration builder at ~S ~% user's directory: ~S ~% current directory: ~S \n package cache directory: ~S \n current ~S \n"
		      (directory-name self)
		      (user-directory self)
		      (current-directory self)
		      (package-cache-directory self)
		      (current-project self)
		      ) port)
     )
)

(define (home-directory self directory)
  (set-directory-name! self directory)
  (mk-mc-package-cache-directory self)
  )

(define (mk-mc-package-cache-directory self)
  (mk-directory (package-cache-directory self))
  )

(define (rm-mc-package-cache self)
  (rm-directory (package-cache-directory self))
  )

(define (path-to-default-conf self)
  (path-join (user-directory self) "pharo-builder-conf.scm")
  )

;;; load default configuration.
(define (load-default-conf self)
  (if-file-exists-do (path-to-default-conf self)
		     (lambda (filename)
		       (load filename)
		       )
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
    )
  )

;; Accessing
;;
(define (set-home-directory-to directory-name)
  "set home directory to DIRECTORY-NAME."
  (home-directory pharo-builder directory-name)
  )

(define (repo)
  "current repository"
  (current-repository pharo-builder)
)

(define (artifacts)
  "artifacts"
  (repository:artifacts-list (repo))
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
		  (artifact-named vm)
		  (artifact-named artifact)
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
	   (artifact-named vm)
	   (artifact-named artifact)
	   (package-cache-directory pharo-builder)))
	 )
    (set-current-project! pharo-builder new-project)
    new-project
  )
)

(define (artifact name download-url source-name)
  "an artifact named NAME and download from DOWNLOAD-URL, based on SOURCE-NAME"
  (let* (
	 (new-artifact (artifact:make-artifact-for name download-url 
				     (artifact-named source-name)))
	 )
    (repository:add-artifact (repo) new-artifact) 
    new-artifact
    )
)

(define (vm name download-url path-to-executable)
  "a vm with PATH-TO-EXECUTABLE."
  (let* ((new-vm (artifact:make-vm-for name download-url path-to-executable)))
    (repository:add-artifact (repo) new-vm) 
    new-vm
    )
  )

(define (source name download-url)
  "a source file"
  (let* ((new-source (artifact:make-source name download-url)))
    (repository:add-artifact (repo) new-source) 
    )
  )

(provide 'api)

;;; api.scm ends here
