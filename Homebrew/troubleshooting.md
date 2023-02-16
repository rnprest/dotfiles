#### Fix for "Permission denied @ apply2files"

[Link to stackoverflow answer](https://stackoverflow.com/questions/54682876/brew-cleanup-error-permission-denied-unlink-internal)

`Error: Permission denied @ apply2files - /usr/local/lib/python3.9/site-packages/__pycache__/six.cpython-39.pyc`

```bash
sudo chown -R "$(whoami)":admin /usr/local/lib
```
