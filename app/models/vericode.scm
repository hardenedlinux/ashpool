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

;; Model vericode definition of ashpool

(import (artanis mvc model)
        (app models user)
        (artanis utils))

(create-artanis-model
 vericode
 (:deps user)
 (id auto (#:primary-key))
 (code char-field (#:maxlen 64 #:unique #:not-null))
 (email_hash char-field (#:maxlen 64 #:not-null))
 (activated bool (#:not-null))
 (:indexes
  (email_hash_index (email_hash)))
 ) ; DO NOT REMOVE THIS LINE!!!

(::define (verify-activate-code rc code email)
  (:anno: (route-context string string) -> symbol)
  (cond
   (($vericode 'get '(id activated)
               #:condition (where #:code code
                                  #:email_hash (string->sha256 email)))
    (lambda (record)
      (let ((id (assoc-ref record "id"))
            (activated (assoc-ref record "activated")))
        (cond
         ((zero? activated)
          (with-transaction
           rc
           ($vericode 'set #:activated 1 #:condition (where #:id id))
           ($user 'set #:status user:normal
                  #:condition (where #:email email)))
          'code-activated)
         (else 'code-already-activated)))))
   (else 'invalid-code)))
