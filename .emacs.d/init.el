;; 文字コード
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq local-coding-system 'utf-8-hfs))
(when (eq window-system 'w32)
  (set-file-name-coding-system 'cp932)
  (setq local-coding-system 'cp932))
(setq-default tab-width 4)

;; ~/.emacs.d/elispディレクトリをロードパスに追加する
;; ただし、add-to-load-path関数を作成した場合は不要
;(add-to-list 'load-path "~/.emacs.d/elisp")

;; Emacs23以前はuser-emacs-directory変数が未定のため追加
(when (> emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d"))

;; load-pathを追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")

;; フレーム設定
;; メニューバー非表示
(menu-bar-mode 0)
;; ターミナル以外はツールバー・スクロールバーを非表示
(when window-system
  (tool-bar-mode 0)
  (scroll-bar-mode 0))
;; 行番号・カラム番号表示
(column-number-mode t)
;; ファイルサイズ表示
(size-indication-mode t)
;; 時計表示
;; (setq display-time-day-and-date t)	;曜日・月・日を表示
(setq display-time-24hr-format t)	;24時表示 a
(display-time-mode t)
;; バッテリー表示
(display-battery-mode 0)
;; タイトルバーにファイルのフルパス表示
(setq frame-title-format "%f")
;; 行番号表示
(global-linum-mode 0)
;; カーソル行番号表示
(setq line-number-mode t)
;; リージョン内の行数・文字数をモードラインに表示
;; (defun count-lines-and-chars ()
;;   (if mark-active
;;       (format "%d lines, %d chars "
;; 	      (count-lines (region-beginning) (region-end))
;; 	      (- (region-end) (region-beginning)))
;;     ""))
;; (add-to-list 'default-mode-line-format
;; 	     '(:eval (count-lines-and-chars)))

;; フェイス設定
;; フォント
;; (set-face-attribute 'default nil
;; 					:family "Menlo"
;; 					:height 120)
;; (set-fontset-font
;;  nil 'japanese-jisx0208
;;  (font-spec :family "ヒラギノ明朝 Pro"))
;; カレント行のハイライト
(defface my-hl-line-face
  '((((class color) (background dark))
;	 (:background "NavyBlue" t))
	 (:background "E0FFFF" t))	
	(((class color) (background light))
;	 (:background "LightGoldenrodYellow" t))
;	 (:background "NavyBlue" t))	
;	 (:background "cyan" t))
	 (:background "E0FFFF" t))		
	(t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)
;; 対応する括弧のハイライト
(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")

;; キーバインド
;; 改行と同時にインデントする (C-m)
(define-key global-map (kbd "C-m") 'newline-and-indent)
;; BackSpace (C-h)
(define-key global-map (kbd "C-h") 'delete-backward-char)
;; Jump LineNo (C-x C-g)
(global-set-key "\C-x\C-g" 'goto-line)
;; 行の折り返し表示切り替え (C-c l)
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)
;; ウィンドウ切り替え (C-t)
;;(define-key global-map (kbd "C-t") 'other-window)


;; バックアップ・オートセーブを~/.emacs.d/backupsへ集める
(add-to-list 'backup-directory-alist
			 (cons "." "~/.emacs.d/backups/"))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))
;; (setq backup-directory-alist
;; 	  `((".*" . ,temporary-file-directory)))
;; (setq auto-save-file-name-transforms
;; 	  `((".*" , temporary-file-directory t)))

;; ファイルが#!から始まる場合、実行権限を付与して保存
(add-hook 'after-save-hook
		  'executable-make-buffer-file-executable-if-script-p)


;; elisp補助
(defun elisp-mode-hooks ()
  "lisp-mode-hooks"
  (when (require 'eldoc nil t)
    (setq eldoc-idle-delay 0.2)
    (setq eldoc-echo-area-use-multiline-p t)
    (turn-on-eldoc-mode)))
(add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)


;; auto-install
;; 【概要】
;;   拡張機能の自動インストール
;; 【インストール】
;;   cd ~/.emacs.d/elisp
;;   curl -O http://www.emacswiki.org/emacs/download/auto-install.el
(when (require 'auto-install nil t)
  ;; インストールディレクトリの設定
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; Emacswikiに登録されているelispの名前を取得する
  (auto-install-update-emacswiki-package-name t)
  ;; 必要であればプロキシの設定を行う
  ;; (setq url-proxy-services '(("http" . "localhost:8339")))
  ;; install-elispの関数を利用可能にする
  (auto-install-compatibility-setup))

;; ELPA
;; 【インストール】
;;   M-x install-elisp [RET] http://bit.ly/pkg-el23 [RET] filename: package.el
;; 【操作】
;;   M-x list-packages  パッケージの一覧取得
(when (require 'package nil t)
  ;; パッケージリポジトリにMarmaladeと開発運営のELPAを追加
  (add-to-list 'package-archives
  			   '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
  ;; インストールしたパッケージにロードパスを通して読み込む
  (package-initialize))

;; multi-term
;; 【概要】
;;   ターミナル利用
;; 【インストール】
;;   M-x package-install [RET] multi-term
;; 【操作】
;;   M-x multi-term   起動
(when (require 'multi-term nil t)
  ;; 使用するシェル指定
  (setq multi-term-program "/bin/zsh"))


;; Anything
;; 【概要】
;;   候補選択型インタフェース
;; 【インストール】
;;   M-x auto-install-batch [RET] anything
;; 【操作】
;;   M-x anything-for-files
(when (require 'anything nil t)
  (setq
   ;; 候補を表示するまでの時間
   anything-idle-delay 0.3
   ;; タイプして再描写するまでの時間
   anything-input-idle-delay 0.2
   ;; 候補の最大表示数
   anything-candidate-number-limit 100
   ;; 候補が多いときに体感速度を速くする
   anything-quick-update t
   ;; 候補選択ショートカットをアルファベットに
   anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)
	;; root権限でアクションを実行するときのコマンド
	(setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)

  (when (and (executable-find "cmigemo")
			 (require 'migemo nil t))
	(require 'anything-migemo nil t))
  
  (when (require 'anything-complete nil t)
	;; lispシンボルの補完候補の再検索時間
	(anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
	(require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
	;; describe-bindingsをanythingに置き換える
	(descbinds-anything-install)))


;; auto-complete
;; 【概要】
;;   補完入力の強化
;; 【インストール】
;;   M-x package-install [RET] auto-complete
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
			   "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))


;; color-moccur
;; 【概要】
;;   検索結果のリストアップ
;; 【インストール】
;;   M-x auto-install-from-emacswiki [RET] color-moccur.el
;; 【操作】
;;   M-o    検索、終了はq
(when (require 'color-moccur nil t)
  ;; M-oにoccur-by-moccurを割り当て
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  ;; スペース区切りでAND検索
  (setq moccur-split-word t)
  ;; ディレクトリ検索のとき除外するファイル
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  ;; Migemoを利用できる環境であればMigemoを使う
  (when (and (executable-find "cmigemo")
			 (require 'migemo nil t))
	(setq moccur-use-migemo t)))


;; moccur-edit
;; 【概要】
;;   moccurの結果を直接編集
;; 【インストール】
;;   M-x auto-install-from-emacswiki [RET] moccur-edit.el
;; 【操作】
;;   moccur実行後、「r」で編集モード
;;     C-c C-c, C-x C-s バッファに反映
;;     C-c C-u, C-x C-k 編集を破棄
;;     q                moccurを終了
(require 'moccur-edit nil t)


;; undohist
;; 【概要】
;;   編集履歴の記録
;; 【インストール】
;;   M-x install-elisp [RET] http://cx4a.org/pub/undohist.el
(when (require 'undohist nil t)
  (undohist-initialize))


;; undo-tree
;; 【概要】
;;   アンドゥの分岐履歴
;; 【インストール】
;;   M-x package-install [RET] undo-tree
;; 【操作】
;;   C-x u   アンドゥ履歴表示、「q」で終了
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))


;; point-undo
;; 【概要】
;;   カーソルの移動履歴
;; 【インストール】
;;   M-x auto-install-from-emacswiki [RET] point-undo.el
(when (require 'point-undo nil t)
  (define-key global-map (kbd "M-[") 'point-undo)
  (define-key global-map (kbd "M-]") 'point-redo))


;; ElScreen
;; 【概要】
;;   分割状態を管理
;; 【インストール】
;;   $ curl -O http://kanji.zinbun.kyoto-u.ac.jp/~tomo/lemi/dist/apel/apel-10.8.tar.gz
;;   $ tar xvf apel-10.8.tar.gz
;;   $ cd ./apel-10.8
;;   $ make LISPDIR=~/.emacs.d/elisp VERSION_SPECIFIC_LISPDIR=~/.emacs.d/elisp INFODIR=~/.emacs.d/info
;;   $ make install LISPDIR=~/.emacs.d/elisp VERSION_SPECIFIC_LISPDIR=~/.emacs.d/elisp INFODIR=~/.emacs.d/info
;;   emacs再起動
;;   $ curl -O ftp://ftp.morishima.net/pub/morishima.net/naoto/ElScreen/elscreen-1.4.6.tar.gz
;;   $ tar xvf elscreen-1.4.6.tar.gz
;;   $ cp ./elscreen-1.4.6/elscreen.el ~/.emacs.d/elisp
;; 【操作】
;;   C-z c         スクリーン作成
;;   C-z p, C-z n  スクリーン移動
;;   C-z k         現在のスクリーンを閉じる
(when (require 'elscreen nil t)
  ;;
  (if window-system
	  (define-key elscreen-map (kbd "C-z") 'iconify-or-deiconify-frame)
	(define-key elscreen-map (kbd "C-z") 'suspend-emacs)))


;; nxml-modeをHTML編集
;; htmlモードに切り替え「M-x html-mode」
(add-to-list 'auto-mode-alist '("\\.[sx]?html?\\(\\.[a-zA-Z_]+\\)?\\'" . nxml-mode))
;; html5
(eval-after-load "rng-loc"
  '(add-to-list 'rng-schema-locating-files
				"~/.emacs.d/public_repos/html5-el/schemas.xml"))
(require 'whattf-dt)
;; </を入力すると自動的にタグを閉じる
(setq nxml-slash-auto-complete-flag t)
;; M-TABでタグを補完する
(setq nxml-bind-meta-tab-to-complete-flag t)
;; nxml-modeでauto-complete-modeを利用する
(add-to-list 'ac-modes 'nxml-mode)
;; 子要素のインデント幅を設定
(setq nxml-child-indent 0)
;; 属性値のインデント幅を設定
(setq nxml-attribute-indent 0)


;; cssm-mode
;; 【概要】
;;   cssm mode
;; 【インストール】
;;   M-x install-elisp [RET] http://www.garshol.priv.no/download/software/css-mode/css-mode.el
(defun css-mode-hooks ()
  "css-mode hooks"
  ;; インデントをCスタイルにする
  (setq cssm-indent-function #'cssm-c-style-indenter)
  ;; インデント幅を2にする
  (setq cssm-indent-level 2)
  ;; インデントにタブを使わない
  (setq-default indent-tabs-mode nil)
  ;; 閉じ括弧の前に改行を挿入する
  (setq cssm-newline-before-closing-bracket t))
(add-hook 'css-mode-hook 'css-mode-hooks)
;; nxml-modeでauto-complete-modeを利用する
(add-to-list 'ac-modes 'css-mode)


;; js2-mode
;; 【概要】
;;   js2 mode
;; 【インストール】
;;   M-x package-install [RET] js2-mode
(defun js-indent-hook ()
  ;; インデント幅を4
  (setq js-indent-level 2
		js-expr-indent-offset 2
		indent-tabs-mode nil)
  ;; switch文のcaseラベルをインデントする関数を定義
  (defun my-js-indent-line ()
	(interactive)
	(let* ((parse-status (save-excursion (syntax-ppss (point-at-bol))))
		   (offset (- (current-column) (current-indentation)))
		   (indentation (js--proper-indentation parse-status)))
	  (back-to-indentation)
	  (if (looking-at "case\\s-")
		  (indent-line-to (+ indentation 2))
		(js-indent-line))
	  (when (> offset 0) (forward-char offset))))
  ;; caseラベルのインデント処理をセット
  (setq (make-local-variable 'indent-line-function) 'my-js-indent-line)
  ;; ここまでcaseラベルを調整する設定
  )
(add-hook 'js-mode-hook 'js-indent-hook)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-hook 'js2-mode-hook 'js-indent-hook)


;; php-mode
;; 【概要】
;;   php mode
;; 【インストール】
;;   $ cd ~/.emacs.d/public_repos
;;   $ git clone git://github.com/ejmr/php-mode.git
;;   $ git clone git://github.com/imakado/php-completion.git
(when (require 'php-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.ctp\\'" . php-mode))
  (setq php-search-url "http://jp.php.net/ja/")
  (setq php-manual-url "http://jp.php.net/manual/ja/"))
;; php-modeのインデント設定
(defun php-indent-hook ()
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4)
  ;; (c-set-offset 'case-label '+)      ; switch文のcaseラベル
  (c-set-offset 'arglist-intro '+)		; 配列の最初の要素を改行した場合
  (c-set-offset 'arglist-close 0))		; 配列の閉じ括弧
(add-hook 'php-mode-hook 'php-indent-hook)
;; php-modeの補完強化
(defun php-completion-hook ()
  (when (require 'php-completion nil t)
	(php-completion-mode t)
	(define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
	(when (require 'auto-complete nil t)
	  (make-variable-buffer-local 'ac-sources)
	  (add-to-list 'ac-sources 'ac-source-php-completion)
	  (auto-complete-mode t))))
(add-hook 'php-mode-hook 'php-completion-hook)


;; gtags
;; 【概要】
;;   gtagsとemacsの連携
;; 【インストール】
;;  (1) gtags
;;   $ curl -O http://tamacom.com/global/global-6.1.tar.gz
;;   $ tar xvf global-6.1.tar.gz
;;   $ ./configure
;;   $ make
;;   $ sudo make install
;;  (2) gtags.el
;;   $ cp /usr/local/share/gtags/gtags.el ~/.emacs.d/elisp/
;; gtags-modeのキーバインドを有効化する
(setq gtags-suggested-key-mapping t)	; 無効化する場合はコメントアウト
(require 'gtags nil t)


;; ctags
;; 【概要】
;;   ctagsとemacsの連携
;; 【インストール】
;;   (1) ctags
;;    $ tar xvf ctags-5.8.tar.gz
;;    $ ./configure
;;    $ make
;;    $ sudo make install
;;   (2) ctags.el
;;    M-x package-install [RET] ctags
(require 'ctags nil t)
(setq tags-revert-without-query t)
;; ctagsを呼び出すコマンドライン。パスが通っていればフルパスでなくてもよい
;; etags互換タグを利用する場合はコメントを外す
;; (setq ctags-command "ctags -e -R ")
;; anything-exuberant-ctags.elを利用しない場合はコメントアウトする
(setq ctags-command "ctags -R --fields=\"+afikKlmnsSzt\" ")
(global-set-key (kbd "<f5>") 'ctags-create-or-update-tags-table)


;; Anythingとタグの連携
;; 【概要】
;;   
;; 【インストール】
;;   M-x auto-install-from-emacswiki [RET] anything-gtags.el 
;;   M-x auto-install-from-emacswiki [RET] anything-exuberant-ctags.el
;; anthingからTAGSを利用しやすくするコマンド作成
(when (and (require 'anything-exuberant-ctags nil t)
		   (require 'antthing-gtags nil t))
  ;; anything-for-tags用のソースを定義
  (setq anything-for-tags
		(list anything-c-source-imenu
			  anything-c-source-gtags-select
			  ;; etagsを利用する場合はコメントを外す
			  ;; anything-c-source-exuberant-ctags-select
			  anything-c-source-exuberant-ctags-select
			  ))
  ;; anything-for-tagsコマンドを作成
  (defun anything-for-tags ()
	"Preconfigured `anything' for anything-for-tags."
	(interactive)
	(anything anything-for-tags
			  (thing-at-point 'symbol)
			  nil nil nil "*anything for tags*"))
  ;; M-tにanything-for-tagsを割り当て
  (defun-key global-map (kbd "M-t") 'anything-for-tags))
  

;; wb-line-number
;; 【概要】
;;   行番号を表示する
;; 【インストール】
;;   http://homepage1.nifty.com/blankspace/emacs/wb-line-number.html
;; (require 'wb-line-number)
;; (wb-line-number-toggle)
;; (custom-set-faces
;;   '(wb-line-number-face ((t (:foreground "LightGrey"))))
;;    '(wb-line-number-scroll-bar-face
;; 	    ((t (:foreground "white" :background "LightBlue2")))))


;; Egg
;; 【概要】
;;   gitフロントエンド
;; 【インストール】
;;   M-x install-elisp [RET] https://raw.github.com/byplayer/egg/master/egg.el
;;   M-x install-elisp [RET] https://raw.github.com/byplayer/egg/master/egg-grep.el
;; 【コマンド】
;;   C-x v s      git status
;;   C-x v l      git log
(when (executable-find "git")
  (require 'egg nil t))

;; 
;; 【概要】
;;   
;; 【インストール】
;; 
