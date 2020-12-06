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
(def batch-file "boarding_passes.txt")

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
        (recur (+ mid 1) max (subs input 1)))))) ; Backward (higher number) of current midpoint

; Swap column designation letters with the row letters of the same meaning so
; I can reuse locate-index on them. Left/Right --> Front/Back
(defn translate-cols [area]
  (str (clojure.string/replace (clojure.string/replace area "R" "B") "L" "F")))

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
;
; PART TWO CHANGE: Return only a Seat ID, not a vector of row, col, and ID.
(defn process-pass [input]
  (let [areas (process-area-ids (split-components input))]
    (+ (* (nth areas 0) 8) (nth areas 1)))
  )

; Snag all the boarding passes from the identified file and decode them all
(defn decode-all-passes []
  (apply list
    (let [passes (clojure.string/split (slurp batch-file) #"\n")]
      (for [pass passes] (process-pass pass)))))

; Cycle through the List of boarding passes (Vectors) and inspect the Seat ID
; (index 2) of each to get the highest. This is essentially a custom reducer.
;
; PART TWO CHANGE: process-pass now only returns the ID, not a vector of each
; so this can be majorly simplifed, as @duplico pointed out. For now, just drop
; the logic to look at IDs.
(defn find-highest-seat-identifier
  ; If we don't have a "highest" number to test against, we're starting at 0
  ([passes] (find-highest-seat-identifier passes 0))
  ; Get "current" vs test from the Seat ID [0] of the first pass in the stack
  ([passes known-value] (let [this-value (first passes)]
    (if (< (count passes) 2)
      ; This is the last pass, either we have the biggest already or this is it
      (max known-value this-value)
      ; We have a list left, which is bigger, something we knew or this one?
      (if (< known-value this-value)
        ; New pass has a higher ID
        (recur (pop passes) this-value)
        ; The ID we already knew about was higher
        (recur (pop passes) known-value)
      )))))

(println "Highest Seat ID: " (find-highest-seat-identifier (decode-all-passes)))
; Part One answer:
; Highest Seat ID:  976

;  ___          _     ___
; | _ \__ _ _ _| |_  |_  )
; |  _/ _` | '_|  _|  / /
; |_| \__,_|_|  \__| /___|
;
; This one is harder to decode into English... I think my goal is to determine
; which Seat ID is missing from the list, which will be mine. There is a gap at
; the front and back of the seat map, but the center should be booked solid with
; only one missing.

; Opposite of (inc x)
(defn -- [x] (- x 1))

; Average. Though this function name makes for some self-documenting code
(defn between [x y] (quot (+ x y) 2))

; Walk from the end of the seating pool to the front looking for a gap.
(defn walk-passes [passes]
  (loop [i (-- (count passes))]
    (let [this (nth passes i) next (nth passes (-- i)) difference (- this next)]
      (if (> difference 1)
        (println "There is a gap between Seat IDs" this next ". Your seat must be" (between this next) "."))
      (when (> i 7) (recur (-- i))))))

(walk-passes (sort (decode-all-passes)))
; Part Two answer:
; There is a gap between Seat IDs 686 684 . Your seat must be 685 .
