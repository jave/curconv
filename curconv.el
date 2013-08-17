(require 'request)

(require 'json)
(defvar curconv-rates)
(defvar curconv-base)
(defvar curconv-timestamp)
(defcustom curconv-api-key   "you-need-to-get-a-key" "api key")
(defun curconv-cache-rates ()
  (request
   (concat "http://openexchangerates.org/api/latest.json?app_id=" curconv-api-key)
   :type "GET"
   :parser 'json-read
   :error
   (function* (lambda (&key error-thrown &allow-other-keys&rest _)
                (message "Got error: %S" error-thrown)))
   :success
   (function*
    (lambda (&key data &allow-other-keys)
      (setq curconv-rates (assoc-default 'rates data)
            curconv-base (assoc-default 'base data)
            curconv-timestamp  (assoc-default 'timestamp data))
      ))))
;;(curconv-cache-rates)

(defun curconv (amount from to)
  (let
      ((fromv (cdr (assoc from curconv-rates)))
       (tov (cdr (assoc to curconv-rates))))
    (* (* amount tov) (/ 1 fromv)))
  )
;;(curconv-cache-rates)
;;(curconv 100 'SEK 'USD)
;;(curconv 100 'USD 'USD)
;;(curconv 100 'USD 'SEK)
;;(curconv 5 'SEK 'BTC)


