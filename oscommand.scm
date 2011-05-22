;;; oscommand.scm --- Operating System Commands
;;; Code:
(define-module (pharo-builder oscommand)
  #:export (unzip-artifact 
	    cwd path-join call-command-list 
	    mk-directory basic-download mc-package-cache)
)

;;; "current working directory."
(define cwd (getcwd))

(define (path-join path subpath)
  "PATH / SUBPATH"
  (string-append path "/" subpath)
)

(define (mc-package-cache-at directory-name) 
  (path-join directory-name "package-cache")
)
(define mc-package-cache 
  (mc-package-cache-at cwd)
)
(define (link-package-cache-at directory-name)
  (symlink mc-package-cache (mc-package-cache-at directory-name))
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

(define (call-command-list cmd-list)
  "call a operating system command.
   CMD-LIST is a list of strings"
  (define cmd (string-join cmd-list (string #\space)))
  (call-command cmd)
)

(define (unzip-artifact filename to-directory)
  "unzip artifact filename to directory."
  (define cmd
    (list "unzip" "-j" filename 
	  "*.image" "*.changes" "-d" to-directory))
  (call-command-list cmd)
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

(define (basic-download URL-filename to-filename)
  "basic download URL-filename to filename.
   curl --insecure --location --output filename URL-filename."
  (define cmd 
    (list "curl" "--insecure" "--location" 
	  "--output" to-filename URL-filename))
  (call-command-list cmd)
)




