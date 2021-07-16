#lang racket

(require gregor
         "entities.rkt")

(define (generate-days from-date to-date line-number)
  (let generate-days-list ([days (list)]
                           [from-date (+days from-date 1)])
    (if (date<=? from-date to-date)
      (generate-days-list (cons (day from-date (list) line-number #t) days)
                          (+days from-date 1))
      days)))

(define (insert-days days date)
  days)

(module+ test
  (require rackunit)

  (test-case
    "generate-days"
    (let* ([days (generate-days (date 2020 8 3) (date 2020 8 4) 12)]
           [day-1 (first days)])
      (check-equal? (length days) 1)
      (check-equal? (day-date day-1) (date 2020 8 4))))

  (test-case
    "insert-days"
    (let* ([days (list (day (date 2020 8 3) (list) 3 #f)
                       (day (date 2020 8 2) (list) 6 #f))]
           [new-days (insert-days days (date 2020 8 4))]
           [day-1 (first new-days)])
      (check-equal? (length new-days) 3)
      (check-equal? (day-date day-1) (date 2020 8 4))
      (check-equal? (day-line-number day-1) 3)
      (check-true (day-changed day-1)))))
