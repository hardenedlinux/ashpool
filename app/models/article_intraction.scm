(import (artanis mvc model))
;; Model article_intraction definition of ashpool
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(create-artanis-model
 article_intraction
 (:deps)
 (ineraction_id auto (#:primary-key))
 (article_id int (#:not-null))
 (user_id int (#:not-null))
 (action tinyint (#:not-null)) ; 0: nothing, 1: like, 2: store
 (created_at bigint (#:not-null))
 (:constrains
  (unique article_id user_id action)) ; prevent duplicate like
 ) ; DO NOT REMOVE THIS LINE!!!
