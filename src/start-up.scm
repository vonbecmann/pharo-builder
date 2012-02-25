;;; start-up.scm --- main entry point


;;; Commentary:
;; set up default configuration


;;; History:
;; 

;;; Code:
(use-modules (oop goops))
(use-modules (core oscommand))
(use-modules (core artifact))
(use-modules (core repository))
(use-modules (api))
(use-modules (command-line parser))
(use-modules (ice-9 readline))

(activate-readline)

(define (main args)
  (let*
      (
       (home-directory-arg (parse args))
       )
    (set-home-directory-to home-directory-arg)
    (newline)
    (load-default-configuration)
    (load-current-pom)
    (display-configuration)
    )
  )

;;; start-up.scm ends here
