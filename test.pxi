(ns t
  (:require [invoke.core :as invoke]
            [invoke.ui   :as invoke.ui]))

(def options 
  [{:option :help
    :short  "-h"
    :long   "--help"
    :doc    "Displays the usage"
    :default false
    :fn     (fn [& args] true)}
   {:option :version
    :short  "-v"
    :long   "--version" 
    :doc    "Displays the version"
    :default false
    :fn     (fn [& args] true)}])

(let [parsed-options    (invoke/build-map options program-arguments)
      undefined-options (invoke/undefined-options options program-arguments)]
  (when (seq undefined-options)
    (invoke.ui/undefined-options undefined-options))
  (when (:help parsed-options)
    (invoke.ui/usage options)))
