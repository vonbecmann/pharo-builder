;;; oscommand.scm --- Operating System Commands
;;; Code:
(define-module (pharo-builder core oscommand)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 rdelim)
  #:export ( 
	    ;; paths
	    cwd 
	    uwd
	    path-join 
	    ;; pharo-builder-configuration
	    load-pharo-builder-conf
	    ;; execute a command
	    call-command-list 
	    call-input-command-list
	    ;; basic commands
	    mk-directory
	    rm-directory
	    ;; Monticello package cache
	    mk-mc-package-cache 
	    rm-mc-package-cache
	    link-package-cache-at 
	    mc-package-cache
	    )
)

;;; current working directory.
(define cwd (getcwd))

;;; user's working directory.
(define uwd (getenv "HOME"))

(define (path-join path subpath)
  "PATH / SUBPATH"
  (string-append path "/" subpath)
)

;;; pharo builder configuration.
(define pharo-builder-conf (path-join uwd "pharo-builder-conf.scm"))

;;; pharo builder configuration exists?.
(define (pharo-builder-conf-exists?) 
  (file-exists? pharo-builder-conf)
)

;;; load pharo builder configuration.
(define (load-pharo-builder-conf) 
  (if (pharo-builder-conf-exists?)
      (load pharo-builder-conf)
      (display (string-append pharo-builder-conf " not exists.\n"))
      )
)

(define (call-command cmd)
  "call a operating system command.
   CMD is a string."
  (define exit-code (system cmd))
  (if (not (zero? exit-code))
	(error 
	 (format #f "command ~a failed with exit code ~a" 
		 cmd exit-code)))
)

(define (call-input-command cmd)
  "call a operating system command and read input.
   CMD is a string."
  (let* (
	 (port (open-input-pipe cmd)) 
	 (str  (read-line port))
	 )
    (close-pipe port)
    str)
)

(define (call-command-list cmd-list)
  "call a operating system command.
   CMD-LIST is a list of strings"
  (define cmd (string-join cmd-list (string #\space)))
  (call-command cmd)
)

(define (call-input-command-list cmd-list)
  "call a operating system command and read input.
   CMD-LIST is a list of strings"
  (define cmd (string-join cmd-list (string #\space)))
  (call-input-command cmd)
)

(define (directory-exists? directory-name)
  "answer true if a directory exists"
  (define read-write-execute (logior R_OK W_OK X_OK))
  (access? directory-name read-write-execute)
)

(define (mk-directory directory-name)
  "make a directory"
  (if (not (directory-exists? directory-name))
      (mkdir directory-name))
) 

(define (rm-directory directory-name)
  "remove a directory"
  (if (directory-exists? directory-name)
      (call-command-list (list "rm" "-rf" directory-name)))
) 


;;;
;;; monticello package cache directory
;;;
(define (mc-package-cache-at directory-name) 
  (path-join directory-name "package-cache")
)

(define mc-package-cache 
  (mc-package-cache-at cwd)
)

(define (mk-mc-package-cache)
  (mk-directory mc-package-cache)
)

(define (rm-mc-package-cache)
  (rm-directory mc-package-cache)
)

(define (link-package-cache-at directory-name)
  (symlink mc-package-cache (mc-package-cache-at directory-name))
)



