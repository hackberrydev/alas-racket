#lang racket

(provide read-todo-file)

(define (read-todo-file in)
  (display (port->string in)))
