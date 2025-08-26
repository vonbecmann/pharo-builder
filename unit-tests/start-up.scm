;;; start-up.scm --- main entry point


;;; Commentary:
;; set up test configuration


;;; History:
;; 

;;; Code:
(use-modules (core oscommand))
(use-modules  ((core artifact)
	       :renamer (symbol-prefix-proc 'pb:)))
(use-modules  ((api)
	       :renamer (symbol-prefix-proc 'pb:)))
(use-modules ((core repository)
	      :renamer (symbol-prefix-proc 'repository:)))
(use-modules ((command-line parser)
	      :renamer (symbol-prefix-proc 'parser:)))
(use-modules (ice-9 readline))

(activate-readline)

(define (main args)
  (let*
      (
       (home-directory-arg (parser:parse args))
       (directory-name (path-join cwd "target/a-test")))
    (pb:set-home-directory-to home-directory-arg)
    (newline)

    (pb:repository ".test-pharo-artifacts")
    (pb:single-artifact 'my-core "http://files.pharo.org/image/120/latest-64.zip")
    (pb:vm
     'my-cog-vm
     "https://files.pharo.org/get-files/120/pharo-vm-Linux-x86_64-stable.zip"
     "pharo")

    ;;(pb:load-default-configuration)
    ;;(pb:load-pom)
    (pb:display-configuration)
    (pb:create-project directory-name 'my-cog-vm 'my-core)
    (pb:load-pom-at directory-name)
    (pb:pom)))

;;; start-up.scm ends here
