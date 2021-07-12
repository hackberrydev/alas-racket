#lang racket

(require gregor
         "entities.rkt")

(define (save-day day port)
  (set-port-next-location! port (day-line-number day) 0 (day-position day))
  (display (day-title day) port)
  (display "\n" port))

(define (save-todo days port)
  (port-count-lines! port)
  (for-each (curryr save-day port)
            (filter day-changed days)))

(module+ test
  (require rackunit)

  (test-case
    "save-todo"
    (let* ([todo (string-append "# Main TODO\n\n"
                                "## 2020-08-01, Saturday\n\n"
                                "- [ ] Develop photos\n"
                                "- [x] Pay bills\n\n"
                                "## 2020-07-31, Friday\n\n"
                                "- [x] Review open pull requests\n"
                                "- [x] Fix the flaky test")]
           [port (open-output-string)]
           [days (list (day (date 2020 8 2) (list) 3 14 #t)
                       (day (date 2020 8 1) (list) 3 14 #f)
                       (day (date 2020 7 31) (list) 8 77 #f))])
      (display todo port)
      (save-todo days port)
      (check-equal? (get-output-string port)
                    (string-append "# Main TODO\n\n"
                                   "## 2020-08-02, Sunday\n\n"
                                   "## 2020-08-01, Saturday\n\n"
                                   "- [ ] Develop photos\n"
                                   "- [x] Pay bills\n\n"
                                   "## 2020-07-31, Friday\n\n"
                                   "- [x] Review open pull requests\n"
                                   "- [x] Fix the flaky test")))))
