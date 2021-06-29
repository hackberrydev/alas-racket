#lang racket

(provide (struct-out day)
         (struct-out task))

(struct day (date tasks line changed) #:mutable)
(struct task (title body done line changed) #:mutable)
