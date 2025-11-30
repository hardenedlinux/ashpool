;; Controller login definition of ashpool
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(define-artanis-controller login) ; DO NOT REMOVE THIS LINE!!!

(import (app models user)
        (artanis security nss))

(define (auth-checker usr pw)
  (let ((usr_base64 (nss:base64-encode usr)))
    (cond
     (($user 'get '(password_hash salt)
             #:condition (where #:username_base64 usr_base64))
      => (lambda (record)
           (let ((salt (assoc-ref record "salt"))
                 (password-hash (assoc-ref record "password_hash")))
             (cond
              ((string=? password-hash
                         (string->sha256 (string-append usr pw salt)))
               ($user 'set #:last_login (current-timestamp)
                      #:condition (where #:username_base64 usr_base64))
               #t)
              #f))))
     (else #f))))

(login-define
 "auth"
 #:auth '(post "username" "password" auth-checker)
 #:session #t
 (lambda (rc)
   ))
