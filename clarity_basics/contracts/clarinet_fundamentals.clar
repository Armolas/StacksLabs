;; Fundamentals of clarinet
;; constants and variables
(define-constant fav-num u25)
(define-constant fav-name "Jenny")
(define-data-var num uint u88)
(define-data-var name (string-ascii 20) "Jennifer")

(define-read-only (constant-num)
    fav-num
)

(define-read-only (constant-name)
    fav-name
)

(define-read-only (var-num)
    (* (var-get num) u2)
)

(define-read-only (var-name)
    (concat "Hi, the variable name is " (var-get name))
)

(define-public (change-num (new-num uint))
    (ok (var-set num new-num))
)

(define-public (change-name (new-name (string-ascii 20)))
    (ok (var-set name new-name))
)

(define-read-only (read-tuple)
    {
        user-name: "Armolas",
        user-principal: 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5,
        user-balance: u1000
    }
)

(define-public (write-tuple (new-user-name (string-ascii 24)) (new-user-principal principal) (new-user-balance uint))
    (ok {
        user-name: new-user-name,
        user-principal: new-user-principal,
        user-balance: new-user-balance
    })
)

(define-data-var original
    {
        user-name: (string-ascii 24),
        user-principal: principal,
        user-balance: uint
    } ;; data-type
    {
        user-name: "Armolas",
        user-principal: 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5,
        user-balance: u1000
    } ;; data-value
)

(define-read-only (read-tuple-i)
    (var-get original)
)

(define-public (write-tuple-i (new-user-name (string-ascii 24)) (new-user-principal principal) (new-user-balance uint))
    (ok (merge
            (var-get original)
            {
            user-name: new-user-name,
            user-principal: new-user-principal,
            user-balance: new-user-balance
            }
        )
    )
)

(define-public (write-name (new-user-name (string-ascii 24)))
    (ok (merge
            (var-get original)
            {user-name: new-user-name}
        )
    )
)
(define-public (write-balance (new-user-balance uint))
    (ok (merge
            (var-get original)
            {user-balance: new-user-balance}
        )
    )
)
(define-constant admin  'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
(define-read-only (show-sender)
    tx-sender
)
(define-read-only (check-admin)
    (is-eq admin tx-sender)
)
(define-constant admin-i tx-sender)
(define-constant not_authorized (err u1))
(define-data-var user (string-ascii 24) "Armolas")

(define-read-only (assert-admin)
    (ok (asserts! (is-eq admin-i tx-sender) not_authorized))
)

(define-data-var hello-name (string-ascii 48) "Muritadhor Arowolo")
(define-read-only (show-name)
    (var-get hello-name)
)
(define-public (say-hello-name (h-name (string-ascii 48)))
    (begin
        (asserts! (not (is-eq h-name "")) (err u1))
        (asserts! (not (is-eq h-name (var-get hello-name))) (err u2))
        (var-set hello-name h-name)
        (ok (concat "Hello there, " (var-get hello-name)))
    )
)

(define-data-var counter uint u0)
(define-read-only (show-counter) 
    (var-get counter)
)
(define-public (incr-counter (incr-num uint))
    (begin
        (asserts! (is-eq (mod incr-num u2) u0) (err u3))
        (var-set counter (+ (var-get counter) incr-num))
        (ok (var-get counter))
    )
)