#lang racket

(require racket/date)

(define (read-todo-file in)
  (display (port->string in)))

(define (format-day-title date)
  (string-append "## "
                 (~a (date-year date))
                 "-"
                 (~a (date-month date) #:min-width 2 #:align 'right #:left-pad-string "0")
                 "-"
                 (~a (date-day date) #:min-width 2 #:align 'right #:left-pad-string "0")))

(module* main #f
  (call-with-input-file "todo.md" read-todo-file))

(module+ test
  (require rackunit)
  (check-equal? (format-day-title (current-date)) "## 2021-06-21"))
