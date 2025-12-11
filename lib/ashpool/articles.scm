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

(define-module (ashpool articles)
  #:use-module (ashpool enum)
  #:use-module (app models article_tag)
  #:use-module (artanis fprm)
  #:use-module (ice-9 match)
  #:export (tag-string->tag-list
            tags->tag-ids))

(define (tag-string->tag-list tag-str)
  (let ((tags (string-split tag-str #\,)))
    (map string-trim-both tags)))

(define (tags->tag-ids tags)
  (map (lambda (tag)
         ($tag 'set
               #:tag_name tag
               #:create_at (current-time)
               #:status (tag-status 'active)
               "on conflict(tag) do nothing")
         (match ($tag 'get '(tag_id) #:condition (where #:tag_name tag))
           ((("tag_id" . tid)) tid)
           (else (throw 'artanis-err 500 tags->tag-ids
                        "BUG: tid shoud be present after insert!"))))
       tags))
