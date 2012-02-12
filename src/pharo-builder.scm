;;; pharo-builder.scm --- create pharo projects

;;; Commentary:
;;; 



;;; History:
;; 

;;; Code:
(define-module (pharo-builder)
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
			 set-directory-name
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
	    current-pom
	    make-pharo-builder
	    repo
	    vms
	    artifact-named
	    )
  )


;;;
;;; configuration builder
;;;
(define fields '(directory-name 
		 user-directory 
		 current-directory
		 package-cache-directory
		 current-project
		 current-repository
		 virtual-machines))

(define (print self port)
  (define fmt "configuration builder at ~S ~% user's directory: ~S ~% current directory: ~S \n package cache directory: ~S \n current ~S \n")
  (display (format #f
		   fmt
		   (directory-name self)
		   (user-directory self)
		   (current-directory self)
		   (package-cache-directory self)
		   (current-project self)
		   ) port)
  )

(define pharo-builder-record
  (make-record-type "pharo-builder-record"
		    fields
		    print)
)
(define make-pharo-builder
  (record-constructor pharo-builder-record
		      fields
		      )
)
(define directory-name
  (record-accessor pharo-builder-record 'directory-name)
)
(define set-directory-name
  (record-modifier pharo-builder-record 'directory-name)
)
(define package-cache-directory
  (record-accessor pharo-builder-record 'package-cache-directory)
)
(define user-directory
  (record-accessor pharo-builder-record 'user-directory)
)
(define current-directory
  (record-accessor pharo-builder-record 'current-directory)
)
(define virtual-machines
  (record-accessor pharo-builder-record 'virtual-machines)
)
(define current-repository
  (record-accessor pharo-builder-record 'current-repository)
)
(define set-current-repository
  (record-modifier pharo-builder-record 'current-repository)
)
(define current-project
  (record-accessor pharo-builder-record 'current-project)
)
(define set-current-project
  (record-modifier pharo-builder-record 'current-project)
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


(define (home-directory self directory)
  (set-directory-name self directory)
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

(define (add-vm self vm)
  (hashq-set! (virtual-machines self) (vm:vm-name vm) vm)
  )

(define (get-vm self vm-name)
  (hashq-ref (virtual-machines self) vm-name)
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
	 (repository:new-repository-for
	    (path-join (user-directory pharo-builder) directory)
	    )))
    (repository:add-all new-repository artifact-list)
    (set-current-repository pharo-builder new-repository)
    new-repository)
)

(define (vm name path-to-executable)
  "a new vm with PATH-TO-EXECUTABLE."
  (let* ((new-vm (vm:make-vm name path-to-executable)))
    (add-vm pharo-builder new-vm)
    new-vm
    )
  )

(define (project vm artifact)
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

(define (create-project directory-name vm artifact)
  "create a new project with VM and ARTIFACT at DIRECTORY-NAME."
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

(define (display-configuration)
  (display pharo-builder)
  )

(define (current-pom)
  (catch #t 
   (lambda ()
     (current-project pharo-builder)
     )
   (lambda (key . args)
	   (display "there's no current project.\n"))
   )
  )

(define (build)
  (project:build (current-pom))
 )

(define (open)
  (project:open (current-pom))
)

(define (repo)
  (catch #t
   (lambda ()
     (current-repository pharo-builder)
     )
   (lambda (key . args)
	   (display "there's no current repo.\n"))
   )
)

(define (vms)
  (catch #t
   (lambda ()
     (hash-map->list cons (virtual-machines pharo-builder))
     )
   (lambda (key . args)
	   (display "there aren't vms.\n"))
   )
)

(define (artifact-named artifact-name)
  (repository:artifact-ref (repo) artifact-name)
)
;;; pharo-builder.scm ends here
