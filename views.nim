import prologue
import nimja/parser # Funciona como Jinja

import db_connector/db_sqlite # Para tratar las bases de datos

include ./models # Para modelar los rows

proc renderIndex(tasks: seq[Task]): string =
  compileTemplateFile(getScriptDir() / "/public/index.nimja")

proc index*(ctx: Context) {.async.} =
  let db = open("./database.db", "", "", "") 
  let rows = db.getAllRows(sql("SELECT id, title, desc, status FROM todo"))
  db.close()
  resp renderIndex(TaskModelateRows(rows))


proc renderCreateTask(): string =
  compileTemplateFile(getScriptDir() / "/public/create_task.nimja")

proc create_task*(ctx: Context) {.async.} =
  if ctx.request.reqMethod == HttpPost:
    let db = open("./database.db", "", "", "") 
    db.exec(sql"INSERT INTO todo (title,desc,status) VALUES (?,?,?)", 
      ctx.getPostParams("title"),
      ctx.getPostParams("desc"),
      ctx.getPostParams("status"))
    db.close()
    resp redirect("/")
  else:
    resp renderCreateTask()


proc renderUpdateTask(task: Task): string =
  compileTemplateFile(getScriptDir() / "/public/update_task.nimja")

proc update_task*(ctx: Context) {.async.} =
  if ctx.request.reqMethod == HttpPost:
    let db = open("./database.db", "", "", "") 
    db.exec(sql"UPDATE todo SET title = ?, desc = ?, status = ? WHERE id = ?",
      ctx.getPostParams("title"),
      ctx.getPostParams("desc"),
      ctx.getPostParams("status"),
      ctx.getPathParams("task_id"))
    db.close()
    resp redirect("/")
  else:
    let db = open("./database.db", "", "", "")
    let row = db.getRow(sql"SELECT id, title, desc, status FROM todo WHERE id = ?", ctx.getPathParams("task_id"))
    db.close() 
    resp renderUpdateTask(TaskModelateRow(row))

proc delete_task*(ctx: Context) {.async.} =
  if ctx.request.reqMethod == HttpPost:
    let db = open("./database.db", "", "", "") 
    db.exec(sql"DELETE FROM todo WHERE id = ?", ctx.getPostParams("task_id"))
    db.close()
  resp redirect("/")



