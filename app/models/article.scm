(import (artanis mvc model))
;; Model article definition of ashpool
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(create-artanis-model
 article
 (:deps)
 ((article_id auto (#:primary-key))
  (seo_url char-field (#:maxlen 64 #:unique #:not-null)) ; immutable, AI-gen
  (title text) ; mutable, server-encoded
  (abstract text) ; AI-generated abstract
  (meta_description char-field (#:maxlen 160)) ; AI-generated, truncated
  (created_at bigint (#:not-null))
  (updated_at bigint (#:not-null))
  (author_id bigint) ;; optional, links to author table
  (status SMALLINT NOT NULL DEFAULT 0) ;; e.g., 0=draft, 1=published, 2=archived)
  ) ; DO NOT REMOVE THIS LINE!!!
