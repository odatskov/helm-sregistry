# Singularity Registry Helm Chart

This folder contains a Kubernete Helm chart for deploying a Singularity registry.

## Prerequisites

* Persistent Volume support if needed.

## Chart Details

This chart will do the following:

* Implements Singularity Registry deployment

## Installing the Chart

To install the chart, use the following:

```
~$ helm install sregistry
```

## Configuration

The table below lists all configurable parameters for the sregistry chart along with their default values. Pass each parameter with ```--set key=value,[,key=value]``` to ```helm install``` to customise execution.

| Parameter | Description | Default |
|:----------|:------------|:--------|
