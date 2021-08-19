#lang racket

(require gregor
         "entities.rkt"
         "string-repository.rkt"
         "commands/insert-days.rkt")

(provide run-commands
         insert-days)

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
