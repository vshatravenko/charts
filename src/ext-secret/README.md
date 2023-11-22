# External Secret and ConfigMap Chart

This Helm chart is designed for Secret and ConfigMap management.
Its primary use-case is external configuration for other Helm releases(e.g. PostgreSQL, apps, etc.)

## Usage

To create K8s secrets, specify secret name and content in `.Values.secrets`, each entry results in a separate Secret being created:
```yaml
secrets:
  secret1:
    ENV_VAR1: value1
```

Same goes for ConfigMap creation, the field is `.Values.configMaps`:
```yaml
configMaps:
  cm1:
    muh_data: here_it_is
```

To install the Helm chart for the first time, run:
```sh
$ helm install *release_name* 2d33p/ext-secret -n *namespace* -f *values_path*
```

To get the current values of an installed release, run:
```sh
$ helm get values -n *namespace* *release_name*
```

To update values of an installed release, run:
```sh
$ helm upgrade *release_name* 2d33p/ext-secret -n *namespace* -f *values_path*
```
