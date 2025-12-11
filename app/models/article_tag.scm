(import (artanis mvc model))
;; Model article_tag definition of ashpool
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(create-artanis-model
 article_tag
 (:deps article tag)
 (rid auto (#:primary-key))
 (article_id int (#:not-null))
 (tag_id int (#:not-null))
 (status tinyint (#:not-null)) ; 0: active, 1: deleted, 2: forbidden
 (:primary-key (article_id tag_id))
 (:indexes
  (article_tag_index (article_id tag_id)))
 (:constrains
  (unique (article_id tag_id))) ; prevent dumplicate mapping
 ) ; DO NOT REMOVE THIS LINE!!!
