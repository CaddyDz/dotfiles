> You should ensure that the value of `stopwaitsecs` is greater than the number of seconds consumed by your longest running job.  
Otherwise, Supervisor may kill the job before it is finished processing.

# Starting Supervisor
Once the configuration file has been created, you may update the Supervisor configuration and start the processes using the following commands:

```shell
sudo supervisorctl reread

sudo supervisorctl update

sudo supervisorctl start horizon
```
For more information on Supervisor, consult the [Supervisor documentation](http://supervisord.org/index.html).
