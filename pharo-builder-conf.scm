;; Configuration for the builder
;; just an example

;;
;; Pharo Artifacts Repository
;;

(pb:repository ".test-pharo-artifacts")


(pb:single-artifact 'my-core "http://files.pharo.org/image/120/latest-64.zip")

(pb:vm
 'my-cog-vm
 "https://files.pharo.org/get-files/120/pharo-vm-Linux-x86_64-stable.zip"
 "pharo")

