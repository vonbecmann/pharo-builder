;;; repository.scm --- A repository of artifacts

;;; Commentary:
;; A repository of artifacts

;;; History:
;; 

;;; Code:
(define-module (core repository)
  #:use-module (ice-9 format)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-9 gnu)
  #:use-module (core oscommand)
  #:use-module (core artifact)
  #:export (
	    build-repo
	    remove
	    download-all
	    add-artifact
	    new-repository-for
	    directory-name
	    set-directory-name
	    artifact-ref
	    artifacts-list
	    )
)

(define-record-type repository
  (make-repository artifacts directory)
  repository?
  (artifacts artifacts)
  (directory directory set-directory!)
)

(set-record-type-printer! repository
   (lambda (self port)
     (display (format #f
		   "Repository at directory ~S ~% with artifacts: ~% ~S ~% "
		   (directory-name self)
		   (artifacts-list self)) port)
     )
)

(define (hash-to-pair-list table)
  (hash-map->list cons table)
)

(define (artifacts-list self)
  (hash-to-pair-list (artifacts self))
)

(define (directory-name self)
  (directory self)
)

(define (set-directory-name self directory)
  (set-directory! self directory)
)

(define (add-artifact self artifact)
  (set-repository artifact self)
  (hashq-set! (artifacts self) (artifact-name artifact) artifact)
)

(define (hash-to-artifact-list table)
  (hash-map->list (lambda (key value) value) table)
)

(define (download-all self)
  (map download (hash-to-artifact-list (artifacts self)))
)

(define (build-repo self)
  (mk-directory (directory-name self))
  (download-all self)
)

(define (remove self)
  (rm-directory (directory-name self))
)

(define (new-repository-for directory)
  (make-repository (make-hash-table) directory)
)

(define (artifact-ref self artifact-name)
  (hashq-ref (artifacts self) artifact-name)
)

;;; repository.scm ends here
