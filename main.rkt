#lang racket

(define (read-todo-file in)
  (display (port->string in)))

(module* main #f
  (call-with-input-file "todo.md" read-todo-file))
