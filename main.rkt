#lang racket

(require gregor)

(define (read-todo-file in)
  (display (port->string in)))

(define (format-day-title date)
  (string-append "## "
                 (~a (->year date))
                 "-"
                 (~a (->month date) #:min-width 2 #:align 'right #:left-pad-string "0")
                 "-"
                 (~a (->day date) #:min-width 2 #:align 'right #:left-pad-string "0")))

(module* main #f
  (call-with-input-file "todo.md" read-todo-file))

(module+ test
  (require rackunit)
  (check-equal? (format-day-title (date 2021 6 21)) "## 2021-06-21"))
