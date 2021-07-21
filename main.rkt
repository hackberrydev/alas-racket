#lang racket

(require "file-repository.rkt")

(module* main #f
  (let* ([todo (load-todo-file "examples/todo.md")]
         [new-todo (string-append todo "\n\nThe End")])
    (save-todo-file new-todo "examples/todo.md")))
