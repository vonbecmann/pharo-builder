;;; start-up.scm --- set up default configuration


;;; Commentary:
;; 


;;; History:
;; 

;;; Code:
(use-modules (oop goops))
(use-modules (core oscommand))
(use-modules (core artifact))
(use-modules (core repository))
(use-modules (pharo-builder))
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
