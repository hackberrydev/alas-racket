#lang racket

(provide load-todo-file)

(define (load-todo-file path)
  (call-with-input-file path port->string))
