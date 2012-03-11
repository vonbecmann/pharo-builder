;; Configuration for the builder
;; just an example

;;
;; Pharo Artifacts Repository
;;

(repository ".pharo-artifacts"
	    (list 
	     (artifact 
	      'core
	      "http://www.pharo-project.org/pharo-download/stable-core")
	     (vm 
	      'pharo-cog-vm 
	      "https://ci.lille.inria.fr/pharo/view/Cog/job/Cog-Unix/lastSuccessfulBuild/artifact/Cog.zip"
	      "/home/vonbecmann/bin/pharo-cog-vm"
              "CogVM")
	     )
	    )

(source 'pharov10 "PharoV10.sources" "/home/vonbecmann/bin/sources")


