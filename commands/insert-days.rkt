#lang racket

(require gregor
         "../entities.rkt")

(provide insert-days)

(define (insert-day days date)
  (define (day-after-date? day)
    (date>? (day-date day) date))
  (let-values ([(days-after days-before) (splitf-at days day-after-date?)])
    (let ([adjacent-day (if (empty? days-before)
                          (last days-after)
                          (first days-before))])
      (if (date=? (day-date adjacent-day) date)
        days
        (append days-after
                (list (day date (list) (day-line-number adjacent-day) #t))
                days-before)))))

; Private: Insert new days into the list of day entities. The list must be not
;          empty.
;
; days  - The list of day entities.
; date  - The date up to which new days will be generated.
; today - Date.
;
; Returns a new list of days.
(define (insert-days-in-list days date today)
  (if (date<? date today)
    days
    (insert-days (insert-day days date) (-days date 1) today)))

(define (build-first-day date)
  (list (day date (list) 1 #t)))

; Public: Insert new days into the list of day entities.
;
; days  - The list of day entities.
; date  - The date up to which new days will be generated.
; today - Date.
;
; Returns a new list of days.
(define (insert-days days date today)
  (if (empty? days)
    (build-first-day date)
    (insert-days-in-list days date today)))


(module+ test
  (require rackunit)

  (test-case
    "insert-days"
    (let* ([days (list (day (date 2020 8 3) (list) 3 #f)
                       (day (date 2020 8 2) (list) 6 #f))]
           [new-days (insert-days days (date 2020 8 4) (date 2020 8 4))]
           [day-1 (first new-days)])
      (check-equal? (length new-days) 3)
      (check-equal? (day-date day-1) (date 2020 8 4))
      (check-equal? (day-line-number day-1) 3)
      (check-true (day-changed day-1))))

  (test-case
    "insert-days with a day in the middle"
    (let* ([days (list (day (date 2020 8 5) (list) 3 #f)
                       (day (date 2020 8 2) (list) 6 #f))]
           [new-days (insert-days days (date 2020 8 4) (date 2020 8 2))]
           [day-2 (list-ref new-days 1)])
      (check-equal? (length new-days) 4)
      (check-equal? (day-date day-2) (date 2020 8 4))
      (check-equal? (day-line-number day-2) 6)
      (check-true (day-changed day-2))))

  (test-case
    "insert-days with a day that already exists"
    (let* ([days (list (day (date 2020 8 4) (list) 3 #f)
                       (day (date 2020 8 2) (list) 6 #f))]
           [new-days (insert-days days (date 2020 8 5) (date 2020 8 2))]
           [day-1 (list-ref new-days 0)]
           [day-2 (list-ref new-days 1)]
           [day-3 (list-ref new-days 2)])
      (check-equal? (length new-days) 4)
      (check-equal? (day-date day-1) (date 2020 8 5))
      (check-equal? (day-line-number day-2) 3)
      (check-true (day-changed day-1))
      (check-equal? (day-date day-2) (date 2020 8 4))
      (check-equal? (day-line-number day-2) 3)
      (check-false (day-changed day-2))
      (check-equal? (day-date day-3) (date 2020 8 3))
      (check-equal? (day-line-number day-3) 6)
      (check-true (day-changed day-3))))

  (test-case
    "insert-days with empty days list"
    (let ([days (insert-days (list) (date 2020 8 4) (date 2020 8 4))])
      (check-equal? (length days) 1)
      (check-equal? (day-date (first days)) (date 2020 8 4))))

  (test-case
    "insert-days with one day in future"
    (let* ([days (list (day (date 2020 8 5) (list) 3 #f))]
           [new-days (insert-days days (date 2020 8 4) (date 2020 8 4))]
           [day-2 (second new-days)])
      (check-equal? (length new-days) 2)
      (check-equal? (day-date day-2) (date 2020 8 4))
      (check-equal? (day-line-number day-2) 3))))
