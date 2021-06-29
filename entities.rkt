#lang racket

(struct day (date tasks line changed) #:mutable)
(struct task (title body done line changed) #:mutable)
