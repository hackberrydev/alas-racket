#lang racket

(require gregor)

(define (format-day-title date)
  (string-append "## " (~t date "y-MM-dd")))

(module+ test
  (require rackunit)

  (test-case
    "format-day-title"
    (check-equal? (format-day-title (date 2021 6 21)) "## 2021-06-21")))
