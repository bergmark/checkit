create table project
( project_id uuid primary key
, name text not null
);

create table todo
( todo_id uuid primary key
, project_id uuid not null references project (project_id)
, text text not null
);

create table report
( report_id uuid primary key
, todo_id uuid not null references todo (id)
, "timestamp" timestamptz not null
);
