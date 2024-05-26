import prologue

import ./views

let urlPatterns* = @[
  pattern("/", index),
  pattern("/create_task",           create_task, @[HttpGet, HttpPost]),
  pattern("/update_task/{task_id}", update_task, @[HttpGet, HttpPost]),
  pattern("/delete_task",           delete_task, HttpPost),
]
