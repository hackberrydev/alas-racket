#lang racket

(require "file-repository.rkt")

(module* main #f
  (display (load-todo-file "examples/todo.md")))
