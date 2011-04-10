(define-module (pharo-builder oscommand)
  #:export (mk-basic-structure rm-basic-structure add-artifact add-environment)
)

(define cwd (getcwd))

(define (join path subpath)
  (string-append path "/" subpath)
)

(define artifacts-repo 
  (join cwd "artifacts")
)

(define (add-artifact artifact-name)
  (mk-directory (join artifacts-repo artifact-name))
)

(define mc-package-cache 
  (join cwd "package-cache")
)

(define environments 
  (join cwd "envs")
)
(define (add-environment env-name)
  (mk-directory (join environments env-name))
)

(define vm-dir
  (join cwd "vm")
)

(define (directory-exists? directory-name)
  (access? directory-name (logior R_OK W_OK X_OK))
)

(define (callCommand cmd) 
  (define exit-code (system cmd))
  (if (not (zero? exit-code))
	(error 
	 (format #f "command ~a failed with exit code ~a" cmd exit-code)))
)

(define (mk-directory directory-name)
  (if (not (directory-exists? directory-name))
      (mkdir directory-name))
) 

(define (mk-basic-structure)
  (mk-directory artifacts-repo)
  (mk-directory mc-package-cache)
  (mk-directory environments)
  (mk-directory vm-dir)
)
(define (rm-basic-structure)
  (rmdir artifacts-repo)
  (rmdir mc-package-cache)
  (rmdir environments)
  (rmdir vm-dir)
)

(display cwd)
(newline)
(display artifacts-repo)
(newline)
(display mc-package-cache)
(newline)
(display environments)
(newline)
(display vm-dir)
(newline)


