#lang racket

(require gregor
         "entities.rkt"
         "string-repository.rkt")

(provide run-commands
         insert-days)

(define (generate-days from-date to-date line-number)
  (let generate-days-list ([days (list)]
                           [from-date (+days from-date 1)])
    (if (date<=? from-date to-date)
      (generate-days-list (cons (day from-date (list) line-number #t) days)
                          (+days from-date 1))
      days)))

; Public: Insert new days into the list of day entities.
;
; days - The list of day entities.
; date - The date up to which new days will be generated.
;
; Returns a new list of days.
(define (insert-days days date)
  (if (empty? days)
    (generate-days (-days date 1) date 1)
    (let*-values ([(days-before days-after) (splitf-at
                                              days
                                              (lambda (d)
                                                (date>? (day-date d) date)))]
                  [(day) (first days-after)])
      (append days-before
              (generate-days (day-date day) date (day-line-number day))
              days-after))))

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
      (check-true (day-changed day-1))))

  (test-case
    "insert-days with a day in the middle"
    (let* ([days (list (day (date 2020 8 5) (list) 3 #f)
                       (day (date 2020 8 2) (list) 6 #f))]
           [new-days (insert-days days (date 2020 8 4))]
           [day-2 (list-ref new-days 1)])
      (check-equal? (length new-days) 4)
      (check-equal? (day-date day-2) (date 2020 8 4))
      (check-equal? (day-line-number day-2) 6)
      (check-true (day-changed day-2))))

  (test-case
    "insert-days with empty days list"
    (let ([days (insert-days (list) (date 2020 8 4))])
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
           [new-todo (run-commands (list (list insert-days (date 2020 8 3)))
                                   todo)])
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
