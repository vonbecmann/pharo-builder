;;; functional-test.scm --- functional test

;;; Commentary:
;; use common functionality


;;; Code:

(use-modules (core oscommand))
(use-modules (core artifact))
(use-modules ((core repository)
	      :renamer (symbol-prefix-proc 'repository:)))
(use-modules  ((api)
	       :renamer (symbol-prefix-proc 'pb:)))
(use-modules ((command-line parser)
	      :renamer (symbol-prefix-proc 'parser:)))

(use-modules (ice-9 readline))
(activate-readline)

(define (main args)
  (let*
      ((home-directory-arg (parser:parse args))
       (directory-name (path-join uwd "a-test"))
       (path-to-executable "pharo"))

    (pb:set-home-directory-to home-directory-arg)
    (newline)

    (rm-directory directory-name)
    (mk-directory directory-name)
    (pb:repository ".test-pharo-artifacts")
    (pb:single-artifact 'my-core "http://files.pharo.org/image/120/latest-64.zip")
    (pb:vm
     'my-cog-vm
     "https://files.pharo.org/get-files/120/pharo-vm-Linux-x86_64-stable.zip"
     "pharo")

    (repository:remove (pb:repo))
    (repository:build-repo (pb:repo))
    (pb:repo)

    (pb:artifact-named 'my-core)

    (pb:create-project directory-name 'my-cog-vm 'my-core)
    (pb:load-pom-at directory-name)
    (pb:pom)
    (pb:build)
    (pb:open)
    ))

(provide 'functional-test)

;;; functional-test.scm ends here
