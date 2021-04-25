(defun barremacs/run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

(defun barremacs/set-wallpaper ()
  (interactive)
  (start-process-shell-command
   "feh" nil "feh --bg-scale Wallpapers/wallpapers/0133.jpg"))




(defun barremacs/exwm-init-hook ()
  ;;Make workspace 1 be the one where you land at startup
  (exwm-workspace-switch-create 1)

  ;; (display-battery-mode 1)
  ;; (setq display-time-day-and-date t)
  ;; (display-time-mode 1)

  (barremacs/start-panel)

  (barremacs/run-in-background "nm-applet")
  (barremacs/run-in-background "pasystray")
  (barremacs/run-in-background "blueman-applet"))



(defun barremacs/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

(defun barremacs/exwm-update-title ()
  (pcase exwm-class-name
    ("firefox" (exwm-workspace-rename-buffer (format "Firefox: %s" exwm-title)))))

(defun barremacs/configure-window-by-class ()
  (interactive)
  (pcase exwm-class-name
    ("firefox" (exwm-workspace-move-window 2))
    ("discord" (exwm-workspace-move-window 3))
    ("Spotify" (exwm-workspace-move-window 4))))
                                        ;("Gnome-calculator" (exwm-floating-toggle-floating)
                                        ;(exwm-layout-toggle-mode-line))

(defun barremacs/update-displays ()
  (barremacs/run-in-background "autorandr --change --force")
  (barremacs/set-wallpaper)
  (message "Display config is %s"
           (string-trim (shell-command-to-string "autorandr --current"))))


(use-package exwm
  :config
  ;; Set the default number of workspaces
  (setq exwm-workspace-number 5)

  ;; When window "class" updates, use it to set the buffer name
  (add-hook 'exwm-update-class-hook #'barremacs/exwm-update-class)
  (add-hook 'exwm-update-title-hook #'barremacs/exwm-update-title)

  (add-hook 'exwm-manage-finish-hook #'barremacs/configure-window-by-class)

  ;;Do extra configuration when starting EXWM
  (add-hook 'exwm-init-hook #'barremacs/exwm-init-hook)

  (setq exwm-workspace-show-all-buffers t)

  ;;(setq exwm-workspace-minibuffer-position 'top)

  ;;Set screen resolution
  (require 'exwm-randr)
  (exwm-randr-enable)
  (start-process-shell-command "xrandr" nil "xrandr --output DP-1 --off --output HDMI-1 --mode 1920x1080 --pos 1680x0 --rotate normal --output DVI-D-1 --mode 1680x1050 --pos 0x0 --rotate normal")

  (add-hook 'exwm-randr-screen-change-hook #'barremacs/update-displays)
  (barremacs/update-displays)

  ;;Set wallpaper after setting screen resolution
  (barremacs/set-wallpaper)

  (setq exwm-randr-workspace-monitor-plist
        (pcase (system-name)
          ("novigrad" '(2 "DVI-D-1" 3 "DVI-D-1" 5 "DVI-D-1"))))

  (setq exwm-workspace-warp-cursor t)

  (setq mouse-autoselect-window t
        focus-follows-mouse t)

  ;; (require 'exwm-systemtray)
  ;; (exwm-systemtray-enable)

  ;; These keys should always pass through to Emacs
  (setq exwm-input-prefix-keys
        '(?\C-x
          ?\C-u
          ?\C-h
          ?\M-x
          ?\M-`
          ?\M-&
          ?\M-:
          ?\C-\M-j  ;; Buffer list
          ?\C-\M-k  ;; Kill current buffer
          ))  ;; Ctrl+Space

  ;; Ctrl+Q will enable the next key to be sent directly
  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  ;; Set up global key bindings.  These always work, no matter the input state!
  ;; Keep in mind that changing this list after EXWM initializes has no effect.
  (setq exwm-input-global-keys
        `(
          ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
          ([?\s-r] . exwm-reset)

          ;; Move between windows
          ([?\s-j] . windmove-left)
          ([?\s-k] . windmove-right)
          ([?\s-u] . windmove-up)
          ([?\s-n] . windmove-down)

          ;; ([?\C-c RET] . exwm-workspace-move)

          ;; Launch applications via shell command
          ([?\s-&] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))

          ;; Switch workspace
          ([?\s-w] . exwm-workspace-switch)

          ([?\s-§] . (lambda () (interactive)
                       (exwm-workspace-switch-create 0)))

          ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))

  (exwm-input-set-key (kbd "s-SPC") 'counsel-linux-app)
  (exwm-input-set-key (kbd "C-c RET") 'exwm-workspace-move)

  (exwm-enable))

(use-package desktop-environment
  :after exwm
  :config (desktop-environment-mode)
  :custom
  (desktop-environment-brightness-small-increment "2%+")
  (desktop-environment-brightness-small-decrement "2%-")
  (desktop-environment-brightness-normal-increment "5%+")
  (desktop-environment-brightness-normal-decrement "5%-"))

(server-start)

        (defvar barremacs/polybar-process nil
          "Holds the process of the running Polybar instance, if any")

      (defun barremacs/polybar-exwm-workspace ()
      (pcase exwm-workspace-current-index
        (0 "dev")
        (1 "sys")
        (2 "www")
        (3 "chat")
        (4 "entertainment")
        (5 "school")
        (6 "misc" )
        (7 "misc")
        (8 "misc")
        (9 "misc")))

        (defun barremacs/kill-panel ()
          (interactive)
          (when barremacs/polybar-process
            (ignore-errors
              (kill-process barremacs/polybar-process)))
          (setq barremacs/polybar-process nil))

        (defun barremacs/start-panel ()
          (interactive)
          (barremacs/kill-panel)
          (setq barremacs/polybar-process (start-process-shell-command "polybar" nil "polybar panel")))

    (defun barremacs/send-polybar-hook (module-name hook-index)
    (start-process-shell-command "polybar-msg" nil (format "polybar-msg hook %s %s" module-name hook-index)))

  (defun barremacs/send-polybar-exwm-workspace ()
    (barremacs/send-polybar-hook "exwm-workspace" 1))

(add-hook 'exwm-workspace-switch-hook #'barremacs/send-polybar-exwm-workspace)
