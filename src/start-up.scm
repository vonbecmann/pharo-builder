;;; start-up.scm --- main entry point


;;; Commentary:
;; set up default configuration


;;; History:
;; 

;;; Code:
(use-modules  ((core artifact)
	       :renamer (symbol-prefix-proc 'pb:)))
(use-modules  ((api)
	       :renamer (symbol-prefix-proc 'pb:)))
(use-modules ((command-line parser)
	      :renamer (symbol-prefix-proc 'parser:)))
(use-modules (ice-9 readline))

(activate-readline)

(define (main args)
  (let*
      (
       (home-directory-arg (parser:parse args))
       )
    (pb:set-home-directory-to home-directory-arg)
    (newline)
    (pb:load-default-configuration)
    (pb:load-pom)
    (pb:display-configuration)
    )
  )

;;; start-up.scm ends here
