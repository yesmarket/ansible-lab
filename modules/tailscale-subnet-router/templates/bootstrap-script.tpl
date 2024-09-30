#!/bin/bash
sudo tailscale up --authkey=${auth_key} --advertise-routes=${advertised_routes}
