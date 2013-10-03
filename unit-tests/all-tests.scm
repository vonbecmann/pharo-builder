(use-modules (srfi srfi-64))
(use-modules (project-test))
(use-modules (parser-test))
(use-modules (pharo-builder-test))
(use-modules (oscommand-test))
(use-modules (artifact-test))
(use-modules (repository-test)) 
(use-modules (source-test))

(exit (= (test-runner-fail-count (test-runner-current)) 0))



