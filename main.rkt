#lang racket

(require gregor
         "file-repository.rkt"
         "commands.rkt")

(module+ main
  (let* ([commands (list (list insert-days (+days (today) 2) (today)))]
         [file-path (vector-ref (current-command-line-arguments) 0)]
         [todo (load-todo-file file-path)]
         [new-todo (run-commands commands todo)])
    (save-todo-file new-todo file-path)))
