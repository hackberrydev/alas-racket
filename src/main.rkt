#lang racket

;; ———————————————————————————————————————————————————————————————————————————————————————————————————
;; This is the main module that starts the application.

;; This version is printed on screen when --version argument is used. Update the version before
;; release.
(define version "0.1")

;; ———————————————————————————————————————————————————————————————————————————————————————————————————
;; Import and implementation

(require gregor
         "file-repository.rkt"
         "commands.rkt")

(define days-count (make-parameter 1))
(define print-version (make-parameter #f))

(define arguments
  (command-line
    #:program "alas"
    #:usage-help "Alas is a command line TODO list manager."
    #:once-each
    [("-d" "--insert-days") n
                            "Insert the following number of future days"
                            (days-count (string->number n))]
    [("-v" "--version") "Print the version of Alas"
                        (print-version #t)]
    #:handlers (lambda (flag-accum . arguments) arguments)
    '("filename")))

(define (show-version)
  (displayln (string-append "alas version " version)))

(define (show-help-without-arguments)
  (displayln "Alas is a command line TODO list manager.")
  (displayln "Run `alas -h` to show help."))

(module+ main
  (if (empty? arguments)
    (if (print-version)
      (show-version)
      (show-help-without-arguments))
    (let* ([todo-file (first arguments)]
           [commands (list (list insert-days (+days (today) (days-count)) (today)))]
           [todo (load-todo-file todo-file)]
           [new-todo (run-commands commands todo)])
      (save-todo-file new-todo todo-file))))
