import prologue
import prologue/middlewares/staticfile # For static files

import ./urls

let
  env = loadPrologueEnv(".env")
  settings = newSettings(appName = env.getOrDefault("appName", "Task Manager"),
                         debug = env.getOrDefault("debug", true),
                         port = Port(env.getOrDefault("port", 8080)),
                         secretKey = env.getOrDefault("secretKey", "")
    )


var app = newApp(settings = settings) 
app.addRoute(urls.urlPatterns, "") # Routes
app.run()
