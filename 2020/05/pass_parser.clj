;  ___               __  ___
; |   \ __ _ _  _   /  \| __|
; | |) / _` | || | | () |__ \
; |___/\__,_|\_, |  \__/|___/
;            |__/
; "Binary Boarding"
;
; Challenge:
; Given an input list of seat designations like /[FB]{7}[LR]{3}/, decode them to
; row (0 thru 127) and column (0 thru 7). Then compute the seat ID of each.
;
; "Binary Space Partitioning"
; - F and L mean "lower half"
; - B and R mean "upper half"
; The Seat ID is ((ROW * 8) + 5)
;
; Determine the highest seat ID.

; In English:
; - Looking at sample data, `BFFFBBF` -> `1000110` -> 70... this is just binary.
; - Read in the list of "boarding passes"
; - Split each string into the first 7 and last 3 characters
; - Convert to binary (F/L -> 0, B/R -> 1), then convert to decimal
; - Calc the "seat ID"
; - Capture the highest either by finding it in the array or keeping track of
;   the highest we've seen as we go.

(ns boardingpass.parser)

(def airplane-rows [0 127])
(def airplane-cols [0 7])

; Split a boarding pass into its row and column designations
(defn split-components [raw]
  (try
    (if (= (count raw) 10)
      [(subs raw 0 7) (subs raw 7)]
      (throw (Exception. (str "Invalid Boarding Pass String: " raw))))
    (catch
      Exception e (println (.getMessage e))
      (System/exit 1))))

; Recursively determine the row (or column) index of a designation
; (aka "decode that binary FBFBBFF into its decimal equivalent the Lisp way")
(defn locate-index [min max input]
  (if (= min max)
    min
    (let [mid (quot (+ max min) 2)]
      (if (clojure.string/starts-with? input "F")
        (recur min mid (subs input 1)) ; Forward of current midpoint
        (recur (+ mid 1) max (subs input 1)) ; Backward (higher number) of current midpoint
        ))))

; Swap column designation letters with the row letters of the same meaning so
; I can reuse locate-index on them.
(defn translate-cols [area]
  (str (clojure.string/replace (clojure.string/replace area "B" "R") "F" "L")))

; For a given row/col designation, figure out which type it is and get the num
(defn decode-area [area]
  (if (clojure.string/includes? area "B")
    ; It's a B/F situation, it's a row
    (locate-index (get airplane-rows 0) (get airplane-rows 1) area)
    ; It's an L/R situation, it's a column
    (locate-index (get airplane-cols 0) (get airplane-cols 1) (translate-cols area))))

; Given a list of area designation components, decode them
(defn process-area-ids [pass-components]
  (for [area pass-components] (decode-area area)))

; Split a boarding pass designation into its pieces, decode them, then multiply
; to get the "Seat ID"
(defn process-pass [input]
  (let [areas (process-area-ids (split-components input))]
    [(nth areas 0) (nth areas 1) (reduce * areas)])
  )

(println (process-pass "FBFBBFFRLR"))
