#lang racket

(provide (struct-out day)
         (struct-out task))

(struct day (date tasks line-number position changed) #:mutable)
(struct task (title body done line-number changed) #:mutable)
