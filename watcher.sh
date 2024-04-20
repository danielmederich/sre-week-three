#!/bin/bash

# Define variables
NAMESPACE="sre"
DEPLOYMENT_NAME="swype-app"
MAX_RESTARTS=3

# Infinite loop to monitor the pod restarts
while true; do
    # Fetch the number of restarts for the specified deployment
    CURRENT_RESTARTS=$(kubectl get pods -n ${NAMESPACE} -l app=${DEPLOYMENT_NAME} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")

    # Display the current number of restarts
    echo "Current restart count for $DEPLOYMENT_NAME: $CURRENT_RESTARTS"

    # Check if the current number of restarts is greater than the allowed maximum
    if [ "$CURRENT_RESTARTS" -gt "$MAX_RESTARTS" ]; then
        echo "Restart limit exceeded. Scaling down $DEPLOYMENT_NAME."
        # Scale down the deployment to zero replicas
        kubectl scale deployment $DEPLOYMENT_NAME --replicas=0 -n $NAMESPACE
        # Exit the loop and script
        break
    else
        # Pause the script for 60 seconds before the next check
        sleep 60
    fi
done
