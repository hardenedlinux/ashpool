(import (artanis mvc model))
;; Model article definition of ashpool
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(create-artanis-model
 article
 (:deps)
 ((article_id auto (#:primary-key))
  (status tinyint (#:not-null)) ; 0:draft, 1:published, 2:archived)
  (author_id int (#:not-null)) ;; optional, links to author table
  (created_at bigint (#:not-null))
  (updated_at bigint (#:not-null))
  (seo_url char-field (#:maxlen 64 #:unique #:not-null)) ; immutable, AI-gen
  (meta_des char-field (#:maxlen 160)) ; AI-generated, truncated
  (meta_keys char-field (#:maxlen 255)) ; AI-generated, comma-separated
  (title text) ; mutable, server-encoded
  (abstract text) ; AI-generated abstract
  )) ; DO NOT REMOVE THIS LINE!!!
