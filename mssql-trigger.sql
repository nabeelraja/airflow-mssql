SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER dbo.task_instance_insert_trigger
                ON  dbo.task_instance
                INSTEAD OF INSERT
AS
 
IF exists (SELECT task_id, dag_id, execution_date from dbo.task_instance where task_id = (SELECT task_id FROM inserted) AND dag_id = (SELECT dag_id FROM inserted) AND execution_date = (SELECT execution_date FROM inserted))
BEGIN
                RAISERROR('THIS RECORD ALREADY EXISTS', 10, 1)
END
ELSE
BEGIN
                INSERT into dbo.task_instance (task_id, dag_id, execution_date, start_date, end_date, duration, state, try_number, hostname, unixname, job_id, pool, queue, priority_weight, operator, queued_dttm, pid, max_tries, executor_config)
                SELECT * FROM inserted
END
GO