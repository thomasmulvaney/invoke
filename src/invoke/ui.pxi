(ns invoke.ui 
  (:require [invoke.util :as util] 
            [sparkles.core :as sparkles]))

(def error  (sparkles/color {:fg :red}))
(def normal (sparkles/color {:fg :white}))
(def muted  (sparkles/color {:fg :white :styles [:faint]}))

(defn option->str 
  "Given a command show a string like:
     -o, --option  Some description" 
  [option]
  (str
    (->> (str (:short option) ", " (:long option))
         (util/rpadt 20)
         (util/lpad 4))
    (muted (:doc option))))

(defn usage 
  "Print the usage information for each option"
  [options]
  (println "Usage:")
  (doseq [option options]
    (println (option->str option))))

(defn undefined-options 
  "Print out a list of options which are not defined"
  [undefined-options]
  (println (util/lpad 2 (error "The following options are undefined:")))
  (doseq [u undefined-options]
    (println (util/lpad 4 u))))
