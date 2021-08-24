#lang racket

;; ———————————————————————————————————————————————————————————————————————————————————————————————————
;; This module implements functions for parsing a TODO string to entities and serializing entities to
;; a string.

(provide
  ;; Parse a string to entities.
  parse
  ;; Serialize entities to a string. All passed days are serialized, so the collection needs to incled
  ;; only changed days.
  serialize)

;; ———————————————————————————————————————————————————————————————————————————————————————————————————
;; Import and implementation

(require gregor
         "entities.rkt")

(define (day-title day)
  (string-append "## " (~t (day-date day) "y-MM-dd, EEEE") "\n"))

(define (day-title? line) (string-prefix? line "## 2"))

(define (build-day line line-number)
  (day (iso8601->date (substring line 3 13))
       (list)
       line-number
       #f))

(define (parse todo)
  (let parse-line ([todo-lines (string-split todo "\n")]
                   [days (list)]
                   [line-number 0])
    (if (empty? todo-lines)
      (reverse days)
      (let ([line (first todo-lines)]
            [todo-lines (rest todo-lines)]
            [line-number (+ line-number 1)])
        (cond
          [(day-title? line) (parse-line
                               todo-lines
                               (cons (build-day line line-number) days)
                               line-number)]
          [else (parse-line todo-lines days line-number)])))))

(define (serialize days todo)
  (define (insert-day? days current-line)
    (and (not (empty? days))
         (= (day-line-number (first days)) current-line)))
  (let insert-days ([days days]
                    [todo-lines (string-split todo "\n")]
                    [new-todo-lines (list)]
                    [current-line 1])
    (if (empty? todo-lines)
      (string-join (reverse new-todo-lines) "\n")
      (if (insert-day? days current-line)
        (insert-days (rest days)
                     todo-lines
                     (cons (day-title (first days)) new-todo-lines)
                     current-line)
        (insert-days days
                     (rest todo-lines)
                     (cons (first todo-lines) new-todo-lines)
                     (+ current-line 1))))))

;; ———————————————————————————————————————————————————————————————————————————————————————————————————
;; Tests

(module+ test
  (require rackunit)

  (test-case
    "day-title"
    (check-equal?
      (day-title (day (date 2021 6 21) '() 1 false))
      "## 2021-06-21, Monday\n"))

  (test-case
    "parse"
    (let* ([todo (string-append "# Main TODO\n\n"
                                "## Inbox"
                                "- [ ] Fix the lamp\n\n"
                                "## 2020-08-01, Saturday\n\n"
                                "- [ ] Develop photos\n"
                                "- [x] Pay bills\n\n"
                                "## 2020-07-31, Friday\n\n"
                                "- [x] Review open pull requests\n"
                                "- [x] Fix the flaky test")]
           [days (parse todo)]
           [day-1 (list-ref days 0)]
           [day-2 (list-ref days 1)])
      (check-equal? (length days) 2)
      (check-equal? (day-date day-1) (date 2020 8 1))
      (check-equal? (day-line-number day-1) 5)
      (check-false (day-changed day-1))
      (check-equal? (day-date day-2) (date 2020 7 31))
      (check-equal? (day-line-number day-2) 10)
      (check-false (day-changed day-2))))

  (test-case
    "serialize"
    (let* ([todo (string-append "# Main TODO\n\n"
                                "## 2020-08-01, Saturday\n\n"
                                "- [ ] Develop photos\n"
                                "- [x] Pay bills\n\n"
                                "## 2020-07-31, Friday\n\n"
                                "- [x] Review open pull requests\n"
                                "- [x] Fix the flaky test")]
           [days (list (day (date 2020 8 3) (list) 3 #t)
                       (day (date 2020 8 2) (list) 3 #t))])
      (check-equal? (serialize days todo)
                    (string-append "# Main TODO\n\n"
                                   "## 2020-08-03, Monday\n\n"
                                   "## 2020-08-02, Sunday\n\n"
                                   "## 2020-08-01, Saturday\n\n"
                                   "- [ ] Develop photos\n"
                                   "- [x] Pay bills\n\n"
                                   "## 2020-07-31, Friday\n\n"
                                   "- [x] Review open pull requests\n"
                                   "- [x] Fix the flaky test")))))
