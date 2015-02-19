#lang racket
(require web-server/servlet
         web-server/servlet-env)

(define-struct getpost (url fn))

(define-syntax listen
  (syntax-rules ()
    ((listen port (path -> fn) ...)
     (serve/servlet (lambda (req)
                      (let* ((url (url->string (request-uri req)))
                             (funx (list (make-getpost path fn) ...))
                             (matching (filter (lambda (x) (string=? url (getpost-url x))) funx)))
                        (cond ((empty? matching) (response/xexpr '(html (head (title "error: 404"))
                                                                        (body (p "404: not found")))))
                              (else ((getpost-fn (first matching)) req)))))
                    #:port port
                    #:servlet-regexp #rx"/*"
                    #:stateless? #t
                    #:launch-browser? #f
                    #:command-line? #t))))

(define-syntax html
  (syntax-rules ()
    ((html title b)
     (response/xexpr '(html (head title)
                     (body b))))))

(define (hello-world req)
  (response/xexpr
   `(html (head (title "Hello world!"))
          (body (p "hello world")))))

(define (goodbye-world req)
  (response/xexpr
   `(html (head (title "Goodbye world!"))
          (body (p "good bye world")))))

(provide listen)
(provide html)
(provide hello-world)
(provide goodbye-world)

