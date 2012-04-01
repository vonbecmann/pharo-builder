;;; pharo-builder.scm --- create pharo projects

;;; Commentary:
;;; helps you create pharo projects

;;; History:
;; 

;;; Code:
(define-module (core pharo-builder)
  #:use-module (ice-9 format)
  #:use-module (core oscommand)
  #:use-module ((core artifact)
		:renamer (symbol-prefix-proc 'artifact:))
  #:use-module ((core source)
		:renamer (symbol-prefix-proc 'source:))
  #:export (
	    make-pharo-builder
	    home-directory
	    load-default-conf
	    user-directory
	    current-repository
	    set-current-repository
	    add-vm
	    get-vm
	    current-directory
	    virtual-machines
	    package-cache-directory
	    current-project
	    set-current-project
	    add-source
	    st-sources
	    get-source
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
		 virtual-machines
		 sources))

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

(define st-sources
  (record-accessor pharo-builder-record 'sources)
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
  (hashq-set! (virtual-machines self) (artifact:artifact-name vm) vm)
  )

(define (get-vm self vm-name)
  (hashq-ref (virtual-machines self) vm-name)
  )

(define (add-source self source)
  (hashq-set! (st-sources self) (source:source-name source) source)
  )

(define (get-source self source-name)
  (hashq-ref (st-sources self) source-name)
  )

;;; pharo-builder.scm ends here
