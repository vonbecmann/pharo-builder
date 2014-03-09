(define-module (repository-test))
(use-modules (srfi srfi-64))
(use-modules (core oscommand))
(use-modules ((core repository)
		:select (print artifact-ref new-repository-for add-artifact)
		:renamer (symbol-prefix-proc 'repository:)
		))
(use-modules (api))

(test-begin "repository-test")

(define directory-name ".my-repository")
(define fmt "Repository at directory ~S ~% with artifacts: ~% ~S ~% ")
(define test-repository
	    (repository:new-repository-for directory-name)
	    )

(test-equal "repository-print-to-string"
	    (format #f fmt directory-name '())
	    (let* ((string-port (open-output-string)))
	      (repository:print test-repository string-port)
	      (get-output-string string-port)
	      )
)

(define test-source (source 'pharov10 "http:/download/url"))
(define test-artifact (artifact 'pharo-core "http:/download/url" 'pharov10))


(test-equal "artifact-ref"
	    test-artifact
	    (let* ((test-repository (repository:new-repository-for "directory-name" )))
	      (repository:add-artifact test-repository test-artifact)
	      (repository:artifact-ref test-repository 'pharo-core)
	      )
)

(test-end)