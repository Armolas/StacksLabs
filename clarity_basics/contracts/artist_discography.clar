;; Artist Discography
;; 

;;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars & Maps ;;
;;;;;;;;;;;;;;;;;;;;;;;

(define-constant admin tx-sender)

;; Track data
(define-map track {artist: principal, album-id: uint, track-id: uint}
    {
        track-title: (string-ascii 24),
        duration: uint,
        featured: (optional principal)
    }
)

;; Album data
(define-map album {artist: principal, album-id: uint}
    {
        album-title: (string-ascii 24),
        tracks: (list 20 uint),
        height-published: uint
    }
)

;; Discography data
(define-map discography {artist: principal} {albums: (list 10 uint)})


;;;;;;;;;;;;;;;;;;;;
;; Read Functions ;;
;;;;;;;;;;;;;;;;;;;;

;; Gets the discography of an artist
(define-read-only (get-discography (artist principal))
    (map-get? discography {artist: artist})
)

;; Gets a particular artist album using the album id
(define-read-only (get-album (artist principal) (album-id uint))
    (map-get? album {artist: artist, album-id: album-id})
)

;; Gets the deatils of a particular track in an album
(define-read-only (get-track (artist principal) (album-id uint) (track-id uint))
    (map-get? track {artist: artist, album-id: album-id, track-id: track-id})
)

;;;;;;;;;;;;;;;;;;;;;
;; Write Functions ;;
;;;;;;;;;;;;;;;;;;;;;

;; This function adds a track to an album
(define-public (add-track (artist principal) (album-id uint) (track-title (string-ascii 24)) (duration uint) (featured (optional principal)))
    (let
        (
            (track-album (unwrap! (get-album artist album-id) (err u0)))
            (track-id (len (unwrap! (get tracks (get-album artist album-id)) (err u1))))
            (album-tracks (unwrap! (get tracks (get-album artist album-id)) (err u1)))
        )
        (asserts! (or (is-eq tx-sender admin) (is-eq tx-sender artist)) (err u2))
        (asserts! (<= duration u300) (err u3))
        (map-set track {artist: artist, album-id: album-id, track-id: track-id}
            {
                track-title: track-title,
                duration: duration,
                featured: featured
            }
        )
        (ok (map-set album {artist: artist, album-id: album-id}
            (merge track-album
                {tracks: (unwrap! (as-max-len? (append album-tracks track-id) u20) (err u4))}
            )
        ))
    )
)

(define-public (create-album
                    (artist principal)
                    (album-title (string-ascii 24))
                )
    (let
        (
            (artist-discography (map-get? discography {artist: artist}))
            (album-id (len (default-to (list ) (get albums artist-discography))))
        )
        (asserts! (or (is-eq tx-sender admin) (is-eq tx-sender artist)) (err u2))
        (map-set album {artist: artist, album-id: album-id}
                {
                    album-title: album-title,
                    tracks: (list ),
                    height-published: block-height
                }
        )
        (ok (if (is-none artist-discography)
            (map-set discography {artist: artist}
                {albums: (list album-id)}
            )
            (map-set discography {artist: artist}
                (merge
                    (unwrap! artist-discography (err u6))
                    {albums: (unwrap! (as-max-len? (append (get albums (unwrap! artist-discography (err u6))) album-id) u10) (err u7))}
                )
            )
        ))
    )
)

(define-data-var number-list (list 10 uint) (list u1 u2 u3 u4 u5))

(define-public (append-to-num-list (num uint))
    (ok (var-set 
            number-list 
            (unwrap!
                (as-max-len? (append (var-get number-list) num) u5) 
                (err u7)
            )
        )
    )
)
