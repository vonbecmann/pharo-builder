(use-modules (oop goops))
(use-modules (unit-test))
(use-modules (pharo-builder tests project-test))
(use-modules (pharo-builder tests parser-test))
(use-modules (pharo-builder tests vm-test))
(use-modules (pharo-builder tests pharo-builder-test))

(exit-with-summary (run-all-defined-test-cases))