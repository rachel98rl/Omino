;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname polyominoes) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require "a10.rkt")

;; Uncomment the following line if you want to use
;; the examples in kanoodle.rkt
(require "kanoodle.rkt")

;; A Grid is a (listof (listof Char))
;; requires: both inner and outer lists of Grid are non-empty

(define-struct pos (x y))
;; A Pos is a (make-pos Nat Nat)

(define-struct state (puzzle pieces))
;; A State is a (make-state Grid (listof Grid))

;; A temporary neighbours function that always fails.
;; Provide only the purpose, contract and function definition.
;(define (neighbours s)
;  empty)

;; Useful constants for examples and testing
(define base1 '((#\b #\. #\. #\. #\.) (#\b #\b #\b #\. #\.)
                                                   (#\. #\b #\. #\. #\.)))
(define top1 '((#\a #\a)(#\a #\a)(#\a #\.)))


;; 1.
;; a)
;; (build-2dlist nc nr f) consumes the number of columns, nc, and number of
;;    rows of a grid, and a function that is applied to all (x y) positions
;;    corresponding to positions in the grid, in that order
;; build-2dlist: Nat Nat (Nat Nat -> X) -> (listof (listof X))
;; Examples:
(check-expect (build-2dlist 1 2 +)
              (list (list 0) (list 1)))
(check-expect (build-2dlist 2 3 -)
              (list (list 0 1) (list -1 0) (list -2 -1)))

(define (build-2dlist nc nr f)
  (build-list nr (lambda (i)
                   (build-list nc (lambda (j) (f j i))))))

;; Tests:
(check-expect (build-2dlist 2 2 make-posn)
              (list
               (list (make-posn 0 0) (make-posn 1 0))
               (list (make-posn 0 1) (make-posn 1 1))))

(check-expect (build-2dlist 5 6 +)
              '((0 1 2 3 4)
                (1 2 3 4 5)
                (2 3 4 5 6)
                (3 4 5 6 7)
                (4 5 6 7 8)
                (5 6 7 8 9)))

(check-expect (build-2dlist 3 3 =)
              (list
               (list true false false)
               (list false true false)
               (list false false true)))

;; b)
;; (all-positions nc nr) produces a list of all possible positions in a
;;    grid with the given number of columns, nc, and the given number of rows
;; all-positions: Nat Nat -> (listof Pos)
;; requires: nc and nr have to be greater than zero
;; Examples:
(check-expect (all-positions 1 1) (list (make-pos 0 0)))
(check-expect (all-positions 1 2) (list (make-pos 0 0) (make-pos 0 1)))
(define (all-positions nc nr)
  (foldr append empty (build-2dlist nc nr make-pos)))

(check-expect (lists-equiv? (all-positions 5 6)
                            (list (make-pos 0 0) (make-pos 1 0) (make-pos 2 0)
                                  (make-pos 3 0) (make-pos 4 0) (make-pos 0 1)
                                  (make-pos 1 1) (make-pos 2 1) (make-pos 3 1)
                                  (make-pos 4 1) (make-pos 0 2) (make-pos 1 2)
                                  (make-pos 2 2) (make-pos 3 2) (make-pos 4 2)
                                  (make-pos 0 3) (make-pos 1 3) (make-pos 2 3)
                                  (make-pos 3 3) (make-pos 4 3) (make-pos 0 4)
                                  (make-pos 1 4) (make-pos 2 4) (make-pos 3 4)
                                  (make-pos 4 4) (make-pos 0 5) (make-pos 1 5)
                                  (make-pos 2 5) (make-pos 3 5) (make-pos 4 5)))
              true)

;; Tests:
(check-expect (all-positions 1 1) (list (make-pos 0 0)))
(check-expect (lists-equiv? (all-positions 10 10)
              (list
               (make-pos 0 0) (make-pos 1 0) (make-pos 2 0)
               (make-pos 3 0) (make-pos 4 0) (make-pos 5 0)
               (make-pos 6 0) (make-pos 7 0) (make-pos 8 0)
               (make-pos 9 0) (make-pos 0 1) (make-pos 1 1)
               (make-pos 2 1) (make-pos 3 1) (make-pos 4 1)
               (make-pos 5 1) (make-pos 6 1) (make-pos 7 1)
               (make-pos 8 1) (make-pos 9 1) (make-pos 0 2)
               (make-pos 1 2) (make-pos 2 2) (make-pos 3 2)
               (make-pos 4 2) (make-pos 5 2) (make-pos 6 2)
               (make-pos 7 2) (make-pos 8 2) (make-pos 9 2)
               (make-pos 0 3) (make-pos 1 3) (make-pos 2 3)
               (make-pos 3 3) (make-pos 4 3) (make-pos 5 3)
               (make-pos 6 3) (make-pos 7 3) (make-pos 8 3)
               (make-pos 9 3) (make-pos 0 4) (make-pos 1 4)
               (make-pos 2 4) (make-pos 3 4) (make-pos 4 4)
               (make-pos 5 4) (make-pos 6 4) (make-pos 7 4)
               (make-pos 8 4) (make-pos 9 4) (make-pos 0 5)
               (make-pos 1 5) (make-pos 2 5) (make-pos 3 5)
               (make-pos 4 5) (make-pos 5 5) (make-pos 6 5)
               (make-pos 7 5) (make-pos 8 5) (make-pos 9 5)
               (make-pos 0 6) (make-pos 1 6) (make-pos 2 6)
               (make-pos 3 6) (make-pos 4 6) (make-pos 5 6)
               (make-pos 6 6) (make-pos 7 6) (make-pos 8 6)
               (make-pos 9 6) (make-pos 0 7) (make-pos 1 7)
               (make-pos 2 7) (make-pos 3 7) (make-pos 4 7)
               (make-pos 5 7) (make-pos 6 7) (make-pos 7 7)
               (make-pos 8 7) (make-pos 9 7) (make-pos 0 8)
               (make-pos 1 8) (make-pos 2 8) (make-pos 3 8)
               (make-pos 4 8) (make-pos 5 8) (make-pos 6 8)
               (make-pos 7 8) (make-pos 8 8) (make-pos 9 8)
               (make-pos 0 9) (make-pos 1 9) (make-pos 2 9)
               (make-pos 3 9) (make-pos 4 9) (make-pos 5 9)
               (make-pos 6 9) (make-pos 7 9)(make-pos 8 9)
               (make-pos 9 9))) true)


; 2.
;; (all-orientations grid) consumes a grid representing a single polyomino,
;;    and produces a lsit of grids contianing all distinct rotations and
;;    reflections of that polyomino
;; all-orientations: Grid -> (listof Grid)
;; Examples:
(check-expect (all-orientations '((#\a))) '(((#\a))))
(check-expect (lists-equiv? (all-orientations '((#\a #\a)))
                            '(((#\a)
                               (#\a))
                              ((#\a #\a)))) true)

(define (all-orientations grid)
  (local [(define constant (apply map list grid))
          (define constant2 (apply map list (reverse grid)))]
    (foldr (lambda (lst rrol)
             (cond
               [(member? lst rrol) rrol]
               [else (cons lst rrol)]))
           empty
           (list grid
                 (reverse grid)
                 constant
                 (reverse constant)
                 constant2
                 (reverse constant2)
                 (apply map list (reverse constant))
                 (apply map list (reverse constant2))))))


;; Tests:
(check-expect (all-orientations '((#\j))) '(((#\j))))
(check-expect (lists-equiv?
               (all-orientations '((#\a #\a #\a)
                                   (#\. #\a #\.)
                                   (#\. #\a #\.)))
               (list
                (list (list #\a #\. #\.) (list #\a #\a #\a)
                      (list #\a #\. #\.))
                (list (list #\. #\. #\a) (list #\a #\a #\a)
                      (list #\. #\. #\a))
                (list (list #\a #\a #\a) (list #\. #\a #\.)
                      (list #\. #\a #\.))
                (list (list #\. #\a #\.) (list #\. #\a #\.)
                      (list #\a #\a #\a)))) true)
(check-expect (lists-equiv?
               (all-orientations '((#\a #\a)(#\a #\a)(#\a #\.)))
               (list (list (list #\. #\a #\a) (list #\a #\a #\a))
                     (list (list #\a #\a #\a) (list #\. #\a #\a))
                     (list (list #\a #\a #\.) (list #\a #\a #\a))
                     (list (list #\a #\a #\a) (list #\a #\a #\.))
                     (list (list #\. #\a) (list #\a #\a) (list #\a #\a))
                     (list (list #\a #\a) (list #\a #\a) (list #\. #\a))
                     (list (list #\a #\.) (list #\a #\a) (list #\a #\a))
                     (list (list #\a #\a) (list #\a #\a) (list #\a #\.)))) true)


;; 3.
;; (first-empty-pos grid) consumes a grid and produces the pos of the first
;;    #\. character in the grid
;; first-empty-pos: Grid -> Pos
;; Examples:
(check-expect (first-empty-pos base1) (make-pos 1 0))
(check-expect (first-empty-pos (list (list #\. #\b #\c #\d))) (make-pos 0 0))

(define (first-empty-pos grid)
  (local [(define position (all-positions (length (first grid)) (length grid)))
          (define break (foldr append empty grid))
          ;; (first-empty-pos-new lst-of-char lst-of-position) produces the
          ;;    first #\. character in the grid by consuming a lst-of-char
          ;;    and a lst-of-position
          ;; first-empty-pos: (listof Char) (lstof Pos) -> Pos
          (define (first-empty-pos-new lst-of-char lst-of-position)
            (cond
              [(empty? lst-of-char) false]
              [(char=? #\. (first lst-of-char)) (first lst-of-position)]
              [else (first-empty-pos-new (rest lst-of-char)
                                         (rest lst-of-position))]))]
    (first-empty-pos-new break position)))

;; Tests:
(check-expect (first-empty-pos '((#\a #\a)(#\a #\a)(#\a #\.)))
              (make-pos 1 2))
(check-expect (first-empty-pos top1) (make-pos 1 2))
(check-expect (first-empty-pos '((#\a))) false)
(check-expect (first-empty-pos '((#\a #\a #\a))) false)
(check-expect (first-empty-pos '((#\X #\X #\X)
                                 (#\X #\X #\.))) (make-pos 2 1))


;; 4.
;; (superimpose base top pos) produces a new Grid in which top is laid over
;;    base such that the consumed Pos indicates the location of the upper left
;;    corner of top
;; superimpose: Grid Grid Pos -> Grid
;; Examples:
(check-expect (superimpose base1 top1 (make-pos 0 0))
              '((#\a #\a #\. #\. #\.)(#\a #\a #\b #\. #\.)
                                     (#\a #\b #\. #\. #\.)))
(check-expect (superimpose '((#\. #\.)) '((#\a #\a)) (make-pos 0 0))
              '((#\a #\a)))

(define (superimpose base top pos)
  (local [;; dictionary produces an association list of the character
          ;;   as the key and shifted positions according to the given
          ;;   pos as the value
          (define dictionary
            (local [(define positions
                      (all-positions (length (first top)) (length top)))
                    (define break (foldr append empty top))
                    (define shifted-positions
                      (map (lambda (x) (make-pos (+ (pos-x x) (pos-x pos))
                                                 (+ (pos-y x) (pos-y pos))))
                           positions))]
              (map (lambda (x y) (list x y)) break shifted-positions)))

          ;; (find key-pos dictionary) produces the character period if the
          ;;    key-pos is not in the dictionary and produces the character
          ;;    accociated in the key-pos
          ;; find: Pos (listof (list Char Pos)) -> Char
          (define (find key-pos dictionary)
            (cond [(empty? dictionary) #\.]
                  [(equal? key-pos (second (first dictionary)))
                   (first (first dictionary))]
                  [else (find key-pos (rest dictionary))]))

          ;; (shifted-top base top pos) produces the shifted graph of the top
          ;;    according to the given pos, and the shifted top are in bound
          ;;    of the base
          ;; shifted-top: Grid Grid Pos -> Grid
          (define (shifted-top base top pos)
            (build-2dlist (length (first base)) (length base)
                          (lambda (x y) (find (make-pos x y) dictionary))))]

    (map (lambda (x y)
           (map (lambda (a b) (cond
                                [(char=? #\. b) a]
                                [else b]))
                x y))
         base (shifted-top base top pos))))

;; Tests:
(check-expect (superimpose base1 top1 (make-pos 3 0))
              '((#\b #\. #\. #\a #\a)(#\b #\b #\b #\a #\a)
                                     (#\. #\b #\. #\a #\.)))

(check-expect (superimpose base1 top1 (make-pos 4 1))
              '((#\b #\. #\. #\. #\.)(#\b #\b #\b #\. #\a)
                                     (#\. #\b #\. #\. #\a)))

(check-expect (superimpose base1 top1 (make-pos 5 0)) base1)
(check-expect (superimpose base1 base1 (make-pos 0 0)) base1)
(check-expect (superimpose
               '((#\b #\b #\b #\b #\b) (#\b #\b #\b #\b #\b)
                                       (#\b #\b #\b #\b #\b))
               top1 (make-pos 2 2))(list
                                    (list #\b #\b #\b #\b #\b)
                                    (list #\b #\b #\b #\b #\b)
                                    (list #\b #\b #\a #\a #\b)))


;; 5.
;; (neighbours state) consumes a single State and produces a list of States
;;    in which one additional polyomino has been placed in the puzzle and
;;    removed from the list of pieces yet to be placed
;; neighbours: State -> (listof State)

(define (neighbours state)
  (local [;; (empty-pos top-row) produces the number of period
          ;;    characters before the first non-period character
          ;; empty-pos: (listof Char) -> Nat
          (define (empty-pos top-row)
            (cond
              [(empty? top-row) 0]
              [(not (char=? #\. (first top-row))) 0]
              [else (+ 1 (empty-pos (rest top-row)))]))
          (define pos (first-empty-pos (state-puzzle state)))

          ;; (dictionary/top base top) produces an association list with pos of
          ;;    top as key and characters of top as values where the pos are
          ;;    shifted according to the first empty position of base
          ;; dictionary/top: Grid Grid -> (listof (list Char Pos))
          (define (dictionary/top base top)
            (local [(define positions
                      (all-positions (length (first top)) (length top)))
                    (define break (foldr append empty top))
                    (define shifted-positions
                      (map (lambda (x) (make-pos (+ (pos-x x) (pos-x pos)
                                                    (- (empty-pos (first top))))

                                                 (+ (pos-y x) (pos-y pos))))
                           positions))]
              (map (lambda (x y) (list x y)) break shifted-positions)))

          ;; (remove-empty-pos base top) produces a list of pos that does not
          ;;    have the character of period from the base and top
          ;; remove-al-char: Grid Grid -> (listof Pos)
          (define (remove-al-char base top)
            (map (lambda (lst) (second lst))
                 (filter (lambda (lst)
                           (not (char=? #\. (first lst))))
                         (dictionary/top base top))))

          ;; (dictionary/base base) produces an association list with pos of
          ;;    base as key and characters of base as values
          ;; dictionary/base: Grid -> (listof (list Char Pos))
          (define (dictionary/base base)
            (local [(define positions (all-positions (length (first base))
                                                     (length base)))
                    (define break (foldr append empty base))]
              (map (lambda (x y) (list x y)) break positions)))

          ;; (valid? base top) is a predicate that check if the top can be
          ;;    legally placed onto the base
          ;; Grid Grid -> Bool
          (define (valid? base top)
            (local [;; (lookup-not-dot base pos) produces the dictionary value
                    ;;    of base that has the key of pos that doesn't have the
                    ;;    character of period
                    ;; Grid Pos -> (anyof empty (list (list Char Pos)))
                    (define (lookup-not-dot base pos)
                      (filter (lambda (x)
                                (equal? pos (second x)))
                              (dictionary/base base)))]

              (andmap (lambda (x)
                        (cond
                          [(empty? (lookup-not-dot base x)) false]
                          [else
                           (char=? #\.
                                   (first (first (lookup-not-dot base x))))]))
                      (remove-al-char base top))))

          ;; (new-grid base top) produces a new grid that combine the base and
          ;;    top if the top can be legally placed onto the base, and produces
          ;;    empty otherwise
          ;; new-grid: Grid Grid -> Grid
          (define (new-grid base top)
            (local
              [(define pos (first-empty-pos base))]
              (cond
                [(valid? base top)
                 (superimpose base top
                              (make-pos (- (pos-x pos) (empty-pos (first top)))
                                        (pos-y pos)))]
                [else empty])))]
    (cond
      [(empty? pos) empty]
      [else
          (foldr append empty
                 (map (lambda (pieces)
                        (filter (lambda (x) (cons? (state-puzzle x)))
                                (map (lambda (x)
                                       (make-state (new-grid (state-puzzle state) x)
                                                   (filter (lambda (x) (not (equal? x pieces)))
                                                           (state-pieces state))))
                                     (all-orientations pieces)))) (state-pieces state)))])))


;; 6.
;; (solve-puzzle grid polys viz-style)
;;    Solve a polyomino puzzle, given the initially empty (or partially filled
;;    in) grid, a set of pieces that must be placed, and a Symbol indicating
;;    what visualization style to use.  Legal viz styles are 'interactive
;;    (draw every step of the search), 'at-end (just draw the solution, if one
;;    is found), or 'offline (don't draw anything).  Produce either the solved
;;    Grid (converted to a list of Strings, just for convenience) or false if
;;    no solution exists.

;; solve-puzzle: Grid (listof Grid) Sym -> (anyof (listof Str) false)
;; requires: viz-style is one of {'interactive, 'at-end or 'offline}

;; Some Examples are included below after the solve-puzzle function definition.

;; DO NOT MODIFY THIS CODE
(define (solve-puzzle grid polys viz-style)
  (local
    [(define result
       (search
        (lambda (S) (empty? (state-pieces S)))
        neighbours
        (cond
          [(symbol=? viz-style 'interactive)
           (lambda (S) (draw-grid (state-puzzle S)))]
          [else false])
        (make-state grid polys)))

     (define maybe-last-draw
       (cond
         [(and (state? result)
               (symbol=? viz-style 'at-end))
          (draw-grid (state-puzzle result))]
         [else false]))]
    (cond
      [(boolean? result) result]
      [else (map list->string (state-puzzle result))])))


;; Solve offline (i.e. work like a normal Scheme function).
(solve-puzzle
  (strlist->grid '("...." "...." "...." "...." "...." "...."))
  (cons '((#\L #\L) (#\. #\L)) (cons '((#\O)) tetrominoes-uc))
  'offline)

;; Display the result graphically, if a solution is found.
(solve-puzzle
  (strlist->grid '("...." "...." "...." "...." "...." "...."))
  (cons '((#\L #\L) (#\. #\L)) (cons '((#\O)) tetrominoes-uc))
  'at-end)

;; Display every step of the search as it progresses.
(solve-puzzle
  (strlist->grid '("...." "...." "...." "...." "...." "...."))
  (cons '((#\L #\L) (#\. #\L)) (cons '((#\O)) tetrominoes-uc))
  'interactive)
