
#lang newt/config

;; Called early when Newt launches. Use this to set parameters defined
;; in newt/params.
(define/contract (init)
  (-> any)
  ;; Check if we're in local development mode
  (define local-dev? (getenv "NEWT_LOCAL"))
  
  (if local-dev?
      ;; Local development configuration
      (begin
        (current-scheme/host "http://localhost:8000/")
        (current-uri-prefix ""))
      ;; Production configuration for GitHub Pages
      (begin
        (current-scheme/host "https://megalisp.github.io/raygun/")
        (current-uri-prefix "/raygun")))
  
  (current-title "RAYGUN")
  (current-author "Joshua Steven Grant (ie: Jost Grant)"))

;; Called once per post and non-post page, on the contents.
(define/contract (enhance-body xs)
  (-> (listof xexpr/c) (listof xexpr/c))
  ;; Here we pass the xexprs through a series of functions.
  (~> xs
      (syntax-highlight #:python-executable (if (eq? (system-type) 'windows)
                                                "python.exe"
                                                "python")
                        #:line-numbers? #t
                        #:css-class "source")
      (auto-embed-tweets #:parents? #t)
      (add-racket-doc-links #:code? #t #:prose? #f)))

;; Called from `raco newt --clean`.
(define/contract (clean)
  (-> any)
  (void))
