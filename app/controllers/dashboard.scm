;; Controller dashboard definition of ashpool
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(define-artanis-controller dashboard) ; DO NOT REMOVE THIS LINE!!!

(define (gen-login-page rc)
  (let ((failed (params rc "failed")))
    (view-render "login" (the-environment))))

(dashboard-define
 ""
 #:with-auth gen-login-page
 (lambda (rc)
   ))
