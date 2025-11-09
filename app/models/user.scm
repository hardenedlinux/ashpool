(import (artanis mvc model))
;; Model user definition of ashpool
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(create-artanis-model
 user
 (:deps)
 (user_id auto (#:primary-key))
 ;; Status: 0:free, 1:pro, 2:business, 3:admin, 4:banned, 5:unverified
 (status smallint (#:unsigned #:not-null))
 (created_at bigint (#:unsigned #:not-null))
 (last_login bigint (#:unsigned #:not-null))
 (salt char-field (#:maxlen 32 #:not-null))
 ;; we store username in base64
 (username_base64 char-field (#:maxlen 64 #:unique #:not-null))
 ;; password_hash is SHA-256 hex digest of (username + password + salt)
 (password_hash char-field (#:maxlen 64 #:not-null)) ; SHA-256 hex
 ;; we don't store email addresses directly
 ;; email_hash = base64(uri-encode(email))
 (email_base64 char-field (#:maxlen 512 #:unique #:not-null))
 (indexes
  (email_index (email))
  (username_index (username))
  (last_login_index (last_login))))

(define-public user:free 0)
(define-public user:pro 1)
(define-public user:super 2)
(define-public user:admin 3)
(define-public user:banned 4)
(define-public user:unverified 5)
