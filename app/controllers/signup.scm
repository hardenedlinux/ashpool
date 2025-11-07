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
        (artanis third-party json)
        (ice-9 iconv)
        (ashpool utils)
        (app models vericode)
        (app models user))

(define (gen-login-page rc)
  (let ((failed (params rc "failed")))
    (view-render "login" (the-environment))))

(signup-define
 "submit"
 (lambda (rc)
   (let* ((data (get-json-from-rc rc))
          (username (json-ref data "username"))
          (password (json-ref data "password"))
          (email (json-ref data "email")))
     (when (not (verify-password password))
       (throw 'artanis-err 400 'signup "Invalid password format! `~a`!"
              password))
     (let ((code (get-random-from-dev #:length 64)))
       ($vericode 'set #:code code #:email_hash (string->sha256 email)
                  #:activated 0)
       ;; TODO: send mail
       ))))
