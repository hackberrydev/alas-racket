#lang racket

(provide load-todo-file
         save-todo-file)

(define (load-todo-file path)
  (call-with-input-file path port->string))

(define (save-todo-file todo path)
  (let ([copy-path (string-append path ".copy")])
    (call-with-output-file
      copy-path
      (lambda (out) (display todo out)))
    (copy-file copy-path path #t)
    (delete-file copy-path)))
