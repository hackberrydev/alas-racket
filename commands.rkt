#lang racket

(require gregor
         "entities.rkt"
         "string-repository.rkt")

(define (generate-days from-date to-date line-number)
  (let generate-days-list ([days (list)]
                           [from-date (+days from-date 1)])
    (if (date<=? from-date to-date)
      (generate-days-list (cons (day from-date (list) line-number #t) days)
                          (+days from-date 1))
      days)))

(define (insert-days days date)
  (if (empty? days)
    (generate-days (-days date 1) date 1)
    (let ([day (first days)])
      (append (generate-days (day-date day) date (day-line-number day))
              days))))

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