; From: https://github.com/sosy-lab/sv-benchmarks/blob/master/c/loop-lit/gj2007_true-unreach-call_true-termination.c

(set-logic LIA)

(synth-inv inv_fun ((x Int) (y Int)))

(declare-primed-var x Int)
(declare-primed-var y Int)

(define-fun pre_fun ((x Int) (y Int)) Bool
  (and (= x 0) (= y 50)))

(define-fun trans_fun ((x Int) (y Int) (x! Int) (y! Int)) Bool
  (and (< x 100)
       (ite (< x 50) (= x! (+ x 1)) (= y! y))
                     (= x! (+ x 1)) (= y! (+ y 1))))

(define-fun post_fun ((x Int) (y Int)) Bool
  (or (< x 100) (= y 100)))

(inv-constraint inv_fun pre_fun trans_fun post_fun)

(check-synth)
