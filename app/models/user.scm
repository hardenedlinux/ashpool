(import (artanis mvc model))
;; Model user definition of ashpool
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(create-artanis-model
 user
 (:deps)
 (user_id auto (#:primary-key))
 ;; User status: 0:normal, 1:pro, 2:super, 3:admin, 4:banned, 5:unverified
 (status smallint (#:unsigned #:not-null))
 (created_at bigint (#:unsigned #:not-null))
 (last_login bigint (#:unsigned #:not-null))
 (salt char-field (#:maxlen 32 #:not-null))
 (username char-field (#:maxlen 64 #:unique #:not-null))
 (password-hash char-field (#:maxlen 64 #:not-null)) ; SHA-256 hex
 (email char-field (#:maxlen 128 #:unique #:not-null))
 )

(define-public user:normal 0)
(define-public user:pro 1)
(define-public user:super 2)
(define-public user:admin 3)
(define-public user:banned 4)
(define-public user:unverified 5)
