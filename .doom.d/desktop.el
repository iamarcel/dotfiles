;;; desktop.el -*- lexical-binding: t; -*-

(defun marcel/run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

(defun marcel/set-wallpaper ()
  (interactive)
  (start-process-shell-command
      "feh" nil  "feh --bg-scale /home/marcel/Pictures/wallpaper.jpg"))

(defun marcel/exwm-init-hook ()
  ;; Make workspace 1 be the one where we land at startup
  (exwm-workspace-switch-create 1)

  ;; Show battery status in the mode line
  (display-battery-mode 1)

  ;; Show the time and date in modeline
  (setq display-time-day-and-date t)
  (display-time-mode 1)
  ;; Also take a look at display-time-format and format-time-string
  (marcel/run-in-background "setxkbmap -option caps:escape")

  ;; Launch apps that will run in the background
  (marcel/run-in-background "nm-applet")
  (marcel/run-in-background "pasystray")
  (marcel/run-in-background "blueman-applet")
  ;; (marcel/run-in-background "gnome-settings-daemon")
  (marcel/run-in-background "gnome-keyring-daemon")
  )

(defun marcel/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

(defun marcel/exwm-update-title ()
  (pcase exwm-class-name
    ("Firefox" (exwm-workspace-rename-buffer (format "Firefox: %s" exwm-title)))))

(defun marcel/configure-window-by-class ()
  (interactive)
  (pcase exwm-class-name
    ("Firefox" (exwm-workspace-move-window 2))
    ("Spotify" (exwm-workspace-move-window 3))))

;; This function should be used only after configuring autorandr!
(defun marcel/update-displays ()
  (marcel/run-in-background "autorandr --change --force")
  (message "Display config: %s"
           (string-trim (shell-command-to-string "autorandr --current"))))

(use-package exwm
  :config
  (require 'exwm-config)
  ;; (exwm-config-default)

  ;; Set the default number of workspaces
  (setq exwm-workspace-number 5)

  ;; When window "class" updates, use it to set the buffer name
  (add-hook 'exwm-update-class-hook #'marcel/exwm-update-class)

  ;; When window title updates, use it to set the buffer name
  (add-hook 'exwm-update-title-hook #'marcel/exwm-update-title)

  ;; Configure windows as they're created
  (add-hook 'exwm-manage-finish-hook #'marcel/configure-window-by-class)

  ;; When EXWM starts up, do some extra confifuration
  (add-hook 'exwm-init-hook #'marcel/exwm-init-hook)

  ;; Set the screen resolution (update this to be the correct resolution for your screen!)
  (require 'exwm-randr)
  (exwm-randr-enable)

  ;; NOTE: Uncomment these lines after setting up autorandr!
  ;; React to display connectivity changes, do initial display update
  ;; (add-hook 'exwm-randr-screen-change-hook #'marcel/update-displays)
  ;; (marcel/update-displays)

  ;; Set the wallpaper after changing the resolution
  (marcel/set-wallpaper)

  ;; Load the system tray before exwm-init
  (require 'exwm-systemtray)
  (setq exwm-systemtray-height 16)
  (exwm-systemtray-enable)

  ;; Automatically send the mouse cursor to the selected workspace's display
  (setq exwm-workspace-warp-cursor t)

  ;; Window focus should follow the mouse pointer
  (setq mouse-autoselect-window t
        focus-follows-mouse t)

  ;; These keys should always pass through to Emacs
  (setq exwm-input-prefix-keys
    '(?\C-x
      ?\C-u
      ?\C-h
      ?\M-x
      ?\M-`
      ?\M-&
      ?\M-:))

  ;; Ctrl+Q will enable the next key to be sent directly
  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  ;; Set up global key bindings.  These always work, no matter the input state!
  ;; Keep in mind that changing this list after EXWM initializes has no effect.
  (setq exwm-input-global-keys
        `(
          ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
          ([?\s-r] . exwm-reset)

          ;; Move between windows
          ([?\s-h] . windmove-left)
          ([?\s-j] . windmove-down)
          ([?\s-k] . windmove-up)
          ([?\s-l] . windmove-right)

          ;; Move windows
          ([?\s-H] . +evil/window-move-left)
          ([?\s-J] . +evil/window-move-down)
          ([?\s-K] . +evil/window-move-up)
          ([?\s-L] . +evil/window-move-right)

          ;; Split
          ([?\s-v] . evil-window-vsplit)
          ([?\s-s] . evil-window-split)

          ;; Resize
          ([f11] . exwm-layout-toggle-fullscreen)

          ;; Launch commands
          ([?\s-&] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))

          ;; Launch apps
          ([?\s-\ ] . counsel-linux-app)

          ([?\s-b] . ibuffer)
          ([?\s-q] . +workspace/close-window-or-workspace)
          ([?\s-Q] . kill-current-buffer)

          ;; Switch workspace
          ([?\s-w] . exwm-workspace-switch)
          ([?\s-`] . (lambda () (interactive) (exwm-workspace-switch-create 0)))

          ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))

  (exwm-input-set-key (kbd "s-SPC") 'counsel-linux-app)

  (exwm-enable))

(use-package! desktop-environment
  :after exwm
  :config (desktop-environment-mode)
  :custom
  (desktop-environment-brightness-small-increment "2%+")
  (desktop-environment-brightness-small-decrement "2%-")
  (desktop-environment-brightness-normal-increment "5%+")
  (desktop-environment-brightness-normal-decrement "5%-"))
