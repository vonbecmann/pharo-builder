;; Configuration for the builder
;; just an example
;;
;; Artifacts
;;
(define pharo-core 
  (artifact 
       "pharo-core"
       "core" 
       "http://www.pharo-project.org/pharo-download/stable-core")
)

;;
;; Pharo Artifacts Repository
;;
(define pharo-repository 
  (repository ".pharo-artifacts"
		   (list pharo-core))
)

;;;
;;; Default Virtual Machine
;;;
(define default-vm
  (vm "/home/vonbecmann/Pharo/vm/4.4.7.2357-linux/bin/squeak")
)


