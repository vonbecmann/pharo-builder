(define-module (project-test))
(use-modules (srfi srfi-64))
(use-modules ((core project)
		:select (
			 print
			 set-up-script-at
			 project-definition
			 make-project
			 )
		:renamer (symbol-prefix-proc 'project:)
		))
(use-modules (api))

(test-begin "project-test")

(define directory-name "/test-project")
(define artifact-name 'pharo-core)
(define vm-name 'test-vm)
(define test-source (source 'pharov10 "PharoV10.sources" "/home/vonbecmann/bin/sources"))
(define test-artifact (artifact artifact-name "http:/download/url" 'pharov10))
(define test-vm (vm vm-name "http:/download/url" "installation-directory" "/path/to/vm"))
(define test-project (project:make-project directory-name test-vm test-artifact "./package-cache"))

(test-equal "project as string" 
	    (format #f "project at ~A based on ~A" directory-name artifact-name)
	    (let* ((string-port (open-output-string)))
	      (project:print test-project string-port) 
	      (get-output-string string-port)
	      )
)

(test-equal "project's setup script" 
	    "/test-project/set-up.st" 
	    (project:set-up-script-at test-project)
)

(test-equal "project's definition"
	    (format #f "(pb:project\n\t '~a\n\t '~a\n\t)\n" vm-name artifact-name)
	    (with-output-to-string (project:project-definition test-project))
)

(test-end)


