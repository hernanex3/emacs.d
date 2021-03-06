(setq cider-repl-display-help-banner nil)
(defun clojure:namespace-refresh ()
  (interactive)
  (save-some-buffers)
  (cider-interactive-eval
   "(ns user)
    (require 'clojure.tools.namespace.repl)
    (clojure.tools.namespace.repl/set-refresh-dirs 
      \"src/main/clojure\" \"src\"
      \"src/test/clojure\" \"test\"
      \"src-dev/clj\")
    (when (resolve 'dev/stop)
      (print :stop-app (eval '(dev/stop))))
    (let [refresh-result (clojure.tools.namespace.repl/refresh)]
      (when-not (instance? java.lang.Exception refresh-result)
        (when (resolve 'dev/start)
          (print :start-app (eval '(dev/start)))))
      (print (.toString refresh-result))
      (.toString refresh-result))"))

(cider-auto-test-mode 1)
(defun clojure:run-tests ()
  (interactive)
  (cider-test-run-project-tests))

(defun clojure:connect-repl ()
  (interactive)
  (cider-connect "localhost" 4005))

(defun clojure:start-clojurescript ()
  (interactive)
  (cider-interactive-eval
   "(ns user)
    (println \"Starting clojurescript, please stand by...\")
    (use 'figwheel-sidecar.repl-api)
    (start-figwheel!)
    (println \"Clojurescript ready!... now you can connect\")"))

(defun clojure:connect-clojurescript-repl ()
  (interactive)
  (cider-interactive-eval "(ns user) (cljs-repl)"))

(defun cloure:quit-clojurescript ()
  (interactive)
  (cider-interactive-eval
   ":cljs/quit"))

(defun clojure:config-shortcuts ()
  (cl-flet ((d (key func)
	       (let ((keymap (kbd key)))
		 (define-key clojure-mode-map keymap func)
		 (define-key cider-repl-mode-map keymap func)
		 (define-key cider-mode-map keymap func))))
    (d "C-c d"     'cider-doc)
    (d "C-c C-c"   'cider-eval-defun-at-point)
    (d "C-c s r"   'cider-restart)
    (d "C-c r"     'clojure:namespace-refresh)
    (d "C-c t"     'clojure:run-tests)
    (d "C-c M-j"   'cider-jack-in)
    (d "C-c M-x"   'clojure:connect-repl)
    (d "C-c TAB"   'company-complete)
    (d "C-c SPC"   'helm-company)
    (d "C-c j s"   'clojure:start-clojurescript)
    (d "C-c j c"   'clojure:connect-clojurescript-repl)
    (d "C-c j q"   'cloure:quit-clojurescript)))

(defun clojure:hook ()
  (cider-mode)
  (require 'cider-eval-sexp-fu)
  (lisp:edit-modes)
  (clojure:config-shortcuts)
  (yas-minor-mode 1)
  (clj-refactor-mode 1))

(defun clojure:repl-hook ()
  (company-mode t)
  (paredit-mode t)
  (projectile-mode t))

(add-hook 'clojure-mode-hook 'clojure:hook)
(add-hook 'cider-repl-mode-hook 'clojure:repl-hook)

(setq cider-repl-clear-help-banner nil)
