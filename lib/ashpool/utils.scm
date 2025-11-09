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

(define-module (ashpool utils)
  #:use-module (artanis route)
  #:use-module (artanis third-party json)
  #:use-module (artanis tpl)
  #:use-module (artanis config)
  #:use-module (artanis utils)
  #:export (get-json-from-rc
            send-auto-mail
            gen-pw-hash))

(define (get-json-from-rc rc)
  (json-string->scm (bytevector->string (rc-body rc) "utf-8")))

(define (send-auto-mail to subject)
  (let ((from ((get-conf '(custom mail-from)))))
    (make-simple-mail-sender from to #:subject subject)))

(define (gen-pw-hash username password salt)
  (string->sha256 (string-concatenate (list username password salt))))
