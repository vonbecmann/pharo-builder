;;; oscommand.scm --- Operating System Commands

;;; Commentary:
;; 


;;; History:
;; 

;;; Code:
(define-module (core oscommand)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 rdelim)
  #:export (
	    ;; paths
	    cwd
	    uwd
	    path-join
	    ;; execute a command
	    call-command-list
	    call-input-command-list
	    ;; basic commands
	    mk-directory
	    rm-directory
	    ;; Monticello package cache
	    link-package-cache-at
	    mc-package-cache-at
	    ;;
	    if-file-exists-do
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

(define (call-command cmd)
  "call a operating system command.
   CMD is a string."
  (define exit-code (system cmd))
  (if (not (zero? exit-code))
	(error
	 (format #f "command ~a failed with exit code ~a"
		 cmd exit-code)))
  exit-code
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

(define (link-package-cache-at package-cache-directory directory-name)
  (symlink package-cache-directory (mc-package-cache-at directory-name))
)

(define (if-file-exists-do filename thunk)
  "if file exists then do thunk otherwise display FILENAME not exists."
  (if (file-exists? filename)
      (thunk filename)
      (display (string-append filename " not exists.\n"))
      )
  )
	   

;;; oscommand.scm ends here
