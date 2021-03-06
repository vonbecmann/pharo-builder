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
    (pb:source 'pharov20 "http://files.pharo.org/sources/PharoV20.sources.zip")
    (pb:artifact 
     'my-core
     "http://files.pharo.org/image/20/latest.zip"
     'pharov20)
    (pb:vm 
     'my-cog-vm
     "https://swing.fit.cvut.cz/jenkins/view/Projects/job/pharo-vm-stable-swing/lastSuccessfulBuild/artifact/pharo-vm-stable-swing.zip"
     path-to-executable)

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