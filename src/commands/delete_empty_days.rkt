#lang racket

;; ———————————————————————————————————————————————————————————————————————————————————————————————————
;; This module implements a command for deleting empty days that are in past.

(provide
  ;; Deletes empty days in past.
  ;;
  ;; (delete-empty-days days today)
  ;;
  ;; days  - The list of day entities.
  ;; today - date.
  ;;
  ;; Returns a new list of days.
  delete-empty-days)

;; ———————————————————————————————————————————————————————————————————————————————————————————————————
;; Import and implementation

(require gregor
         "../entities.rkt")

(define (delete-empty-days days today)
  '())

(module+ test
  (require rackunit)

  (test-case
    "delete-empty-days with empty days in past"
    (define days (list (day (date 2020 8 3) (list) 3 #f)
                       (day (date 2020 8 2) (list (task "Order food" "" #f 7 #f)) 6 #f)
                       (day (date 2020 8 1) (list) 8 #f)
                       (day (date 2020 7 31) (list (task "Write a blog post" "" #t 10 #f)) 9 #f)))
    (define new-days (delete-empty-days days (date 2020 8 5)))
    (check-equal? (length new-days) 2)
    (check-equal? (day-date (first new-days)) (date 2020 8 2))
    (check-equal? (day-date (second new-days)) (date 2020 7 31)))

  (test-case
    "delete-empty-days with an empty day in future"
    (define days (list (day (date 2020 8 3) (list) 3 #f)
                       (day (date 2020 8 2) (list (task "Order food" "" #f 7 #f)) 6 #f)))
    (define new-days (delete-empty-days days (date 2020 8 3)))
    (check-equal? (length new-days) 2)))
