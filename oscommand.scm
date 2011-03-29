
(define cwd (getcwd))

(define artifacts-repo 
  (string-append cwd "/artifacts")
)

(define mc-package-cache 
  (string-append cwd "/package-cache")
)

(define environments 
  (string-append cwd "/envs")
)

(define vm-dir
  (string-append cwd "/vm")
)


(define (callCommand cmd) 
  (define exit-code (system cmd))
  (if (not (zero? exit-code))
	(error 
	 (format #f "command ~a failed with exit code ~a" cmd exit-code)))
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


