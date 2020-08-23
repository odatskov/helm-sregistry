# Singularity Registry Helm Chart

This folder contains a Kubernetes Helm chart for deploying a Singularity registry.

## Prerequisites

* Persistent Volume support if needed.

## Chart Details

This chart will do the following:

* Implements Singularity Registry deployment

## Installing the Chart

To install the chart, use the following:

```
~$ helm install --name sregistry sregistry
```

## Configuration

The table below lists all configurable parameters for the sregistry chart along with their default values. Pass each parameter with ```--set key=value,[,key=value]``` to ```helm install``` to customise execution.

| Parameter                  | Description | Default |
|:---------------------------|:------------|:--------|
| `postgresql.enabled`       | Enable local instance of PostegreSQL database | `true` |
| `postgresql.hostname`      | Hostname of the database endpoint | `"db"` |
| `postgresql.postgresqlUsername` | Database username credential | `"postgres"` |
| `postgresql.postgresqlPassword` | Database password credential | `"postgres"` |
| `postgresql.service.port`  | Database endpoint port | `5432` |
| `redis.enabled`            | Enable local instance of the Redis service | `true` |
| `redis.hostname`           | Hostname for the redis endpoint | `"redis"` |
| `redis.redisPort`          | Redis service port | `6379` |
| `minio.enabled`            | Enable local instance of the Minio service | `true` |
| `minio.hostname`           | Hostname of the Minio endpoint | `"minio"` |
| `minio.service.port`       | Minio service port | `9000` |
| `minio.minio.accessKey`    | Minio access key | `"newminio"` |
| `minio.minio.secretKey`    | Minio secret key | `"newminio123"` |
| `minio.ssl`                | Enable ssl for the Minio service | `"False"` |
| `minio.bucket`             | Bucket name to use | `"sregistry"` |
| `minio.region`             | Minio region | `"us-east-1"` |
| `config.domainName`        | Domain name to use for the registry service | `"127.0.0.1"` |
| `config.registryName`      | Readable registry name | `"Tacosaurus Computing Center"` |
| `config.registryUri`       | Registry identifier | `"taco"` |
| `config.instituteSite`     | Institution web site link | `"https://srcc.stanford.edu"` |
| `config.contactEmail`      | contact email | `"vsochat@stanford.edu"` |
| `config.analytics`         | Google analytics option. Disabled by default | `"None"` |
| `config.admins`            | List administrator accounts/users | See `values.yaml` for details |
| `config.userCreate`        | Allow users to create public collections | `"True"` |
| `config.userCollections`   | Limit users to N collections (None for unlimited) | `2` |
| `config.private`           | Image visibility. Default "False" sets to public | `"False"` |
| `config.privateDefault`    | Allows to set images to private by default | `"False"` |
| `config.collectionsPerPage`| Number of collections to show per page | `250` |
| `config.weeklyContainers`  | Maximum number of downloads per container | `100` |
| `config.weeklyCollections` | Maximum number of downloads per collection | `100` |
| `config.viewRateLimit`     | Rate limits for view requests | `"50/1d"` |
| `config.viewRateBlock`     | View rate block policy | `"True"` |
| `config.disableBuild`      | Disable all building, including pushing of containers and recipes | `"False"` |
| `config.logSaveResponses`  | Track all requests to pull containers. Set to "False" for minimal logging | `"True"` |
| `images.pullPolicy`        | Pull policy for sregistry container images | `IfNotPresent` |
| `images.sregistry.image`   | Principle Singularity registry service container | `quay.io/vanessa/sregistry` |
| `images.sregistry.tag`     | Image tag override. Default: .Chart.AppVersion | "" |
| `images.sregistry.port`    | uwsgi service port | `3031` |
| `images.nginx.ingress`     | Enable ingress to expose the nginx web server | `false` |
| `images.nginx.type`        | Nginx service type | `ClusterIP` |
| `images.nginx.maxBodySize`        | Set NGinx client_max_body_size which is propagated to Ingress | `10024M` |
| `images.nginx.bodyBufferSize` | Set NGinx client_body_buffer_size which is propagated to Ingress | `10024M` |
| `images.nginx.bodyTimeout` | Set NGinx client timeout | `120` |
| `images.nginx.tlsSecretName` | Enable Ingress TLS with certificate secret | `""` |
| `images.nginx.image`       | Nginx web server image | `quay.io/vanessa/sregistry_nginx` |
| `images.nginx.tag`         | Image tag override. Default: .Chart.AppVersion | "" |
| `images.nginx.port`        | nginx service port | `80` |
| `statefulset.updateStrategy` | Update strategy: RollingUpdate or OnDelete | `RollingUpdate` |
| `statefulset.podManagementPolicy` | Ordering guarantees | `Parallel` |
| `statefulset.replicaCount` | Number of replicas | `1` |
| `livenessProbe`            | Liveness probes | See `values.yaml` for details |
| `readinessProbe`           | Readiness probes | See `values.yaml` for details |
| `persistence.enabled`      | Enable dynamic volume provisioning | `false` |
| `persistence.accessMode`   | Access mode | `ReadWriteOnce` |
| `persistence.size`         | Volume sizes to be created | `1Gi` |
| `auth.plugins`             | List of available authentication plugins | `[ "google" , "twitter" , "github" , "gitlab" , "bitbucket" ]` |
| `auth.customPlugins`       | List of configMaps to mount as additional plugins | `[]` |
| `auth.enabled`             | Plugins to enable with credentials and extra arguments | See `values.yaml` for defaults |
| `podSecurityContext`       | Pod security context | {} |
| `securityContext`          | Security context | {} |
| `nodeSelector`             | Node labels for assignment | {} |
| `tolerations`              | Tolerations for pod assignment | {} |
| `resources`                | Registry containers resource requests and limits | See `value.yaml` for details |
| `affinity`                 | Affinity for pod assignment | {} |
