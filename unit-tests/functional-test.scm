(let * ( (directory-name (path-join uwd "a-test")) )
  (vm 'my-cog-vm "/home/vonbecmann/bin/cog-vm/r2515/squeak")
  (repository ".test-pharo-artifacts"
	    (list 
	     (artifact 
	      'my-core
	      "https://ci.lille.inria.fr/pharo/view/Pharo%201.4/job/Pharo%201.4/lastSuccessfulBuild/artifact/Pharo-1.4.zip")
	     )
	    )
  (remove (repo))
  (build-repo (repo))
  (artifact-named 'my-core)
  (create-project directory-name 'my-cog-vm 'my-core)
  (load-pom-at directory-name)
  (build)
  (open)
)