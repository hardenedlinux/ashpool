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

;; ALBA API - simple article operations

;; NOTE: This file was included into api module, please don't import any
;;       module here for avoiding redundant dependencies.

(api-define
    "alba/article/create"
  (options #:method 'post #:mime 'json #:with-auth api-key-auth-config)
  (lambda (rc)
    ;; get request
    (let* ((json (get-json-from-rc rc))
           (title (json-ref json "title"))
           (content (json-ref json "content"))
           (tags (tag-string->tag-list (json-ref json "tags")))
           (status (json-ref json "status"))
           (author_id (json-ref json "author_id"))
           (abstract (json-ref json "abstract"))
           (meta_description (json-ref json "meta_description"))
           (created_at (current-time))
           (article_id (gen-ulid #:time created_at))
           ;; NOTE: Put tags->tag-ids outside of transaction.
           (tag-ids (tags->tag-ids tags)))
      (let-values (((tags abstract meta_description)
                    (ask-ai-for-meta tag abstract meta_des)))
        (catch #t
          (lambda ()
            (with-transaction
             ($article 'set
                       #:title title
                       #:content content
                       #:tags tags
                       #:status status
                       #:author_id author_id
                       #:article_id article_id
                       #:abstract abstract
                       #:meta_description meta_des
                       #:created_at created_at)
             (for-each
              (lambda (tag_id)
                ($article_tag 'set
                              #:article_id article_id
                              #:tag_id tag_id))
              tag-ids))
            (:mime rc `(("message" . "Article created successfully")
                        ("status" . ,(status-enum 'ok))
                        ("article_id" . ,article_id)
                        ("seo_url" . ,seo_url)

                        )))
          (lambda (k . e)
            (format (current-error-port)
                    "[ERROR] Failed to create article: ~a (~a: ~a)~%"
                    article k e)
            (:mime rc `(("message" . "Something was wrong!")
                        ("status" . ,(status-enum 'error))))))))))
