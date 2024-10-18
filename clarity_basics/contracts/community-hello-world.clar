
;; community-hello-world
;; This is a community contract with a billboard where aproved users can update the billboard

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; constants, vars and maps ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The principal of the contract deployer
(define-constant admin tx-sender)

;; The principal of the next user to update the billboard
(define-data-var next-user principal tx-sender)

;; The information of the new user
(define-data-var billboard {user-principal: principal, user-name: (string-ascii 48)}
    {
        user-principal: tx-sender,
        user-name: ""
    }
)


;;;;;;;;;;;;;;;;;;
;; error values ;;
;;;;;;;;;;;;;;;;;;

(define-constant ERR-SENDER-NOT-ADMIN (err u0))

(define-constant ERR-ADMIN-CANNOT-BE-NEXT-USER (err u1))

(define-constant ERR-CANNOT-DUPLICATE-NEXT-USER (err u2))

(define-constant ERR-SENDER-NOT-NEXT-USER (err u3))

(define-constant ERR-USER-NAME-CANNOT-BE-EMPTY (err u4))

;;;;;;;;;;;;;;;;;;;;
;; read functions ;;
;;;;;;;;;;;;;;;;;;;;

;; function that gets the next user to update the billboard
(define-read-only (get-next-user)
    (var-get next-user)
)

;; function that gets the information on the billboard
(define-read-only (get-billboard)
    (var-get billboard)
)



;;;;;;;;;;;;;;;;;;;;;
;; write functions ;;
;;;;;;;;;;;;;;;;;;;;;

;; function that sets the next user to update the billboard
(define-public (set-next-user (next-user-principal principal))
    (begin
        ;; assert that it is the admin trying to set the next user
        (asserts! (is-eq tx-sender admin) ERR-SENDER-NOT-ADMIN)

        ;; assert the next-user-principal is NOT the admin
        (asserts! (not (is-eq next-user-principal admin)) ERR-ADMIN-CANNOT-BE-NEXT-USER)

        ;; assert that the next user principal is NOT the current next user
        (asserts! (not (is-eq next-user-principal (var-get next-user))) ERR-CANNOT-DUPLICATE-NEXT-USER)

        ;; set next-user-principal as next user
        (ok (var-set next-user next-user-principal))
    )
)

;; function that updates the billboard by the next user
(define-public (update-billboard (next-user-name (string-ascii 48)))
    (begin
        ;; assert that the tx-sender is the next user
        (asserts! (is-eq tx-sender (var-get next-user)) ERR-SENDER-NOT-NEXT-USER)

        ;; asserts that the next-user-name is not an empty string
        (asserts! (not (is-eq next-user-name "")) ERR-USER-NAME-CANNOT-BE-EMPTY)

        ;; update the billboard with the new user info
        (ok (var-set billboard 
            {
                user-principal: tx-sender,
                user-name: next-user-name
            }
        ))
    )
)