# Setup Monitoring System with Prometheus and Grafana

Once we have a running node (bp and/or relays), it is suggested to set up a monitoring
system to check its performance over time. The Cardano node natively provides metrics
for the Prometheus and EKG monitorig system. This guide provides a step-by-step
instruction in order to retrieve the Prometheus metrics from all your nodes and
represent them in a nice graphical Grafana dashboard (as shown in the example below).

![Grafana dashboard](/images/grafana-dashboard-example.png "Example Grafana dashboard")

## Prerequisites

The following instructions assume that we have successfully built a Cardano node docker image
based on the instructions provided in this Github repository. 

## Configure Node for Prometheus

Make sure there is no node docker container running. If it is the case, stop it and remove it.

```
docker stop [CONTAINER_ID]
docker rm [CONTAINER_ID]
```

Modify the run-node.sh script in order to add port forwarding for the Prometheus metrics (port 12798).

The exmple below shows the "docker run" command, within the modified run-node.sh script, with port
forwarding for the Prometheus metrics. 

```
docker run --name "cardano-node-${NETWORK}" -d -v $DB_FOLDER:/db -v /home/ubuntu/cardano-staking-pool-edu-copy/cardano-node/config/testnet:/etc/config/cardano-node/config -v /home/ubuntu/.keys/testnet:/etc/config/cardano-node/keys -p 30001:30001 -p 12798:12798 -e CARDANO_NODE_SOCKET_PATH=/db/node.socket
"${@:3}" "cardano-node:${IMAGE_TAG} \
"cardano-node run \
--topology /etc/config/cardano-node/config/${NETWORK}-topology.json \
--database-path /db \
--socket-path /db/node.socket \
--host-addr 0.0.0.0 \
--port $CARDANO_NODE_PORT \
--config /etc/config/cardano-node/config/${NETWORK}-config.json \
--shelley-kes-key ${KES_SKEY_PATH} \
--shelley-vrf-key ${VRF_SKEY_PATH} \
--shelley-operational-certificate ${NODE_OP_CERT_PATH}"
```

We can now start the node.

```
cd ~/cardano-staking-pool-edu-copy/cardano-node
NETWORK=testnet ./run-node.sh /home/ubuntu/cardano-node/testnet 30001 --restart unless-stopped
```

Check that the port forwarding for the Prometheus port 12798 is active under PORTS. You should see something like this:

```
docker ps 

CONTAINER ID   IMAGE                         COMMAND            CREATED      STATUS        PORTS                                                NAMES
c3222adef0e1   cardano-node-1.30.1-aarch64   "entrypoint run"   5 days ago   Up 33 hours   0.0.0.0:3001->3001/tcp, 0.0.0.0:12798->12798/tcp          cardano-node-mainnet-1.30.1
```

## Setup Prometheus Server

We now need to set up a Prometheus server that scrapes the Prometheus metrics from the node
via the 12798 port. For this it is recommended to use a separate RaspPi that takes care of this job only.

Install Prometheus on this device.

```
sudo apt install prometheus 
```

We need to configure the prometheus.yml file so that the server is scaping the metrics from
the cardano node.

```
sudo nano /etc/prometheus/prometheus.yml 
```

Scroll down to the section 'scrape_config' and add the nodes IP and name it. 
This example shows the prometheus.yml file for a Cardano pool with totally 4 nodes (1 BP and 3 Relays).

```
scrape_configs:
- job_name: cardano
  scrape_interval: 15s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets:
    - [RELAY1_IP]:12798
    labels:
      alias: relay1
      type: cardano-node
  - targets:
    - [RELAY2_IP]:12798
    labels:
      alias: relay2
      type: cardano-node
  - targets:
    - [RELAY3_IP]:12798
    labels:
      alias: relay3
      type: cardano-node
  - targets:
    - [BP_IP]:12798
    labels:
      alias: BP
      type: cardano-node
- job_name: node
  scrape_interval: 15s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets:
    - [RELAY1_IP]:9100
    labels:
      alias: relay1
      type: host-system
  - targets:
    - [RELAY2_IP]:9100
    labels:
      alias: relay2
      type: host-system
  - targets:
    - [RELAY3_IP]:9100
    labels:
      alias: relay3
      type: host-system
  - targets:
    - [BP_IP]:9100
    labels:
      alias: bp
      type: host-system
```

Let’s restart the Prometheus service with the new configuration.

```
sudo systemctl restart prometheus.service
```

The Prometheus server can now be accessed via web browser. Open the web browser
and enter the address http://localhost:9090/graph. You should see the following screen:

![Prometheus mainscreen](/images/prometheus-main-example.png "Example Prometheus mainscreen")

Go to Status > Targets and you should see a screen like the one below.

![Prometheus targetscreen](/images/prometheus-targets-example.png "Example Prometheus targetscreen")

If you have followed all the steps so far, we should see the state of the cardano nodes UP.
Congratulations, you are now submitting your Cardano node data to your Promemtheus server.

If you have configured the node_export metrics (port 9100) in your prometheus.yml before, you might
still see the state DOWN. No worry, we will fix that in the next chapter.

## Install Grafana & Configure a Cardano Dashboard

Prometheus is certainly a great monitoring tool but as soon as we’d like to represent several
metrics on the same dashboard for a better overview of the nodes performance, then Prometheus
could become inadequate. Grafana provides a much better graphical representation of the metrics
provided by Prometheus. So let us install and configure a nice Grafana dashboard.

First we need to download and extract the Prometheus node_exporter on all your node host systems.
This allows us to scrape additional important metrics about the node that are not provided
within the cardano-node metrics. Log into your node and execute the following commands:

```
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-arm64.tar.gz
tar xvfz node_exporter-1.1.2.linux-arm64.tar.gz
cd node_exporter-1.1.2.linux-arm64
```

Since we want to run node_exporter in a continuous mode in the background, we use tmux.
This allows us to run a session in parallel in the background. Just remember that you have to
execute the same commands each time you shutdown or restart the node completely:

```
tmux
./node_exporter
```

Press the following key combination ^b d (Control + b together followed by d). This will put the running tmux session
in the background without closing it (remember, we need the node_exporter to run in a continuous mode).

Execute "tmux ls". This command lists all the tmux session running in the background:

```
tmux ls

0: 1 windows (created Mon May 24 15:53:15 2021)
```

The node_exporter is now running (in the background) on the node host machine under port 9100. 
At this point we need to enable this port in the firewall:

```
sudo ufw allow 9100/tcp
```

We have to install Grafana on our monitoring server now.
Note: To download the latest version of Grafana visit their site: https://grafana.com/grafana/download?platform=arm

```
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_7.5.7_arm64.deb
sudo dpkg -i grafana_7.5.7_arm64.deb
```

Start the Grafana-server:

```
sudo /bin/systemctl start grafana-server
```

Open the web browser and go to localhost:3000. The Grafana client login screen should appear:

![Grafana loginscreen](/images/grafana-login-example.png "Example Grafana loginscreen")

From this point onwards we refer to the official Cardano-node documentation for the configuration
of the Grafana dashboard. Go to https://docs.cardano.org/projects/cardanonode/en/latest/logging-monitoring/grafana.html
and follow the instructions in the chapter Configuring your dashboard.









 








