(define (uensg:main src dst prog)
  (define (ensugar prog) (map compile-fundef prog))
  (define (compile-fundef fundef)
    (let ((body (cadddr fundef)) (parlist (cadr fundef)) (fname (car fundef)))
      `(define (,fname ,@parlist) ,(compile-exp body))))
  (define (compile-exp exp)
    (cond ((symbol? exp) exp)
          ((equal? (car exp) 'quote)
           (let ((const (cadr exp))) (if (literal? const) const exp)))
          ((equal? (car exp) 'car)
           (let ((exp1 (cadr exp)))
             (*extend-syntax-add-car* (compile-exp exp1))))
          ((equal? (car exp) 'cdr)
           (let ((exp1 (cadr exp)))
             (*extend-syntax-add-cdr* (compile-exp exp1))))
          ((equal? (car exp) 'cons)
           (let ((exp2 (caddr exp)) (exp1 (cadr exp)))
             (compile-cons (compile-exp exp1) (compile-exp exp2))))
          ((equal? (car exp) 'if)
           (let ((exp3 (cadddr exp)) (exp2 (caddr exp)) (exp1 (cadr exp)))
             (compile-if
               (compile-exp exp1)
               (compile-exp exp2)
               (compile-exp exp3))))
          ((equal? (car exp) 'call)
           (let ((exp* (cddr exp)) (fname (cadr exp)))
             `(,fname unquote (map compile-exp exp*))))
          ((equal? (car exp) 'rcall)
           (let ((exp* (cddr exp)) (fname (cadr exp)))
             `(rcall (,fname unquote (map compile-exp exp*)))))
          ((equal? (car exp) 'xcall)
           (let ((exp* (cddr exp)) (fname (cadr exp)))
             `(,fname unquote (map compile-exp exp*))))
          (else
           (let ((exp* (cdr exp)) (fname (car exp)))
             `(,fname unquote (map compile-exp exp*))))))
  (define (compile-cons exp1 exp2)
    (list 'quasiquote (cons (make-unquote exp1) (make-unquote exp2))))
  (define (make-unquote exp)
    (cond ((literal? exp) exp)
          ((and (pair? exp)
                (equal? (car exp) 'quote)
                (pair? (cdr exp))
                (null? (cddr exp)))
           (let ((c (cadr exp))) c))
          ((and (pair? exp)
                (equal? (car exp) 'quasiquote)
                (pair? (cdr exp))
                (null? (cddr exp)))
           (let ((c (cadr exp))) c))
          (else (list 'unquote exp))))
  (define (compile-if exp0 exp1 exp2)
    (cond ((and (pair? exp2)
                (equal? (car exp2) 'if)
                (pair? (cdr exp2))
                (pair? (cddr exp2))
                (pair? (cdddr exp2))
                (null? (cddddr exp2)))
           (let ((b (cadddr exp2)) (a (caddr exp2)) (p (cadr exp2)))
             `(cond (,exp0 ,exp1) (,p ,a) (else ,b))))
          ((and (pair? exp2) (equal? (car exp2) 'cond))
           (let ((clause* (cdr exp2))) `(cond (,exp0 ,exp1) unquote clause*)))
          (else `(if ,exp0 ,exp1 ,exp2))))
  (define (literal? x) (or (boolean? x) (number? x) (char? x) (string? x)))
  (newline)
  (display "-- Ensugaring:  ")
  (display src)
  (display " -> ")
  (display dst)
  (newline)
  (set! prog (ensugar prog))
  (display "-- Done --")
  (newline)
  prog)

