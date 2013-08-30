;; Configuration for the builder
;; just an example

;;
;; Pharo Artifacts Repository
;;

(pb:repository ".pharo-artifacts")

(pb:source 'pharov20 "PharoV20.sources" "/home/vonbecmann/bin/sources")

(pb:artifact 
 'pharo-20
 "http://files.pharo.org/image/20/latest.zip"
 'pharov20)

(pb:vm 
 'pharo-vm 
 "http://files.pharo.org/vm/pharo/linux/stable.zip"
 "/home/vonbecmann/bin/pharo-vm"
 "pharo")

