This dir exists to allow this SSH config to work:
```
ControlMaster auto
ControlPath ~/.ssh/control/%r@%h:%p
ControlPersist 1800
```
And improve connection speed to the same hosts.
