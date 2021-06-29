#lang racket

(require "file-repository.rkt")

(module* main #f
  (call-with-input-file "examples/todo.md" read-todo-file))
