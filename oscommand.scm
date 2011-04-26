(define-module (pharo-builder oscommand)
  #:export (mk-basic-structure rm-basic-structure 
	    add-artifact add-environment download unzip-artifact)
)

(define cwd (getcwd))

(define (join path subpath)
  (string-append path "/" subpath)
)

(define artifacts-repo 
  (join cwd ".artifacts")
)

(define (add-artifact artifact-name)
  (mk-directory (join artifacts-repo artifact-name))
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

(define (directory-exists? directory-name)
  (define read-write-execute (logior R_OK W_OK X_OK))
  (access? directory-name read-write-execute)
)

;;
;; call a os command with a string
;;
(define (call-command cmd) 
  (define exit-code (system cmd))
  (if (not (zero? exit-code))
	(error 
	 (format #f "command ~a failed with exit code ~a" cmd exit-code)))
)
;;
;; call a os command with a list
;;
(define (call-command-list cmd-list) 
  (define cmd (string-join cmd-list (string #\space)))
  (call-command cmd)
)
;;
;; download URL-filename to filename
;; curl --location --output filename URL-filename
;;
(define (download URL-filename to-filename)
  (define cmd 
    (list "curl" "--location" "--output" to-filename URL-filename))
  (call-command-list cmd)
)

;;
;; unzip artifact filename to directory
;;
(define (unzip-artifact filename to-directory)
  (define cmd
    (list "unzip" "-j" filename "*.image" "*.changes" "-d" to-directory))
  (call-command-list cmd)
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


