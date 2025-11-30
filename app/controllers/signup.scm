;;  -*-  indent-tabs-mode:nil; coding: utf-8 -*-
;;  Copyright (C) 2025
;;      Roy Mu <roy@hardenedlinux.org>
;;  This file is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU Affero General Public License
;;  published by the Free Software Foundation, either version 3 of the
;;  License, or (at your option) any later version.

;;  This file is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU Affero General Public License for more details.

;;  You should have received a copy of the GNU Affero General Public License
;;  along with this program.
;;  If not, see <http://www.gnu.org/licenses/>.

;; Controller signup definition of ashpool
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(define-artanis-controller signup) ; DO NOT REMOVE THIS LINE!!!

(import (artanis sendmail)
        (artanis runner)
        (artanis irregex)
        (artanis third-party json)
        (artanis security hash)
        (ice-9 iconv)
        (ashpool utils)
        (web uri)
        (app models vericode)
        (app models user))

(define (gen-login-page rc)
  (let ((failed (params rc "failed")))
    (view-render "login" (the-environment))))

(define *pw-regex*
  (string->irregex
   "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=[\\]{};':\"\\\\|,.<>/?]).{8,}$"))
(define (verify-password password)
  (irregex-search *pw-regex* password))

(define (gen-verification-link code email)
  (format #f "https://~a/signup/verify?email=~a&code=~a"
          (conf-get '(host name))
          (uri-encode email)
          code))

(signup-define
 "verify-email"
 (lambda (rc)
   (let* ((email (uri-decode (params rc "email")))
          (code (params rc "code"))
          (email_hash (string->sha256 email))
          (email_base32 (base32-encode email)))
     (cond
      (($vericode 'get '(activated)
                  #:conditions (where #:code code #:email_hash email_hash))
       => (lambda (record)
            (let ((activated (assoc-ref record "activated")))
              (cond
               ((zero? activated)
                (with-transaction
                 rc
                 ($user 'set #:status user:free
                        #:conditions (where #:email_base32 email_base32))
                 ($vericode 'set #:activated 1
                            #:conditions (where #:code code #:email_hash email_hash))))
               (else
                (throw 'artanis-err 400 'signup-verify-emailx
                       "This verification code has already been used!"))))))
      (eles
       (throw 'artanis-err 400 'signup-verify-email
              "Invalid verification code or email address!"))))))

(signup-define
 "submit"
 (options #:method 'post)
 (lambda (rc)
   (let* ((data (get-json-from-rc rc))
          (username_base32 (base32-encode (json-ref data "username")))
          (password (json-ref data "password"))
          (email (json-ref data "email"))
          (email_hash (string->sha256 email))
          (email_base32 (base32-encode (uri-encode email)))
          (salt (get-random-from-dev #:length 32))
          (password_hash (gen-pw-hash username password salt)))
     (when (not (verify-password password))
       (throw 'artanis-err 400 'signup "Invalid password format! `~a`!"
              password))
     (let ((code (get-random-from-dev #:length 64)))
       (with-transaction
        rc
        ($vericode 'set #:code code #:email_hash email_hash
                   #:activated 0)
        ($user 'set #:username_base32 username_base32
               #:password password_hash
               #:email_base32 email_base32
               #:status user:unverified
               #:salt salt
               #:created-at (current-time)))

       ;; Send mail
       (call-with-runner
        (lambda ()
          ((send-auto-mail email)
           (format #f "Please click the link to verify your email:~%~%~a~%"
                   (gen-verification-link code email))
           #:subject "[No Reply] Please verify your email address!")))))))
