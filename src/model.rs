use serde::*;
use sqlx;

#[derive(Clone, Debug, sqlx::FromRow)]
pub struct Todo {
    pub id: i32,
    pub title: String,
    pub completed: bool,
    pub orderx: i32,
}

pub async fn todo_to_tresponse(todo: Todo) -> anyhow::Result<TodoResponse> {
    Ok(TodoResponse {
        id: todo.id,
        title: todo.title,
        completed: todo.completed,
        orderx: todo.orderx,
    })
}

pub async fn todos_to_tresponses(todos: Vec<Todo>) -> anyhow::Result<Vec<TodoResponse>> {
    let mut new_vec = Vec::new();
    for todo in todos {
        let todo_val = todo_to_tresponse(todo).await?;
        new_vec.push(todo_val);
    }
    Ok(new_vec)
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct TodoResponse {
    pub id: i32,
    // pub url: String,
    pub title: String,
    pub completed: bool,
    pub orderx: i32,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct TodoAction {
    pub title: String,
    pub completed: bool,
    pub orderx: i32,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct TodoCompletion {
    pub all_complete: bool
}
