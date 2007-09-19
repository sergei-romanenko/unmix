(define (uresfn:collect-residual-functions fndef*)
  (define (sep-rf fndef* rf)
    (if (null? fndef*)
      '()
      (let ((rest (cdr fndef*)) (fundef (car fndef*)))
        (let ((fn (car fundef)))
          (if (memq fn rf)
            `(,fn unquote (sep-rf rest rf))
            (sep-rf rest rf))))))
  (define (collect-rf-fndef* fndef* rf)
    (if (null? fndef*)
      rf
      (let ((rest (cdr fndef*)) (fndef (car fndef*)))
        (let ((rf (collect-rf-fndef fndef rf))) (collect-rf-fndef* rest rf)))))
  (define (collect-rf-fndef fndef rf)
    (let ((body (car (cddddr fndef)))) (collect-rf-exp body rf)))
  (define (collect-rf-exp exp rf)
    (cond ((let ((vname exp)) (symbol? vname)) (let ((vname exp)) rf))
          ((equal? (car exp) 'static) (let ((s-exp (cadr exp))) rf))
          ((equal? (car exp) 'ifs)
           (let ((exp3 (cadddr exp)) (exp2 (caddr exp)) (exp1 (cadr exp)))
             (let ((rf (collect-rf-exp exp2 rf))) (collect-rf-exp exp3 rf))))
          ((equal? (car exp) 'ifd)
           (let ((exp3 (cadddr exp)) (exp2 (caddr exp)) (exp1 (cadr exp)))
             (let* ((rf (collect-rf-exp exp1 rf))
                    (rf (collect-rf-exp exp2 rf)))
               (collect-rf-exp exp3 rf))))
          ((equal? (car exp) 'call)
           (let ((d-exp* (cadddr exp)) (s-exp* (caddr exp)) (fn (cadr exp)))
             (collect-rf-exp* d-exp* rf)))
          ((equal? (car exp) 'rcall)
           (let ((d-exp* (cadddr exp)) (s-exp* (caddr exp)) (fn (cadr exp)))
             (let ((rf (if (memq fn rf) rf `(,fn unquote rf))))
               (collect-rf-exp* d-exp* rf))))
          ((equal? (car exp) 'xcall)
           (let ((exp* (cddr exp)) (fname (cadr exp)))
             (collect-rf-exp* exp* rf)))
          (else
           (let ((exp* (cdr exp)) (op (car exp))) (collect-rf-exp* exp* rf)))))
  (define (collect-rf-exp* exp* rf)
    (if (null? exp*)
      rf
      (let ((rest (cdr exp*)) (exp (car exp*)))
        (let ((rf (collect-rf-exp exp rf))) (collect-rf-exp* rest rf)))))
  (let ((fn (caar fndef*)))
    (let ((%%119 (collect-rf-fndef* fndef* `(,fn))))
      (let ((rf %%119)) (sep-rf fndef* rf)))))

