;; Basics of clarity

(define-read-only (say-true)
    true
)

(define-read-only (say-false) 
    false
)

(define-read-only (say-true-1)
    (not false)
)

(define-read-only (say-false-1) 
    (not true)
)

(define-read-only (add)
    (+ u2 u2)
)

(define-read-only (subtract)
    (- u4 u2)
)

(define-read-only (multiply)
    (* u6 u6)
)

(define-read-only (divide)
    (/ u5 u2)
)

(define-read-only (int-to-uint) 
    (to-uint 900)
)

(define-read-only (uint-to-int)
    (to-int u77)
)

(define-read-only (exponent)
    (pow u4 u4)
)

(define-read-only (square-root)
    (sqrti 144)
)

(define-read-only (modulo)
    (mod 90 8)
)

(define-read-only (log-two)
    (log2 67)
)

(define-read-only (greeting)
    (concat "Good Morning," " Muritadhor")
)

(define-read-only (show-some)
    (some "Rando")
)

(define-read-only (show-none)
    none
)

(define-read-only (params (num uint) (name (string-ascii 48)) (boolean bool))
    num
)

(define-read-only (optional-params (num (optional uint)) (name (optional (string-ascii 48))) (boolean (optional bool)))
    (some num)
)

(define-read-only (optional-params-ii (num (optional uint)) (name (optional (string-ascii 48))) (boolean (optional bool)))
    (and (is-some num) (is-some name) (is-some boolean))
)