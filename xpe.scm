(define ($specialize-fundef ann-prog conf)
  (let ((s-prog (caddr ann-prog)) (d-prog (cadr ann-prog)) (rf (car ann-prog)))
    (if (null? conf)
      (car rf)
      (let ((svv (cdr conf)) (fname (car conf)))
        ($check-function rf s-prog d-prog fname svv)))))

(define ($check-function rf s-prog d-prog fname svv)
  (if (null? rf)
    '()
    (let ((rf-rest (cdr rf)) (rf-fname (car rf)))
      (if (eq? fname rf-fname)
        ($gen-res-fundef (assq rf-fname d-prog) s-prog d-prog svv)
        ($check-function rf-rest s-prog d-prog fname svv)))))

(define ($gen-res-fundef fundef s-prog d-prog svv)
  (let ((body (car (cddddr fundef)))
        (dvn (caddr fundef))
        (svn (cadr fundef))
        (fname (car fundef)))
    (let ((%%110 ($contract-svv svn svv)))
      (let ((svv %%110))
        (let ((%%111 ($pe-exp body svn dvn svv dvn s-prog d-prog)))
          (let ((new-body %%111)) `(,dvn ,new-body)))))))

(define ($contract-svv svn svv)
  (if (null? svn)
    '()
    (let ((rest (cdr svn)))
      `(,(car svv) unquote ($contract-svv rest (cdr svv))))))

(define ($pe-exp exp svn dvn svv dvv s-prog d-prog)
  (cond ((symbol? exp) ($lookup-value exp dvn dvv))
        ((equal? (car exp) 'static)
         (let ((exp1 (cadr exp))) `',($eval-exp exp1 svn svv s-prog)))
        ((equal? (car exp) 'ifs)
         (let ((exp3 (cadddr exp)) (exp2 (caddr exp)) (exp1 (cadr exp)))
           (if ($eval-exp exp1 svn svv s-prog)
             ($pe-exp exp2 svn dvn svv dvv s-prog d-prog)
             ($pe-exp exp3 svn dvn svv dvv s-prog d-prog))))
        ((equal? (car exp) 'ifd)
         (let ((exp3 (cadddr exp)) (exp2 (caddr exp)) (exp1 (cadr exp)))
           `(if ,($pe-exp exp1 svn dvn svv dvv s-prog d-prog)
              ,($pe-exp exp2 svn dvn svv dvv s-prog d-prog)
              ,($pe-exp exp3 svn dvn svv dvv s-prog d-prog))))
        ((equal? (car exp) 'call)
         (let ((d-exp* (cadddr exp)) (s-exp* (caddr exp)) (fname (cadr exp)))
           ($pe-call
             (assq fname d-prog)
             ($eval-exp* s-exp* svn svv s-prog)
             ($pe-exp* d-exp* svn dvn svv dvv s-prog d-prog)
             s-prog
             d-prog)))
        ((equal? (car exp) 'rcall)
         (let ((d-exp* (cadddr exp)) (s-exp* (caddr exp)) (fname (cadr exp)))
           `(call (,fname unquote ($eval-exp* s-exp* svn svv s-prog))
                  unquote
                  ($pe-exp* d-exp* svn dvn svv dvv s-prog d-prog))))
        ((equal? (car exp) 'xcall)
         (let ((exp* (cddr exp)) (fname (cadr exp)))
           `(xcall ,fname
                   unquote
                   ($pe-exp* exp* svn dvn svv dvv s-prog d-prog))))
        (else
         (let ((exp* (cdr exp)) (fname (car exp)))
           `(,fname unquote ($pe-exp* exp* svn dvn svv dvv s-prog d-prog))))))

(define ($pe-exp* exp* svn dvn svv dvv s-prog d-prog)
  (if (null? exp*)
    '()
    (let ((rest (cdr exp*)) (exp (car exp*)))
      `(,($pe-exp exp svn dvn svv dvv s-prog d-prog)
        unquote
        ($pe-exp* rest svn dvn svv dvv s-prog d-prog)))))

(define ($pe-call fundef svv dvv s-prog d-prog)
  (let ((body (car (cddddr fundef))) (dvn (caddr fundef)) (svn (cadr fundef)))
    ($pe-exp body svn dvn svv dvv s-prog d-prog)))

(define ($eval-exp exp svn svv prog)
  (cond ((symbol? exp) ($lookup-value exp svn svv))
        ((equal? (car exp) 'quote) (let ((s-exp (cadr exp))) s-exp))
        ((equal? (car exp) 'if)
         (let ((exp3 (cadddr exp)) (exp2 (caddr exp)) (exp1 (cadr exp)))
           (if ($eval-exp exp1 svn svv prog)
             ($eval-exp exp2 svn svv prog)
             ($eval-exp exp3 svn svv prog))))
        ((equal? (car exp) 'call)
         (let ((exp* (cddr exp)) (fname (cadr exp)))
           ($eval-call prog (assq fname prog) ($eval-exp* exp* svn svv prog))))
        ((equal? (car exp) 'xcall)
         (let ((exp* (cddr exp)) (fname (cadr exp)))
           (xapply fname ($eval-exp* exp* svn svv prog))))
        ((equal? (car exp) 'error)
         (let ((exp* (cdr exp)))
           (error "Error function encountered during partial evaluation"
                  `(error unquote ($eval-exp* exp* svn svv prog)))))
        ((equal? (car exp) 'car)
         (let ((exp1 (cadr exp))) (car ($eval-exp exp1 svn svv prog))))
        ((equal? (car exp) 'cdr)
         (let ((exp1 (cadr exp))) (cdr ($eval-exp exp1 svn svv prog))))
        ((equal? (car exp) 'cons)
         (let ((exp2 (caddr exp)) (exp1 (cadr exp)))
           (cons ($eval-exp exp1 svn svv prog) ($eval-exp exp2 svn svv prog))))
        ((equal? (car exp) 'null?)
         (let ((exp1 (cadr exp))) (null? ($eval-exp exp1 svn svv prog))))
        ((equal? (car exp) 'pair?)
         (let ((exp1 (cadr exp))) (pair? ($eval-exp exp1 svn svv prog))))
        ((equal? (car exp) 'equal?)
         (let ((exp2 (caddr exp)) (exp1 (cadr exp)))
           (equal? ($eval-exp exp1 svn svv prog)
                   ($eval-exp exp2 svn svv prog))))
        ((equal? (car exp) 'eq?)
         (let ((exp2 (caddr exp)) (exp1 (cadr exp)))
           (eq? ($eval-exp exp1 svn svv prog) ($eval-exp exp2 svn svv prog))))
        ((equal? (car exp) 'eqv?)
         (let ((exp2 (caddr exp)) (exp1 (cadr exp)))
           (eqv? ($eval-exp exp1 svn svv prog) ($eval-exp exp2 svn svv prog))))
        ((equal? (car exp) 'not)
         (let ((exp1 (cadr exp))) (not ($eval-exp exp1 svn svv prog))))
        (else
         (let ((exp* (cdr exp)) (fname (car exp)))
           (xapply fname ($eval-exp* exp* svn svv prog))))))

(define ($eval-exp* exp* svn svv prog)
  (if (null? exp*)
    '()
    (let ((rest (cdr exp*)) (exp (car exp*)))
      `(,($eval-exp exp svn svv prog)
        unquote
        ($eval-exp* rest svn svv prog)))))

(define ($eval-call prog fundef svv)
  (let ((body (cadddr fundef)) (svn (cadr fundef)))
    ($eval-exp body svn svv prog)))

(define ($lookup-value vname vn vv)
  (let ((vvtl (cdr vv)) (vvhd (car vv)) (vntl (cdr vn)) (vnhd (car vn)))
    (if (eq? vnhd vname) vvhd ($lookup-value vname vntl vvtl))))

