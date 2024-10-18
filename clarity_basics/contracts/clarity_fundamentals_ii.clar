;; clarity_fundamentals_ii

;;;;;;;;;;;
;; LISTS ;;
;;;;;;;;;;;

(define-read-only (num-list)
    (list u1 u2 u3 u4 u5)
)

(define-data-var list-num (list 10 uint) (list u1 u2 u3 u4 u5))
(define-data-var list-name (list 10 (string-ascii 24)) (list "Muritadhor" "Simisola" "Olasunkanmi" "Opeyemi" "Eniola"))
(define-data-var list-principal (list 10 principal) (list tx-sender 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG))


(define-read-only (read-list)
    (var-get list-num)
)

(define-read-only (find-index (name (string-ascii 24)))
    (index-of (var-get list-name) name)
)

(define-read-only (find-principal (index uint))
    (element-at (var-get list-principal) index)
)

(define-public (add-to-list (num uint))
    (ok (var-set list-num
        (unwrap! (as-max-len? (append (var-get list-num) num) u10) (err u5)))
    )
)

(define-constant profile 
    {
        user-principal: tx-sender,
        user-name: (some "Armolas"),
        user-balance: u5000,
        user-bio: none
    }
)

(define-read-only (get-principal)
    (get user-principal profile)
)

(define-read-only (get-bio)
    (default-to (some "user bio empty") (get user-bio profile))
)

(define-read-only (check-even (num uint))
    (if (is-eq (mod num u2) u0)
        "number is even"
        "number is odd"
    )
)

(define-read-only (check-match (input (response uint uint)))
    (match input match-true 
        "Match okay"
        match-none
        "Match not good"
    )
)
(define-map first-map principal {
    username: (string-ascii 24),
    balance: uint,
    referrer: (optional principal)
})

(define-read-only (read-map (user principal))
    (map-get? first-map user)
)

(define-public (set-map (new-username (string-ascii 24)) (new-balance uint) (new-referrer (optional principal)))
    (ok (map-set first-map tx-sender {
        username: new-username,
        balance: new-balance,
        referrer: new-referrer
    }))
)

(define-map tuple-map {user: principal, username: (string-ascii 24)}
    {
        username: (string-ascii 24),
        balance: uint,
        referrer: (optional principal)
    }
)

(define-read-only (read-tuple-map (details {user: principal, username: (string-ascii 24)}))
    (map-get? tuple-map details)
)

(define-map user-balance (string-ascii 24) uint)

(define-public (update-balance (username (string-ascii 24)) (balance uint))
    (ok (map-insert user-balance username balance))
)

(define-read-only (read-balance (username (string-ascii 24)))
    (map-get? user-balance username)
)

(define-public (delete-balance (username (string-ascii 24)))
    (ok (map-delete user-balance username))
)

(define-data-var count uint u0)

(define-map counter-history uint {user: principal, counter: uint})

(define-public (increase-count (increase-by uint))
    (let
        (
            (current-count (var-get count))
            (current-history (default-to {user: tx-sender, counter: u0} (map-get? counter-history current-count)))
            (previous-user (get user current-history))
            (current-counter (get counter current-history))
        )
        (if (and (is-eq previous-user tx-sender) (> current-count u0))
        (err "tx-sender is current last counter user")
        (begin
            (map-set counter-history current-count {user: tx-sender, counter: (+ increase-by current-counter)})
            (ok (var-set count (+ current-count u1)))
        )
        )
    )
)

(define-read-only (read-history (index uint))
    (map-get? counter-history index)
)

(define-read-only (get-balance (account principal))
    (stx-get-balance account)
)

(define-public (transfer (recipient principal) (amount uint))
    (stx-transfer? amount tx-sender recipient)
)

(define-public (send-to-contract (amount uint))
    (stx-transfer? amount tx-sender (as-contract tx-sender))
)

(define-public (send-from-contract (amount uint) (recipient principal))
    (as-contract (stx-transfer? amount tx-sender recipient))
)