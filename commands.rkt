#lang racket

(require gregor
         "entities.rkt"
         "string-repository.rkt")

(provide run-commands
         insert-days)

(define (insert-day days date)
  (define (day-after-date? day)
    (date>? (day-date day) date))
  (let*-values ([(days-after days-before) (splitf-at days day-after-date?)])
    (if (empty? days-before)
      (list (day date (list) 1 #t))
      (if (date=? (day-date (first days-before)) date)
        days
        (append days-after
                (list (day date (list) (day-line-number (first days-before)) #t))
                days-before)))))

; Public: Insert new days into the list of day entities.
;
; days  - The list of day entities.
; date  - The date up to which new days will be generated.
; today - Date.
;
; Returns a new list of days.
(define (insert-days days date today)
  (if (date<? date today)
    days
    (insert-days (insert-day days date) (-days date 1) today)))

; Public: Runs commands on a todo.
;
; commands-and-arguments - A list of lists. Each list has a command function as
;                          the first item and arguments as other items.
;                          Arguments will be passed to the function.
; todo                   - The string with the current version of a todo.
;
; Returns a new String that contains a new version of a todo that was result of
; applying commands on the original todo.
(define (run-commands commands-and-arguments todo)
  (let* ([days (parse todo)]
         [all-days (foldl (lambda (command-and-arguments days)
                        (let ([command (first command-and-arguments)]
                              [arguments (rest command-and-arguments)])
                          (apply command (cons days arguments))))
                      days
                      commands-and-arguments)])
    (serialize (filter day-changed all-days) todo)))

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
    "run-commands"
    (let* ([todo (string-append "# Main TODO\n\n"
                                "## 2020-08-01, Saturday\n\n"
                                "- [ ] Develop photos\n"
                                "- [x] Pay bills\n\n"
                                "## 2020-07-31, Friday\n\n"
                                "- [x] Review open pull requests\n"
                                "- [x] Fix the flaky test")]
           [commands (list (list insert-days (date 2020 8 3) (date 2020 8 2)))]
           [new-todo (run-commands commands todo)])
      (check-equal? new-todo
                    (string-append "# Main TODO\n\n"
                                   "## 2020-08-03, Monday\n\n"
                                   "## 2020-08-02, Sunday\n\n"
                                   "## 2020-08-01, Saturday\n\n"
                                   "- [ ] Develop photos\n"
                                   "- [x] Pay bills\n\n"
                                   "## 2020-07-31, Friday\n\n"
                                   "- [x] Review open pull requests\n"
                                   "- [x] Fix the flaky test")))))
