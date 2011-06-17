(use-modules (oop goops))
(use-modules (unit-test))
(use-modules (pharo-builder tests project-test))


(exit-with-summary (run-all-defined-test-cases))