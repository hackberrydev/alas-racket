#lang racket

;; ———————————————————————————————————————————————————————————————————————————————————————————————————
;; The module implements functions for saving and loading a todo from a file.

(provide
  ;; Load a todo file to a string.
  load-todo-file
  ;; Save a string to a file.
  save-todo-file)

;; ———————————————————————————————————————————————————————————————————————————————————————————————————
;; Import and implementation

(define (load-todo-file path)
  (call-with-input-file path port->string))

(define (save-todo-file todo path)
  (let ([copy-path (string-append path ".copy")])
    (call-with-output-file
      copy-path
      (lambda (out) (display todo out)))
    (copy-file copy-path path #t)
    (delete-file copy-path)))
