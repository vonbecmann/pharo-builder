(define-module (pharo-builder oscommand)
  #:export (add-environment unzip-artifact 
	    cwd join call-command-list 
	    mk-directory basic-download)
)

(define cwd (getcwd))

(define (join path subpath)
  (string-append path "/" subpath)
)

(define (mc-package-cache-at directory-name) 
  (join directory-name "package-cache")
)
(define mc-package-cache 
  (mc-package-cache-at cwd)
)
(define (link-package-cache-at directory-name)
  (symlink mc-package-cache (mc-package-cache-at directory-name))
)

(define environments 
  (join cwd "envs")
)

(define (add-environment env-name)
  (define env-full-path (join environments env-name))
  (mk-directory env-full-path)
  (link-package-cache-at env-full-path)
)

(define vm-dir
  (join cwd "vm")
)



;;
;; call a os command with a string
;;
(define (call-command cmd) 
  (define exit-code (system cmd))
  (if (not (zero? exit-code))
	(error 
	 (format #f "command ~a failed with exit code ~a" 
		 cmd exit-code)))
)
;;
;; call a os command with a list
;;
(define (call-command-list cmd-list) 
  (define cmd (string-join cmd-list (string #\space)))
  (call-command cmd)
)

;;
;; unzip artifact filename to directory
;;
(define (unzip-artifact filename to-directory)
  (define cmd
    (list "unzip" "-j" filename 
	  "*.image" "*.changes" "-d" to-directory))
  (call-command-list cmd)
)

;;
;; answer true if a directory exists
;;
(define (directory-exists? directory-name)
  (define read-write-execute (logior R_OK W_OK X_OK))
  (access? directory-name read-write-execute)
)

;;
;; make a directory
;;
(define (mk-directory directory-name)
  (if (not (directory-exists? directory-name))
      (mkdir directory-name))
) 

;;
;; remove a directory
;;
(define (rm-directory directory-name)
  (if (directory-exists? directory-name)
      (call-command-list (list "rm" "-rf" directory-name)))
) 

;;
;; basic download URL-filename to filename
;; curl --location --output filename URL-filename
;;
(define (basic-download URL-filename to-filename)
  (define cmd 
    (list "curl" "--insecure" "--location" 
	  "--output" to-filename URL-filename))
  (call-command-list cmd)
)

(display cwd)
(newline)
(display mc-package-cache)
(newline)
(display environments)
(newline)
(display vm-dir)
(newline)


