(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(+org-capture-journal-file (concat org-directory "journal.org") t)
 '(+org-capture-notes-file (concat org-directory "notes.org") t)
 '(+org-capture-todo-file (concat org-directory "do.org") t)
 '(custom-safe-themes
   '("2f1518e906a8b60fac943d02ad415f1d8b3933a5a7f75e307e6e9a26ef5bf570" "8d7684de9abb5a770fbfd72a14506d6b4add9a7d30942c6285f020d41d76e0fa" "f7216d3573e1bd2a2b47a2331f368b45e7b5182ddbe396d02b964b1ea5c5dc27" "e6ff132edb1bfa0645e2ba032c44ce94a3bd3c15e3929cdf6c049802cf059a2a" "711efe8b1233f2cf52f338fd7f15ce11c836d0b6240a18fffffc2cbd5bfe61b0" "37144b437478e4c235824f0e94afa740ee2c7d16952e69ac3c5ed4352209eefb" "99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93" default))
 '(org-capture-templates
   `(("t" "Todo" entry
      (file+headline +org-capture-todo-file "Inbox")
      "* [ ] %?
%i
%a" :prepend t)
     ("n" "Personal notes" entry
      (file+headline +org-capture-notes-file "Inbox")
      "* %u %?
%i
%a" :prepend t)
     ("j" "Journal")
     ("jm" "Morning Journal" plain #'marcel/org-journal-find-location
      (file ,(expand-file-name "res/morning-journal.org" org-directory))
      :jump-to-captured t :immediate-finish t)
     ("je" "Evening Journal" plain #'marcel/org-journal-find-location
      (file ,(expand-file-name "res/evening-journal.org" org-directory))
      :jump-to-captured t :immediate-finish t)
     ("jj" "Journal Note" plain #'marcel/org-journal-find-location "** %(format-time-string org-journal-time-format)%^{Title}
%i%?")
     ("p" "Templates for projects")
     ("pt" "Project-local todo" entry
      (file+headline +org-capture-project-todo-file "Inbox")
      "* TODO %?
%i
%a" :prepend t)
     ("pn" "Project-local notes" entry
      (file+headline +org-capture-project-notes-file "Inbox")
      "* %U %?
%i
%a" :prepend t)
     ("pc" "Project-local changelog" entry
      (file+headline +org-capture-project-changelog-file "Unreleased")
      "* %U %?
%i
%a" :prepend t)
     ("o" "Centralized templates for projects")
     ("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?
 %i
 %a" :heading "Tasks" :prepend nil)
     ("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?
 %i
 %a" :heading "Notes" :prepend t)
     ("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?
 %i
 %a" :heading "Changelog" :prepend t)))
 '(package-selected-packages '(edn))
 '(warning-suppress-types '((lsp-mode) (lsp-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
