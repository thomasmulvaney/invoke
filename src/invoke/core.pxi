(ns invoke.core
  (:require [pixie.string  :as string]
            [sparkles.core :as sparkles]
            [invoke.util   :as util]))

(defn option? 
  "Does the string look like an option"
  [s] 
  (string/starts-with? s "-"))

(defn args->option-maps 
  "Given a list of arguments turn them into a list of form:
  [{:option '-x' :args ['a' 'b' ...]} ...]"
  [args]
  (into [] 
        (comp 
          (util/split-by option?) 
          (map (fn [[option & args]] {:option option :args args}))) 
        args))

(defn options->flags
  "Given the options inverts the map so each CLI flag points to a command"
  [options]
  (into {}
        (mapcat (fn [{:keys [short long] :as option}] 
                  [[long  option]
                   [short option]]))
        options))

(defn undefined-options 
  "Given the options map and the parsed arguments return any option flags the
  which are not in the options map"
  [options args]
  (let [known-flags (options->flags options)]
    (into [] 
          (comp (map :option) (remove known-flags)) 
          (args->option-maps args))))

(defn build-map 
  [options args]
  (let [arg-map      (args->option-maps args)
        flag->option (options->flags options)]
    (into {} 
          (comp
            ;; get valid options
            (filter (fn [{:keys [option args]}] (flag->option option)))
            ;; apply the args to the option function to build the final map
            (map (fn [{:keys [option args]}]
                   (let [{:keys [option fn]} (flag->option option)]
                     [option (apply fn args)]))))
          arg-map)))
