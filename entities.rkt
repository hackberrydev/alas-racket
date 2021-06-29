#lang racket

(struct day (date tasks line changed))
(struct task (title body done line changed))
