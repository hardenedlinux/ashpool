(import (artanis mvc model))
;; Model tag definition of ashpool
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(create-artanis-model
 tag
 (:deps)
 (tag_id auto (#:primary-key))
 (tag_name char-field (#:maxlen 100 #:not-null #:unique))
 (created_at bigint (#:unsigned #:not-null))
 (status tinyint (#:not-null)) ; 0: inactive, 1: active, 2: forbidden
 ) ; DO NOT REMOVE THIS LINE!!!
