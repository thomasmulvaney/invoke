(ns invoke.util)

(defn split-by
  ([f]
   (fn [rf]
     (let [a  (atom (transient []))]
       (fn
         ([] (rf))
         ([result]
          (let [result (if (empty? @a)
                         result
                         (let [v (persistent! @a)]
                           ;;clear first!
                           (reset! a (transient []))
                           ;; wrap this up
                           (rf result v)))]
            (rf result)))
         ([result input]
          (let [split?  (f input)]
            (if-not split?
              (do
                (swap! a conj! input)
                result)
              (let [v (persistent! @a)]
                (reset! a (transient []))
                (let [ret (if (empty? v) 
                            result
                            (rf result v))]
                  (when-not (reduced? ret)
                    (swap! a conj! input))
                  ret)))))))))
  ([f coll]
   (lazy-seq
     (when-let [s (seq coll)]
       (let [fst (first s)
             fv  (f fst)
             run (cons fst (take-while #(= fv (f %)) (next s)))]
         (cons run (partition-by f (seq (drop (count run) s)))))))))

(defn pad [n]
  (transduce (take n) string-builder (repeat " ")))

(defn lpad 
  "Put n spaces before string"
  [n s]
  (if (pos? n)
    (str (pad n) s)
    s))

(defn rpad 
  "Put n spaces after string"
  [n s]
  (if (pos? n)
    (str s (pad n))
    s))

(defn lpadt 
  "Pad a string on the left to make it up to length n"
  [n s]
  (let [p (- n (count s))]
    (str (pad p) s)))

(defn rpadt 
  "Pad a string on the right to make it up to length n"
  [n s]
  (let [p (- n (count s))]
    (str s (pad p))))
