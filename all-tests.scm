(use-modules (oop goops))
(use-modules (unit-test))
(use-modules (pharo-builder tests project-test))
(use-modules (pharo-builder tests parser-test))

(exit-with-summary (run-all-defined-test-cases))