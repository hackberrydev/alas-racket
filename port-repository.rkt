#lang racket

(require gregor
         "entities.rkt")

(define (day-title day)
  (string-append "## " (~t (day-date day) "y-MM-dd, EEEE")))

(define (build-day port line)
  (let-values ([(line-number column position) (port-next-location port)])
    (day (iso8601->date (substring line 3 13))
         (list)
         (- line-number 1)
         #f)))

(define (day-line? line) (string-prefix? line "## "))

(define (load-todo port)
  (define (load-line port days)
    (let ([line (read-line port)])
      (cond
        [(eof-object? line) (reverse days)]
        [(day-line? line) (load-line port (cons (build-day port line) days))]
        [else (load-line port days)])))
  (port-count-lines! port)
  (load-line port (list)))

(module+ test
  (require rackunit)

  (test-case
    "day-title"
    (check-equal?
      (day-title (day (date 2021 6 21) '() 1 false))
      "## 2021-06-21, Monday"))

  (test-case
    "load-todo"
    (let* ([todo (string-append "# Main TODO\n\n"
                                "## 2020-08-01, Saturday\n\n"
                                "- [ ] Develop photos\n"
                                "- [x] Pay bills\n\n"
                                "## 2020-07-31, Friday\n\n"
                                "- [x] Review open pull requests\n"
                                "- [x] Fix the flaky test")]
           [port (open-input-string todo)]
           [days (load-todo port)]
           [day-1 (list-ref days 0)]
           [day-2 (list-ref days 1)])
      (check-equal? (length days) 2)
      (check-equal? (day-date day-1) (date 2020 8 1))
      (check-equal? (day-line-number day-1) 3)
      (check-equal? (day-date day-2) (date 2020 7 31))
      (check-equal? (day-line-number day-2) 8))))
