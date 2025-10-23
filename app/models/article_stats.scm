(import (artanis mvc model))
;; Model article_stats definition of ashpool
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(create-artanis-model
 article_stats
 (:deps)
 (article_id auto (#:primary-key))
 (read_count bigint (#:unsigned #:not-null))
 (fav_count bigint (#:unsigned #:not-null))
 (like_count bigint (#:unsigned #:not-null))
 (share_count bigint (#:unsigned #:not-null))
 ) ; DO NOT REMOVE THIS LINE!!!
