#lang racket

(require gregor
         "file-repository.rkt"
         "commands.rkt")

(define days-count (make-parameter 1))

(define todo-file
  (command-line
    #:program "alas"
    #:usage-help
    "Alas is a command line TODO list manager"
    #:once-each
    [("-d" "--insert-days") n
                            "Insert the following number of future days"
                            (days-count (string->number n))]
    #:args (filename)
    filename))

(module+ main
  (let* ([commands (list (list insert-days (+days (today) (days-count)) (today)))]
         [todo (load-todo-file todo-file)]
         [new-todo (run-commands commands todo)])
    (save-todo-file new-todo todo-file)))
