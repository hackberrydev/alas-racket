#lang racket

(require gregor
         "file-repository.rkt"
         "commands.rkt")

(module+ main
  (let* ([commands (list (list insert-days (today)))]
         [todo (load-todo-file "examples/todo.md")]
         [new-todo (run-commands commands todo)])
    (save-todo-file new-todo "examples/todo.md")))
