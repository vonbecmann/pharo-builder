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
	     )
	    )


;;;
;;; Default Virtual Machine
;;;
(vm 'default-vm "/home/vonbecmann/Pharo/vm/4.4.7.2357-linux/bin/squeak")



