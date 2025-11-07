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

(define-module (ashpool policy)
  #:use-module (artanis env)
  #:use-module (artanis route)
  #:use-module (srfi srfi-1)
  #:export (current-ashpool-policy
            policy-check
            init-policy))

(define (get-policy-path)
  (format #f "~a/sys/policy/policy.scm" (current-toplevel)))

(define (load-policy)
  (let ((path (get-policy-path)))
    (when (not (file-exists? path))
      (throw 'artanis-err 500 load-policy "Policy file not found: ~a" path))
    (call-with-input-file path read)))

(define current-ashpool-policy
  (make-parameter "BUG: uninitialized ashpool policy"))

(define (create-policy-table policy)
  ;; TODO: According to our benchmark, hash-table is no better than alist
  ;;       in 50 elements scale, so we use alist here.
  policy)

;; E.g.
;; (("articles:read"
;;   (GET "/api/v1/articles"
;;        "/api/v1/articles/:id")))
;;
;; (policy-check "articles:read" rc) => #t/#f
;;
;; NOTE: We check rhk rather than path to avoid redundant regex matching.
;;

(define (check-one-policy rule method policy)
  (cond
   ((assoc-ref (current-ashpool-policy) policy)
    => (lambda (mlst)
         (cond
          ((assoc-ref mlst method)
           => (lambda (plst)
                (member rule plst)))
          (else #f))))
   (else #f)))

(::define (policy-check policy-list rc)
  (:anno: (list route-context) -> boolean)
  (let ((rule (rc-rhk rc))
        (method (rc-method rc)))
    (any (lambda (policy)
           (check-one-policy rule method policy))
         policy-list)))

(define (init-policy)
  (let ((policy (load-policy)))
    (current-ashpool-policy
     (create-policy-table policy))))
