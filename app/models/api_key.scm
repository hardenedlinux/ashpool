(import (artanis mvc model)
        (artanis irregex)
        (artanis route))
;; Model api_key definition of ashpool
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(export api-key-gen
        api-key-policy-check)

(create-artanis-model
 api_key
 (:deps user)
 ((id auto (#:primary-key))
  (user_id int (#:not-null))
  ;; 0=invalid, 1=valid
  (valid boolean (#:no-null))
  (created_at bigint (#:not-null))
  (expires_at bitint (#:not-null))
  (salt char-field (#:maxlen 8 #:not-null))
  (pre char-field (#:maxlen 16 #:not-null))
  ;; hash is a sha256 hash of (pre + body + salt + policy)
  (hash char-field (#:maxlen 64 #:unique #:not-null))
  (policy text (#:not-null))
  (:indexes
   (#:unique hash_index hash)
   (#:unique user_id_index user_id)))
 ); DO NOT REMOVE THIS LINE!!!

;; ash-key-<pre>-<body>
(define (api-key-gen)
  (string-concatenate `("ash-key-" ,(get-random-from-dev #:length 16)
                        "-" ,(get-random-from-dev #:length 23))))

(define *api-key-re* (string->irregex "ash-key-([a-z0-9]+)-([0-9a-z]+)"))

(define-syntax-rule (is-expired? expires-at)
  (<= expires-at (current-timestamp)))

;; We don't store the key directly, but the hash of (key + salt + policy)
;; To validate an api key, we need to:
;; 1. Parse the api-key into (pre, body).
;; 2. Get (hash, salt, policy) from DB where pre equals.
;; 3. Check if expired.
;; 4. Compute sha256 hash of (pre + body + salt + policy).
;; 5. Compare computed hash with stored hash.
;; This is a little safer if the DB was leaked.

(define (get-record-of-api-key pre)
  (cond
   (($api_key 'get '(hash salt policy expires_at status)
              #:condition (where #:pre pre))
    => (lambda (rows) (car rows)))
   (else #f)))

(define (get-policy-if-api-key-valid pre key)
  (let ((row (get-record-of-api-key pre))
        (salt (assoc-ref row "salt"))
        (policy (assoc-ref row "policy"))
        (hash (assoc-ref row "hash"))
        (expires_at (assoc-ref row "expires_at"))
        (status (assoc-ref row "status")))
    (cond
     ((is-expired? expires_at)
      (when (= status 1)
        ($api_key 'set #:status 0 #:condition (where #:pre pre)))
      #f)
     ((string=? hash (string->sha256
                      (string-concatenate `(,pre ,key ,salt ,policy))))
      policy)
     (else #f))))

(::define (api-key-policy-check api-key rc)
  (:anno: (string route-context) -> boolean)
  (cond
   ((irregex-search *api-key-re* api-key)
    (lambda (m)
      (let ((pre (irregex-match-substring m 1))
            (body (irregex-match-substring m 2)))
        (cond
         ((get-policy-if-api-key-valid pre body)
          => (lambda (policy)
               (polich-check (string-split policy #:\,) rc)))
         (else
          ;; Invalid key
          #f)))))
   (else
    ;; Invalid format
    #f)))
