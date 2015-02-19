(require "server.rkt")
(require web-server/servlet
         web-server/servlet-env)






(listen 8080
          ("/helloworld" -> hello-world)
          ("/goodbyeworld" -> goodbye-world)
          ("/home" -> (λ (req) (html "" (p "this works too")))))