
(define cwd (getcwd))

(define (join path subpath)
  (string-append path "/" subpath)
)

(define artifacts-repo 
  (join cwd "artifacts")
)

(define mc-package-cache 
  (join cwd "package-cache")
)

(define environments 
  (join cwd "envs")
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
(define (create-basic-structure)
  (if (not (directory-exists? artifacts-repo))
      (mkdir artifacts-repo)
      )
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


