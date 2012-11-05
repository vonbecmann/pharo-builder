(use-modules (core oscommand))
(use-modules (core artifact))
;; (use-modules (core source))
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
       (vm-directory (path-join directory-name "pharo-cog-vm"))
       (path-to-executable "CogVM"))

    (pb:set-home-directory-to home-directory-arg)
    (newline)

    (rm-directory directory-name)
    (mk-directory directory-name)
    (pb:repository ".test-pharo-artifacts")
    (pb:source 'pharov10 "PharoV10.sources" "/home/vonbecmann/bin/sources")
    (pb:artifact 
     'my-core
     "https://ci.lille.inria.fr/pharo/view/Pharo%201.4/job/Pharo%201.4/lastSuccessfulBuild/artifact/Pharo-1.4.zip"
     'pharov10)
    (pb:vm 
     'my-cog-vm
     "https://ci.lille.inria.fr/pharo/view/Cog/job/Cog-VM/Architecture=32,OS=linux/lastSuccessfulBuild/artifact/Cog-linux.zip"
     vm-directory
     path-to-executable)

    (repository:remove (pb:repo))
    (repository:build-repo (pb:repo))
    (pb:repo)

    (pb:artifact-named 'my-core)
    (pb:vms)
    (pb:install-vm-named 'my-cog-vm)

    (pb:sources)
    (pb:create-project directory-name 'my-cog-vm 'my-core)
    (pb:load-pom-at directory-name)
    (pb:current-pom)
    (pb:build)
    (pb:open)
))