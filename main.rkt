#lang racket

(require gregor)

(define (read-todo-file in)
  (display (port->string in)))

(define (format-day-title date)
  (string-append "## " (~t date "y-MM-dd")))

(module* main #f
  (call-with-input-file "examples/todo.md" read-todo-file))

(module+ test
  (require rackunit)

  (test-case
    "format-day-title"
    (check-equal? (format-day-title (date 2021 6 21)) "## 2021-06-21")))
