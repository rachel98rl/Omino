;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname Testing) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #t)))
(check-expect (build-2dlist 5 6 +)
              '((0 1 2 3 4)
                (1 2 3 4 5)
                (2 3 4 5 6)
                (3 4 5 6 7)
                (4 5 6 7 8)
                (5 6 7 8 9)))

;(check-expect (lists-equiv? (all-positions 5 6)
;                            (list (make-pos 0 0)
;                                  (make-pos 1 0)
;                                  (make-pos 2 0)
;                                  (make-pos 3 0)
;                                  (make-pos 4 0)
;                                  (make-pos 0 1)
;                                  (make-pos 1 1)
;                                  (make-pos 2 1)
;                                  (make-pos 3 1)
;                                  (make-pos 4 1)
;                                  (make-pos 0 2)
;                                  (make-pos 1 2)
;                                  (make-pos 2 2)
;                                  (make-pos 3 2)
;                                  (make-pos 4 2)
;                                  (make-pos 0 3)
;                                  (make-pos 1 3)
;                                  (make-pos 2 3)
;                                  (make-pos 3 3)
;                                  (make-pos 4 3)
;                                  (make-pos 0 4)
;                                  (make-pos 1 4)
;                                  (make-pos 2 4)
;                                  (make-pos 3 4)
;                                  (make-pos 4 4)
;                                  (make-pos 0 5)
;                                  (make-pos 1 5)
;                                  (make-pos 2 5)
;                                  (make-pos 3 5)
;                                  (make-pos 4 5))) true)
 
;(check-expect (lists-equiv? (all-orientations '((#\a #\a)(#\a #\a)(#\a #\.)))
;                            (list (list (list #\. #\a #\a) (list #\a #\a #\a))
;                                  (list (list #\a #\a #\a) (list #\. #\a #\a))
;                                  (list (list #\a #\a #\.) (list #\a #\a #\a))
;                                  (list (list #\a #\a #\a) (list #\a #\a #\.))
;                                  (list (list #\. #\a) (list #\a #\a) (list #\a #\a))
;                                  (list (list #\a #\a) (list #\a #\a) (list #\. #\a))
;                                  (list (list #\a #\.) (list #\a #\a) (list #\a #\a))
;                                  (list (list #\a #\a) (list #\a #\a) (list #\a #\.)))) true)
; 
;(check-expect (first-empty-pos '((#\a #\a)(#\a #\a)(#\a #\.)))
;              (make-pos 1 2))
; 
;(check-expect (superimpose '((#\b #\. #\. #\. #\.)
;                             (#\b #\b #\b #\. #\.)
;                             (#\. #\b #\. #\. #\.))
;                           '((#\a #\a)(#\a #\a)(#\a #\.))
;                           (make-pos 0 0))
;              '((#\a #\a #\. #\. #\.)(#\a #\a #\b #\. #\.)(#\a #\b #\. #\. #\.)))
; 
;(lists-equiv? (neighbours (make-state '((#\. #\.)(#\. #\.)) '(((#\X #\X))))) (list (make-state '((#\X #\X) (#\. #\.)) empty) (make-state '((#\X #\.) (#\X #\.)) empty))) => true
(define-struct pos (x y))
;; A Pos is a (make-pos Nat Nat)

;; A Grid is a (listof (listof Char))
;; requires: both inner and outer lists of Grid are non-empty

(define-struct state (puzzle pieces))
;; A State is a (make-state Grid (listof Grid))

;; a)
(define (build-2dlist nc nr f)
  (build-list nr (lambda (i)
                   (build-list nc (lambda (j) (f i j))))))




;; b)
(define (all-positions nc nr)
  (foldr append empty (build-2dlist nc nr make-pos)))

