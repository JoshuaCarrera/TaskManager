import strutils

type
  Task = object
    id: int
    title: string
    desc: string
    status: string

proc TaskModelateRows(rows: seq[seq[string]]): seq[Task] =
  var final_seq: seq[Task] = @[]
  for row in rows:
    final_seq.add(Task(
        id: parseInt(row[0]), 
        title: row[1], 
        desc: row[2], 
        status: row[3]))
  return final_seq

proc TaskModelateRow(row: Row): Task =
  return Task(id: parseInt(row[0]), title: row[1], desc: row[2], status: row[3])
