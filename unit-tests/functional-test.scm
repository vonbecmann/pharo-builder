(let* ( (directory-name (path-join uwd "a-test"))
	(vm-directory (path-join directory-name "pharo-cog-vm"))
	(path-to-executable "CogVM"))

  (rm-directory directory-name)
  (mk-directory directory-name)
  (source 'pharov10 "PharoV10.sources" "/home/vonbecmann/bin/sources")
  (repository ".test-pharo-artifacts"
	    (list 
	     (artifact 
	      'my-core
	      "https://ci.lille.inria.fr/pharo/view/Pharo%201.4/job/Pharo%201.4/lastSuccessfulBuild/artifact/Pharo-1.4.zip"
	      'pharov10)
	     (vm 
	      'my-cog-vm
	      "https://ci.lille.inria.fr/pharo/view/Cog/job/Cog-Unix/lastSuccessfulBuild/artifact/Cog.zip"
	      vm-directory
	      path-to-executable)
	     )
	    )
  
  (remove (repo))
  (build-repo (repo))
  (repo)

  (artifact-named 'my-core)
  (vms)
  (install (vm-named 'my-cog-vm))  

  (sources)
  
  (create-project directory-name 'my-cog-vm 'my-core)
  (load-pom-at directory-name)
  (current-pom)
  (build)
  (open)
)