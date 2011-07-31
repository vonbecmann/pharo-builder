;; Console Builder
(use-modules (oop goops))
(use-modules (pharo-builder core oscommand))
(use-modules (pharo-builder core artifacts))
;;(use-modules (pharo-builder core vm))
(use-modules (pharo-builder core project))
(use-modules (pharo-builder conf-builder))
(use-modules (pharo-builder command-line parser))
(use-modules (ice-9 readline))

(activate-readline)

(define (main args)
  (let*  
      (
       (home-arg (parse args))
       
       )
    (home-directory conf-builder home-arg)
    (newline)
    (load-default-conf conf-builder)
    (display conf-builder)
    )
  )

